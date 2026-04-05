class ApiResponse<T> {
  final T? data;
  final String message;

  ApiResponse({this.data, required this.message});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ApiResponse(
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      message: json['message'] ?? '',
    );
  }
}
