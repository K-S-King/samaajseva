class AppConstants {
  // App Info
  static const String appName = 'Earn. Give. Impact.';
  static const String appVersion = '1.0.0';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String donationsCollection = 'donations';
  static const String transactionsCollection = 'transactions';

  // Credit System
  static const int creditsPerAd = 10;
  static const double rupeesPerCredit = 0.1; // ₹0.10 per credit
  //adi static void main
  // Ad IDs (Replace with your actual AdMob IDs)
  static const String androidRewardedAdId =
      'ca-app-pub-3940256099942544/5224354917'; // Test ID
  static const String iosRewardedAdId =
      'ca-app-pub-3940256099942544/1712485313'; // Test ID

  // Razorpay Keys (Replace with your actual keys)
  static const String razorpayKeyId = 'rzp_test_1DP5mmOlF5G5ag'; // Test key
  static const String razorpayKeySecret = 'YOUR_SECRET_KEY';

  // Minimum Donation Amount
  static const double minDonationAmount = 10.0;
  static const double maxDonationAmount = 100000.0;
}
