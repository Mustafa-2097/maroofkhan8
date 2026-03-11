class ApiEndpoints {
  /// Base URL
  static const String baseUrl = 'http://206.162.244.189:5001/api/v1';
  static const String aiExplanationGeneral =
      "http://204.197.173.4:8060/api/ai-murshid/ai-explanation";
  static const String quranExplanationMeditation =
      "http://204.197.173.4:8060/api/ai-murshid/quran-explanation";

  /// Auth
  static const String register = '$baseUrl/auth/register';
  static const String verifySignUpOtp = '$baseUrl/auth/verify-otp';
  static const String resendOtp = '$baseUrl/auth/resend-otp';
  static const String login = '$baseUrl/auth/login';
  static const String logout = '$baseUrl/auth/logout';
  static const String changePassword = '$baseUrl/auth/change-password';

  /// Forgot Password
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String sendResetOtp = '$baseUrl/auth/send-otp/password-reset';
  static const String verifyResetOtp =
      '$baseUrl/auth/verify-otp/password-reset';

  /// Reset password (NEW)
  static const String resetPassword = '$baseUrl/auth/reset-password';

  /// Users Profile
  static const String getMe = '$baseUrl/me';
  static const String userActivity = '$baseUrl/me/activity';
  static const String mePing = '$baseUrl/me/ping';
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
  static const String surah = '$baseUrl/quran/chapters';
  static String surahDetails(String id) => '$baseUrl/quran/chapters/$id/verses';
  static String surahTafsir(String id) => '$baseUrl/quran/chapters/$id/tafsir';
  static String surahAudio(String id) =>
      '$baseUrl/quran/chapters/$id/audio?segments=true';
  static const String juzs = '$baseUrl/quran/juzs?series=1';
  static const String lastRead = '$baseUrl/quran/last-read';
  static String deleteLastRead(String id) => '$baseUrl/quran/last-read/$id';
  static const String quranSaved = '$baseUrl/quran/saved';
  static String deleteQuranSaved(String id) => '$baseUrl/quran/saved/$id';

  /// Duas
  static const String duas = '$baseUrl/duas';

  /// Hadith
  static const String hadithBooks = '$baseUrl/hadith/books';
  static String hadithChapters(String slug) => '$baseUrl/hadith/$slug/chapters';
  static String hadithList(String slug, String chapter) =>
      '$baseUrl/hadith/$slug/hadiths?chapter=$chapter';
  static const String popularHadith = '$baseUrl/hadith/popular';
  static const String lastReadHadith = '$baseUrl/hadith/last-read';
  static const String savedHadith = '$baseUrl/hadith/saved';
  static String deleteSavedHadith(String id) => '$baseUrl/hadith/saved/$id';

  /// Stories
  static const String stories = '$baseUrl/stories';
  static String storyDetails(String id) => '$baseUrl/stories/$id';

  /// Ahl Al Bayt
  static const String ahlalbayt = '$baseUrl/ahlalbayt';
  static String ahlalbaytDetails(String id) => '$baseUrl/ahlalbayt/$id';

  /// Awliya
  static const String awliya = '$baseUrl/awliya';
  static String awliyaDetails(String id) => '$baseUrl/awliya/$id';

  /// Sahaba
  static const String sahaba = '$baseUrl/sahaba';
  static String sahabaDetails(String id) => '$baseUrl/sahaba/$id';

  /// Tasbih (Dhikr)
  static const String tasbih = '$baseUrl/tasbih';

  /// Allah Names
  static const String allahNames = '$baseUrl/names/allah';
  static String toggleAllahNameSave(String id) =>
      '$baseUrl/names/allah/$id/save';
  static const String savedAllahNames = '$baseUrl/names/allah/saved';
  static String deleteSavedAllahName(String id) =>
      '$baseUrl/names/allah/save/$id';
  static const String salawat = '$baseUrl/salawat';
  static String toggleSalawatSave(String id) => '$baseUrl/salawat/$id/save';
  static const String savedSalawat = '$baseUrl/salawat/saved';
  static String deleteSavedSalawat(String id) => '$baseUrl/salawat/save/$id';
  static const String books = '$baseUrl/books';
  static const String meditation = '$baseUrl/meditation';
  static String singleMeditation(String id) => '$baseUrl/meditation/$id';
  static const String islamicNames = '$baseUrl/names';
  static const String savedIslamicNames = '$baseUrl/names/saved';
  static String toggleIslamicNameSave(String id) => '$baseUrl/names/$id/save';
  static String deleteSavedIslamicName(String id) => '$baseUrl/names/save/$id';
  static const String profile = '$baseUrl/me';
  static const String subscriptionPlan = '$baseUrl/subscription-plan';
  static const String audio = '$baseUrl/audio';
  static String singleAudio(String id) => '$baseUrl/audio/$id';
  static const String guidedMeditation = '$baseUrl/sufism/guided-meditation';
  static String singleGuidedMeditation(String id) =>
      '$baseUrl/sufism/guided-meditation/$id';
  static const String islamicTeacher = '$baseUrl/sufism/islamic-teacher';
  static String singleIslamicTeacher(String id) =>
      '$baseUrl/sufism/islamic-teacher/$id';

  static const String bannerQuote = '$baseUrl/banner-quote';
  static const String contactUs = '$baseUrl/contact-us';

  /// Payments
  static String createCheckoutSession(String planId) =>
      '$baseUrl/payments/create-checkout-session/$planId';
  static const String createDonationSession =
      '$baseUrl/payments/create-donation-session';
  static const String paymentHistory = '$baseUrl/payments';
  static String prayer(double lat, double long) =>
      '$baseUrl/prayer?lat=$lat&long=$long';
}
