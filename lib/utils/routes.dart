import 'package:get/get.dart';
import 'package:motorhome/views/screens/main_frame.dart';

class MHRoutes {
  static const main = '/main';
}

List<GetPage<dynamic>>? appRoutes = [
  GetPage(name: MHRoutes.main, page: () => const MainScreen()),
];

enum Pages {
  home,
  lights,
  motors,
  energy,
  heating,
  music,
  config
}
