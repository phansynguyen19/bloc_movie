class RequestTokenModel {
  final bool success;
  final String requestToken;
  final String expiresAt;
  final String? status_code;
  final String? status_message;
  final String? session_id;

  RequestTokenModel(
    this.success,
    this.requestToken,
    this.expiresAt,
    this.status_code,
    this.status_message,
    this.session_id,
  );

  factory RequestTokenModel.fromJson(Map<String, dynamic> json) {
    return RequestTokenModel(
      json['success'],
      json['request_token'],
      json['expires_at'],
      json['status_code'],
      json['status_message'],
      json['session_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'request_token': requestToken,
      };
}

class SessionModel {
  final bool success;
  final String session_id;

  SessionModel(
    this.success,
    this.session_id,
  );

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      json['success'],
      json['session_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'session_id': session_id,
      };
}
