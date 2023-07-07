import 'package:get/get.dart';

class SideMenuController extends GetxController {
  static SideMenuController instance = Get.find();

  var selectedPageIndex = 0.obs;
  var selectedMobilePageIndex = 0.obs;

  void selectPage(int index) {
    selectedPageIndex.value = index;
  }

  void selectMobilePage(int index) {
    selectedMobilePageIndex.value = index;
  }

  // isActive(String itemName) => activeItem.value == itemName;

  String titleForEachTab(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return '';
      case 1:
        return " > ToDo-Listing";
      case 2:
        return ' > Inventory-Listing';
      case 3:
        return ' > Lead-Listing';
      case 4:
        return ' > Chat';
      case 5:
        return ' > Calendar';
      default:
        return 'Home';
    }
  }

  // Widget customIcon(IconData icon, String itemName) {
  //   if (isActive(itemName)) return Icon(icon, size: 22, color: darkTheme);

  //   return Icon(
  //     icon,
  //     color: isHovering(itemName) ? darkTheme : lightGrey,
  //   );
  // }
}
