import 'package:bibliz/ui/management_proxy/management_service.dart';
import 'package:flutter/material.dart';

class ManagementImplService implements ManagementService {
  @override
  Widget getManagementButton(
      BuildContext context, dynamic loadBooks, int count, String route, String title) {
    Widget widget;

    widget = ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary),
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        child: Text(
          title,
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ));

    return widget;
  }
}
