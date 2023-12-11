import 'package:bibliz/ui/management_proxy/management_service.dart';
import 'package:flutter/material.dart';

class ManagementImplService implements ManagementService {
  /*
    Fonction permettant de retourner un bouton différent avec la fonction, la route etc selon les paramètres
  */
  @override
  Widget getManagementButton(
      BuildContext context, Future<void> Function(int count) loadBooks, int count, String route, String title) {
    Widget widget;

    widget = ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary),
        onPressed: () async {
          await Navigator.pushNamed(context, route);
          await loadBooks(count);
        },
        child: Text(
          title,
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ));

    return widget;
  }
}
