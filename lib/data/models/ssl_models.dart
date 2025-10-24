/// SSL certificate management data models for 1Panel V2 API
///
/// This file contains all data models related to SSL certificate management,
/// including certificate creation, renewal, validation, etc.

import 'package:equatable/equatable.dart';

/// SSL certificate type enumeration
enum SSLCertificateType {
  selfSigned('self-signed'),
  letsEncrypt('lets-encrypt'),
  custom('custom');

  const SSLCertificateType(this.value);
  final String value;

  static SSLCertificateType fromString(String value) {
    return SSLCertificateType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => SSLCertificateType.custom,
    );
  }
}

/// SSL certificate status enumeration
enum SSLCertificateStatus {
  valid('valid'),
  expired('expired'),
  expiring('expiring'),
  invalid('invalid'),
  pending('pending');

  const SSLCertificateStatus(this.value);
  final String value;

  static SSLCertificateStatus fromString(String value) {
    return SSLCertificateStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => SSLCertificateStatus.invalid,
    );
  }
}

/// SSL certificate creation request model
class SSLCertificateCreate extends Equatable {
  final List<String> domains;
  final String certificateType;
  final String? email;
  final String? privateKey;
  final String? certificate;
  final String? chain;
  final String? keyType;
  final bool? autoRenew;
  final int? websiteId;

  const SSLCertificateCreate({
    required this.domains,
    required this.certificateType,
    this.email,
    this.privateKey,
    this.certificate,
    this.chain,
    this.keyType,
    this.autoRenew,
    this.websiteId,
  });

  factory SSLCertificateCreate.fromJson(Map<String, dynamic> json) {
    return SSLCertificateCreate(
      domains: (json['domains'] as List?)?.map((e) => e as String).toList() ?? [],
      certificateType: json['certificateType'] as String,
      email: json['email'] as String?,
      privateKey: json['privateKey'] as String?,
      certificate: json['certificate'] as String?,
      chain: json['chain'] as String?,
      keyType: json['keyType'] as String?,
      autoRenew: json['autoRenew'] as bool?,
      websiteId: json['websiteId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'domains': domains,
      'certificateType': certificateType,
      'email': email,
      'privateKey': privateKey,
      'certificate': certificate,
      'chain': chain,
      'keyType': keyType,
      'autoRenew': autoRenew,
      'websiteId': websiteId,
    };
  }

  @override
  List<Object?> get props => [domains, certificateType, email, privateKey, certificate, chain, keyType, autoRenew, websiteId];
}

/// SSL certificate information model
class SSLCertificateInfo extends Equatable {
  final int? id;
  final List<String>? domains;
  final String? certificateType;
  final String? issuer;
  final String? subject;
  final String? serialNumber;
  final String? signatureAlgorithm;
  final String? keyType;
  final String? fingerprint;
  final String? startDate;
  final String? expireDate;
  final int? days;
  final SSLCertificateStatus? status;
  final bool? autoRenew;
  final int? websiteId;
  final String? websiteName;
  final String? createTime;
  final String? updateTime;

  const SSLCertificateInfo({
    this.id,
    this.domains,
    this.certificateType,
    this.issuer,
    this.subject,
    this.serialNumber,
    this.signatureAlgorithm,
    this.keyType,
    this.fingerprint,
    this.startDate,
    this.expireDate,
    this.days,
    this.status,
    this.autoRenew,
    this.websiteId,
    this.websiteName,
    this.createTime,
    this.updateTime,
  });

  factory SSLCertificateInfo.fromJson(Map<String, dynamic> json) {
    return SSLCertificateInfo(
      id: json['id'] as int?,
      domains: (json['domains'] as List?)?.map((e) => e as String).toList(),
      certificateType: json['certificateType'] as String?,
      issuer: json['issuer'] as String?,
      subject: json['subject'] as String?,
      serialNumber: json['serialNumber'] as String?,
      signatureAlgorithm: json['signatureAlgorithm'] as String?,
      keyType: json['keyType'] as String?,
      fingerprint: json['fingerprint'] as String?,
      startDate: json['startDate'] as String?,
      expireDate: json['expireDate'] as String?,
      days: json['days'] as int?,
      status: json['status'] != null ? SSLCertificateStatus.fromString(json['status'] as String) : null,
      autoRenew: json['autoRenew'] as bool?,
      websiteId: json['websiteId'] as int?,
      websiteName: json['websiteName'] as String?,
      createTime: json['createTime'] as String?,
      updateTime: json['updateTime'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'domains': domains,
      'certificateType': certificateType,
      'issuer': issuer,
      'subject': subject,
      'serialNumber': serialNumber,
      'signatureAlgorithm': signatureAlgorithm,
      'keyType': keyType,
      'fingerprint': fingerprint,
      'startDate': startDate,
      'expireDate': expireDate,
      'days': days,
      'status': status?.value,
      'autoRenew': autoRenew,
      'websiteId': websiteId,
      'websiteName': websiteName,
      'createTime': createTime,
      'updateTime': updateTime,
    };
  }

  @override
  List<Object?> get props => [
        id,
        domains,
        certificateType,
        issuer,
        subject,
        serialNumber,
        signatureAlgorithm,
        keyType,
        fingerprint,
        startDate,
        expireDate,
        days,
        status,
        autoRenew,
        websiteId,
        websiteName,
        createTime,
        updateTime
      ];
}

/// SSL certificate search request model
class SSLCertificateSearch extends Equatable {
  final int? page;
  final int? pageSize;
  final String? search;
  final String? certificateType;
  final SSLCertificateStatus? status;
  final String? domain;

  const SSLCertificateSearch({
    this.page,
    this.pageSize,
    this.search,
    this.certificateType,
    this.status,
    this.domain,
  });

  factory SSLCertificateSearch.fromJson(Map<String, dynamic> json) {
    return SSLCertificateSearch(
      page: json['page'] as int?,
      pageSize: json['pageSize'] as int?,
      search: json['search'] as String?,
      certificateType: json['certificateType'] as String?,
      status: json['status'] != null ? SSLCertificateStatus.fromString(json['status'] as String) : null,
      domain: json['domain'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'pageSize': pageSize,
      'search': search,
      'certificateType': certificateType,
      'status': status?.value,
      'domain': domain,
    };
  }

  @override
  List<Object?> get props => [page, pageSize, search, certificateType, status, domain];
}

/// SSL certificate update request model
class SSLCertificateUpdate extends Equatable {
  final int id;
  final List<String>? domains;
  final bool? autoRenew;
  final String? email;
  final String? privateKey;
  final String? certificate;
  final String? chain;

  const SSLCertificateUpdate({
    required this.id,
    this.domains,
    this.autoRenew,
    this.email,
    this.privateKey,
    this.certificate,
    this.chain,
  });

  factory SSLCertificateUpdate.fromJson(Map<String, dynamic> json) {
    return SSLCertificateUpdate(
      id: json['id'] as int,
      domains: (json['domains'] as List?)?.map((e) => e as String).toList(),
      autoRenew: json['autoRenew'] as bool?,
      email: json['email'] as String?,
      privateKey: json['privateKey'] as String?,
      certificate: json['certificate'] as String?,
      chain: json['chain'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'domains': domains,
      'autoRenew': autoRenew,
      'email': email,
      'privateKey': privateKey,
      'certificate': certificate,
      'chain': chain,
    };
  }

  @override
  List<Object?> get props => [id, domains, autoRenew, email, privateKey, certificate, chain];
}

/// SSL certificate operation model
class SSLCertificateOperate extends Equatable {
  final List<int> ids;
  final String operation;

  const SSLCertificateOperate({
    required this.ids,
    required this.operation,
  });

  factory SSLCertificateOperate.fromJson(Map<String, dynamic> json) {
    return SSLCertificateOperate(
      ids: (json['ids'] as List?)?.map((e) => e as int).toList() ?? [],
      operation: json['operation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ids': ids,
      'operation': operation,
    };
  }

  @override
  List<Object?> get props => [ids, operation];
}

/// SSL certificate validation result model
class SSLCertificateValidation extends Equatable {
  final bool? isValid;
  final bool? isTrusted;
  final bool? isExpired;
  final bool? isSelfSigned;
  final int? daysUntilExpiry;
  final List<String>? errors;
  final List<String>? warnings;

  const SSLCertificateValidation({
    this.isValid,
    this.isTrusted,
    this.isExpired,
    this.isSelfSigned,
    this.daysUntilExpiry,
    this.errors,
    this.warnings,
  });

  factory SSLCertificateValidation.fromJson(Map<String, dynamic> json) {
    return SSLCertificateValidation(
      isValid: json['isValid'] as bool?,
      isTrusted: json['isTrusted'] as bool?,
      isExpired: json['isExpired'] as bool?,
      isSelfSigned: json['isSelfSigned'] as bool?,
      daysUntilExpiry: json['daysUntilExpiry'] as int?,
      errors: (json['errors'] as List?)?.map((e) => e as String).toList(),
      warnings: (json['warnings'] as List?)?.map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isValid': isValid,
      'isTrusted': isTrusted,
      'isExpired': isExpired,
      'isSelfSigned': isSelfSigned,
      'daysUntilExpiry': daysUntilExpiry,
      'errors': errors,
      'warnings': warnings,
    };
  }

  @override
  List<Object?> get props => [isValid, isTrusted, isExpired, isSelfSigned, daysUntilExpiry, errors, warnings];
}

/// ACME account model (for Let's Encrypt)
class ACMEAccount extends Equatable {
  final int? id;
  final String? email;
  final String? server;
  final String? status;
  final bool? registered;
  final String? kid;
  final String? createdAt;

  const ACMEAccount({
    this.id,
    this.email,
    this.server,
    this.status,
    this.registered,
    this.kid,
    this.createdAt,
  });

  factory ACMEAccount.fromJson(Map<String, dynamic> json) {
    return ACMEAccount(
      id: json['id'] as int?,
      email: json['email'] as String?,
      server: json['server'] as String?,
      status: json['status'] as String?,
      registered: json['registered'] as bool?,
      kid: json['kid'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'server': server,
      'status': status,
      'registered': registered,
      'kid': kid,
      'createdAt': createdAt,
    };
  }

  @override
  List<Object?> get props => [id, email, server, status, registered, kid, createdAt];
}

/// SSL certificate challenge model
class SSLCertificateChallenge extends Equatable {
  final String? type;
  final String? token;
  final String? keyAuthorization;
  final String? url;
  final String? status;

  const SSLCertificateChallenge({
    this.type,
    this.token,
    this.keyAuthorization,
    this.url,
    this.status,
  });

  factory SSLCertificateChallenge.fromJson(Map<String, dynamic> json) {
    return SSLCertificateChallenge(
      type: json['type'] as String?,
      token: json['token'] as String?,
      keyAuthorization: json['keyAuthorization'] as String?,
      url: json['url'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'token': token,
      'keyAuthorization': keyAuthorization,
      'url': url,
      'status': status,
    };
  }

  @override
  List<Object?> get props => [type, token, keyAuthorization, url, status];
}