import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/navigation_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'todo_screen.dart';
import 'settings_screen.dart';
import 'device_info_screen.dart';
import 'location_map_view.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});

  final NavigationViewModel navVM = Get.put(NavigationViewModel());

  final List<Widget> pages = [
    DeviceInfoScreen(),
    TodoScreen(),
    ExpandableMapView(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Example: Watch a provider
    // final locationState = ref.watch(locationProvider);

    return Obx(() => Scaffold(
          body: pages[navVM.selectedIndex.value],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: navVM.selectedIndex.value,
            onTap: navVM.changeIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.black,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.check_circle),
                label: "Device Info",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: "Todo",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.location_history),
                label: "Other Phone Locations",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "Settings",
              ),
            ],
          ),
        ));
  }
}
