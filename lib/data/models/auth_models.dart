import 'package:equatable/equatable.dart';

class LoginRequest extends Equatable {
  final String username;
  final String password;
  final String? captcha;
  final String? captchaId;

  const LoginRequest({
    required this.username,
    required this.password,
    this.captcha,
    this.captchaId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': username,
      'password': password,
      if (captcha != null) 'captcha': captcha,
      if (captchaId != null) 'captchaId': captchaId,
    };
  }

  @override
  List<Object?> get props => [username, password, captcha, captchaId];
}

class LoginResponse extends Equatable {
  final String? token;
  final String? name;
  final bool? mfaStatus;
  final String? message;

  const LoginResponse({
    this.token,
    this.name,
    this.mfaStatus,
    this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String?,
      name: json['name'] as String?,
      mfaStatus: json['mfaStatus'] as bool?,
      message: json['message'] as String?,
    );
  }

  @override
  List<Object?> get props => [token, name, mfaStatus, message];
}

class MfaLoginRequest extends Equatable {
  final String code;
  final String? name;

  const MfaLoginRequest({
    required this.code,
    this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      if (name != null) 'name': name,
    };
  }

  @override
  List<Object?> get props => [code, name];
}

class CaptchaData extends Equatable {
  final String? captchaId;
  final String? imagePath;
  final String? base64;

  const CaptchaData({
    this.captchaId,
    this.imagePath,
    this.base64,
  });

  factory CaptchaData.fromJson(Map<String, dynamic> json) {
    return CaptchaData(
      captchaId: json['captchaId'] as String? ?? json['id'] as String?,
      imagePath: json['imagePath'] as String? ?? json['path'] as String?,
      base64: json['image'] as String? ?? json['base64'] as String?,
    );
  }

  @override
  List<Object?> get props => [captchaId, imagePath, base64];
}

class LoginSettings extends Equatable {
  final bool? captcha;
  final bool? mfa;
  final String? demo;
  final String? title;
  final String? logo;

  const LoginSettings({
    this.captcha,
    this.mfa,
    this.demo,
    this.title,
    this.logo,
  });

  factory LoginSettings.fromJson(Map<String, dynamic> json) {
    return LoginSettings(
      captcha: json['captcha'] as bool?,
      mfa: json['mfa'] as bool?,
      demo: json['demo'] as String?,
      title: json['title'] as String?,
      logo: json['logo'] as String?,
    );
  }

  @override
  List<Object?> get props => [captcha, mfa, demo, title, logo];
}

class SafetyStatus extends Equatable {
  final bool? isSafety;
  final String? message;

  const SafetyStatus({
    this.isSafety,
    this.message,
  });

  factory SafetyStatus.fromJson(Map<String, dynamic> json) {
    return SafetyStatus(
      isSafety: json['issafety'] as bool? ?? json['isSafety'] as bool?,
      message: json['message'] as String?,
    );
  }

  @override
  List<Object?> get props => [isSafety, message];
}

class DemoModeStatus extends Equatable {
  final bool? isDemo;
  final String? message;

  const DemoModeStatus({
    this.isDemo,
    this.message,
  });

  factory DemoModeStatus.fromJson(Map<String, dynamic> json) {
    return DemoModeStatus(
      isDemo: json['demo'] as bool? ?? json['isDemo'] as bool?,
      message: json['message'] as String?,
    );
  }

  @override
  List<Object?> get props => [isDemo, message];
}
