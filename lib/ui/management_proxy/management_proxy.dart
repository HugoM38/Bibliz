import 'package:bibliz/database/users/user_roles.dart';
import 'package:bibliz/ui/management_proxy/management_impl_service.dart';
import 'package:bibliz/ui/management_proxy/management_service.dart';
import 'package:bibliz/utils/sharedprefs.dart';
import 'package:flutter/material.dart';

/*
    Utilisation du designe pattern Proxy
*/
class ManagementProxy implements ManagementService {
  ManagementService managementService = ManagementImplService();
  /*
    Fonction permettant de revnoyer un bouton selon le rôle de l'utilisateur,
    ce qui permet de réguler les accès aux différentes partie de Bibliz.
  */
  @override
  Widget getManagementButton(
      BuildContext context,
      Future<void> Function(int count) loadBooks,
      int count,
      String route,
      String title) {
    Widget widget;
    switch (SharedPrefs().getCurrentUserRole()) {
      case UserRole.member:
        widget = managementService.getManagementButton(
            context, loadBooks, count, "/edit_profil", "Modifier mon profil");
        break;
      case UserRole.librarian:
        widget = managementService.getManagementButton(
            context, loadBooks, count, "/book_management", "Gérer les livres");
        break;
      case UserRole.administrator:
        widget = managementService.getManagementButton(
            context, loadBooks, count, "/administration", "Administration");
        break;
      default:
        widget = managementService.getManagementButton(
            context, loadBooks, count, "/edit_profil", "Modifier mon profil");
        break;
    }

    return widget;
  }
}
