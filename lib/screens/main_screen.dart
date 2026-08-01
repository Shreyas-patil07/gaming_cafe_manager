import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import 'devices_page.dart';
import 'queue_page.dart';
import 'sessions_page.dart';
import 'history_page.dart';
import 'analytics_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 2;

  static const pages = [
    DevicesPage(),
    QueuePage(),
    SessionsPage(),
    HistoryPage(),
    AnalyticsPage(),
  ];

  final PageController pageController =
  PageController(
    initialPage: 2,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppHeader(),
          Expanded(
            child: PageView(
              controller: pageController,

              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },

              children: pages,
            ),
          ),
        ],
      ),

      bottomNavigationBar: NavigationBar(
        height: 75,

        selectedIndex: currentIndex,

        onDestinationSelected: (index) {
          pageController.animateToPage(
            index,
            duration: const Duration(
              milliseconds: 300,
            ),
            curve: Curves.easeInOut,
          );

          setState(() {
            currentIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.computer_outlined),
            selectedIcon: Icon(Icons.computer),
            label: 'Devices',
          ),

          NavigationDestination(
            icon: Icon(Icons.queue_outlined),
            selectedIcon: Icon(Icons.queue),
            label: 'Queue',
          ),

          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer),
            label: 'Sessions',
          ),

          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'History',
          ),

          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

}