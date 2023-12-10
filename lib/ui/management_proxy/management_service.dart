import 'package:flutter/material.dart';

abstract class ManagementService {
  Widget getManagementButton(
      BuildContext context, dynamic loadBooks, int count, String route, String title);
}
