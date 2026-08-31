import 'package:flutter_test/flutter_test.dart';
import 'package:onepanel_client/api/v2/openresty_v2.dart';
import 'package:onepanel_client/api/v2/setting_v2.dart';
import 'package:onepanel_client/api/v2/ssl_v2.dart';
import 'package:onepanel_client/api/v2/website_v2.dart';
import 'package:onepanel_client/core/network/dio_client.dart';
import 'package:onepanel_client/core/services/logger/logger_service.dart';
import 'package:onepanel_client/data/models/openresty_models.dart';
import 'package:onepanel_client/data/models/ssl_models.dart';

import '../core/test_config_manager.dart';

void main() {
  group('S2-3 Security & Gateway integration', () {
    test(
        'reads current security state and replays idempotent updates only when destructive mode is enabled',
        () async {
      await TestEnvironment.initialize();
      if (!TestEnvironment.runIntegrationTests) {
        return;
      }

      final client = DioClient(
        baseUrl: TestEnvironment.baseUrl,
        apiKey: TestEnvironment.apiKey,
      );
      final settingApi = SettingV2Api(client);
      final sslApi = SSLV2Api(client);
      final websiteApi = WebsiteV2Api(client);
      final openrestyApi = OpenRestyV2Api(client);

      final panelInfo = await settingApi.getSSLInfo();
      expect(panelInfo.data, isNotNull);

      // 服务器未安装 OpenResty / 无默认 HTTPS 配置记录时返回 record not found，
      // 属于服务器状态差异，软跳过（不算失败）。
      final openrestyHttps = await openrestyApi.getOpenRestyHttps().then(
        (response) => response.data,
        onError: (Object e) {
          if (e.toString().contains('record not found')) {
            return null;
          }
          throw e;
        },
      );
      if (openrestyHttps == null) {
        appLogger.wWithPackage(
          'test.integration.security_gateway_s2',
          'SKIP: 服务器未安装 OpenResty 或无默认 HTTPS 配置记录，软跳过后续安全状态回放',
        );
        return;
      }

      final websites = await websiteApi.getWebsites(page: 1, pageSize: 1);
      if (websites.items.isEmpty || websites.items.first.id == null) {
        return;
      }

      final websiteId = websites.items.first.id!;
      final websiteHttps = await websiteApi.getWebsiteHttps(websiteId);
      expect(websiteHttps, isNotNull);
      final websiteSslList = await sslApi.searchWebsiteSSL(
        const WebsiteSSLSearch(page: 1, pageSize: 5),
      );
      expect(websiteSslList.data, isNotNull);

      if (!TestEnvironment.runDestructiveTests) {
        return;
      }

      await openrestyApi.updateOpenRestyHttps(
        OpenrestyDefaultHttpsUpdateRequest(
          operate: openrestyHttps.https == true
              ? OpenrestyDefaultHttpsOperate.enable
              : OpenrestyDefaultHttpsOperate.disable,
          sslRejectHandshake: openrestyHttps.sslRejectHandshake,
        ),
      );

      await websiteApi.updateWebsiteHttps(
        websiteId: websiteId,
        request: WebsiteHttpsUpdateRequest(
          websiteId: websiteId,
          enable: websiteHttps.enable,
          httpConfig: websiteHttps.httpConfig,
          type: 'existed',
          websiteSSLId: websiteHttps.ssl?.id,
          hsts: websiteHttps.hsts,
          hstsIncludeSubDomains: websiteHttps.hstsIncludeSubDomains,
          http3: websiteHttps.http3,
          algorithm: websiteHttps.algorithm,
          sslProtocol: websiteHttps.sslProtocol,
        ),
      );
    });
  });
}
