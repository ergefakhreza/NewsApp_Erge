import 'package:get/get.dart';

import '../views/home_view.dart';
import '../views/detail_view.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.home;

  static final routes = [
    GetPage(name: AppRoutes.home, page: () => const HomeView()),
    GetPage(name: AppRoutes.detail, page: () => const DetailView()),
  ];
}
