import 'package:flutter/material.dart';

abstract class ManagementService {
  Widget getManagementButton(
      BuildContext context,
      Future<void> Function(int count) loadBooks,
      int count,
      String route,
      String title);
}
