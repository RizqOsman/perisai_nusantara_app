class ApiConfig {
  // Base URL untuk API
  static const String baseUrl = 'http://172.15.1.21:8000';
  
  // Endpoints
  static const String loginEndpoint = '/login-anggota';
  static const String bukuTamuEndpoint = '/daftar-tamu';
  static const String bukuPaketEndpoint = '/daftar-paket';
  static const String laporanEndpoint = '/laporan';
  static const String activityEndpoint = '/activity';
  static const String emergencyContactEndpoint = '/emergency-contact';
  static const String attendanceEndpoint = '/attendance';
  static const String accidentReportEndpoint = '/accident-report';
  
  // Full URLs
  static String get loginUrl => '$baseUrl$loginEndpoint';
  static String get bukuTamuUrl => '$baseUrl$bukuTamuEndpoint';
  static String get bukuPaketUrl => '$baseUrl$bukuPaketEndpoint';
  static String get laporanUrl => '$baseUrl$laporanEndpoint';
  static String get activityUrl => '$baseUrl$activityEndpoint';
  static String get emergencyContactUrl => '$baseUrl$emergencyContactEndpoint';
  static String get attendanceUrl => '$baseUrl$attendanceEndpoint';
  static String get accidentReportUrl => '$baseUrl$accidentReportEndpoint';
  
  // Headers
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Timeout
  static const int timeoutSeconds = 30;
} 