import 'package:get/get.dart';
import 'package:telugu_matka/Controller/network_controller.dart';

class DependencyInjection {
  static void init() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
  }
}
