import 'package:flutter/material.dart';

class CustomNavigationRail extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomNavigationRail(
      {super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onItemTapped,
      labelType: NavigationRailLabelType.all,
      destinations: [
        const NavigationRailDestination(
          icon: Icon(Icons.edit_location_alt),
          label: Text('Hantera Parkeringsplatser'),
        ),
        // Adding a divider effect using a custom widget
        NavigationRailDestination(
          icon: Container(), // Use an empty icon to create space
          label: const SizedBox(
            height: 20, // You can adjust the height of the divider here
            child: Divider(
              color: Colors.grey, // Divider color
              thickness: 1, // Divider thickness
            ),
          ),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.monitor_heart),
          label: Text('Övervakning'),
        ),
        // Adding another divider effect
        NavigationRailDestination(
          icon: Container(), // Empty icon for spacing
          label: const SizedBox(
            height: 20, // Adjust height as needed
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.bar_chart),
          label: Text('Statistik'),
        ),
      ],
    );
  }
}
