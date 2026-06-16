class ApiEndpoints {
  ApiEndpoints._();

  static const String adopterRegister = '/pengguna/auth/register';
  static const String adopterLogin = '/pengguna/auth/login';
  static const String adopterForgotPassword = '/pengguna/auth/forgot';
  static const String adopterVerifyOtp = '/pengguna/auth/verify';
  static const String adopterChangePassword = '/pengguna/auth/change';
  static const String adopterProfile = '/pengguna/viewPengguna';
  static const String adopterEditProfile = '/pengguna/editPengguna';
  static String adopterAddFavorite(int id) => '/pengguna/addFav/$id';
  static String adopterDeleteFavorite(int id) => '/pengguna/delFav/$id';
  static const String adopterLogout = '/pengguna/logout';
  static const String adopterHomeAnimals = '/animalshelter/pengguna';
  static const String adopterFilterAnimals = '/animalshelter/filter';
  static const String adopterRandomNews = '/pengguna/berita-random';
  static String adopterCreateOrder(int animalId) => '/pesanan/$animalId/create';
  static const String adopterOrderHistory = '/pesanan/pengguna/view';
  static String adopterCreateReview(int animalId) => '/ulasan/$animalId/create';
  static String adopterAnimalReviews(int animalId) => '/ulasan/$animalId';

  static String adopterAnimalDetail(int id) => '/animalshelter/$id';
}
