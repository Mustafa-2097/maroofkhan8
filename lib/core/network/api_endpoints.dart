class ApiEndpoints {
  /// Base URL
  static const String baseUrl = 'http://206.162.244.189:5001/api/v1';
  static const String aiExplanationGeneral =
      "http://204.197.173.4:8060/api/ai-murshid/ai-explanation";

  /// Auth
  static const String register = '$baseUrl/auth/register';
  static const String verifySignUpOtp = '$baseUrl/auth/verify-otp';
  static const String resendOtp = '$baseUrl/auth/resend-otp';
  static const String login = '$baseUrl/auth/login';
  static const String logout = '$baseUrl/auth/logout';
  static const String changePassword = '$baseUrl/auth/change-password';

  /// Forgot Password
  static const String sendResetOtp = '$baseUrl/auth/send-otp/password-reset';
  static const String verifyResetOtp =
      '$baseUrl/auth/verify-otp/password-reset';

  /// Reset password (NEW)
  static const String resetPassword = '$baseUrl/auth/reset-password';

  /// Users Profile
  static const String userProfile = '$baseUrl/users/profile';
  static const String updateProfile = '$baseUrl/users/profile';

  /// Live
  static const String liveScores = '$baseUrl/sports/livescore/Soccer';
  static String upcomingMatches(String leagueId) =>
      '$baseUrl/sports/upcoming/$leagueId';

  /// Table
  static const String leagueTable = '$baseUrl/sports/league-table';

  /// Live TV
  static const String liveTv = '$baseUrl/contents/live-tv';

  /// News
  static const String news = '$baseUrl/news?category=sports';
  /// Quran
  static const String Surah = '$baseUrl/quran/chapters';
}

