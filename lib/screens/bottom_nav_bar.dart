import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    // Define a gradient background for the navigation bar
    return Container(
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade800, Colors.deepPurple.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(context, Icons.home_rounded, 'Home', 0),
            _buildNavItem(context, Icons.bar_chart_rounded, 'Analytics', 1),
            _buildNavItem(context, Icons.settings_rounded, 'Settings', 2),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
  ) {
    final isSelected = selectedIndex == index;

    // Define colors for each navigation item
    final List<Color> itemColors = [
      Colors.pink, // Home
      Colors.amber, // Analytics
      Colors.teal, // Settings
    ];

    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? itemColors[index]
                      : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              boxShadow:
                  isSelected
                      ? [
                        BoxShadow(
                          color: itemColors[index].withOpacity(0.4),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ]
                      : null,
            ),
            child: Center(
              child: Icon(
                icon,
                color:
                    isSelected ? Colors.white : Colors.white.withOpacity(0.6),
                size: isSelected ? 28 : 22,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Widget build(BuildContext context) {
  //   return BottomNavigationBar(
  //     currentIndex: selectedIndex,
  //     onTap: onItemTapped,
  //     selectedItemColor: Colors.deepPurple,
  //     items: const [
  //       BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.bar_chart),
  //         label: 'Analytics',
  //       ),
  //       BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
  //     ],
  //   );
  // }
}
