// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:issues_tracker/utils/constants/colors.dart';
import 'package:permission_handler/permission_handler.dart';

class HelperFunction {
  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
      ),
    );
  }

  formatDate(var date) {
    return DateFormat.yMMMMd().format(
      date.toDate(),
    );
  }

  pickImage(ImageSource source, BuildContext context) async {
    try {
      XFile? _file = await ImagePicker().pickImage(source: source);

      if (_file != null) {
        return await _file.readAsBytes();
      }
    } catch (e) {
      var status = await Permission.camera.status;
      if (status.isDenied) {
        showSnackBar(context, 'Access Denied');
      } else {
        print(e.toString());
      }
    }
  }

  statusColor(String status, String type) {
    if (type == 'bg') {
      return status == 'Open'
          ? AppColors.hightBg
          : status == 'In Progress'
              ? AppColors.progBg
              : AppColors.selectBg;
    } else if (type == 'text') {
      return status == 'Open'
          ? AppColors.highText
          : status == 'In Progress'
              ? AppColors.progText
              : AppColors.selectText;
    }
  }

  priorityColor(String priority, String type) {
    if (type == 'bg') {
      return priority == 'High'
          ? AppColors.hightBg
          : priority == 'Medium'
              ? AppColors.mediumBg
              : AppColors.lowBg;
    } else if (type == 'text') {
      return priority == 'High'
          ? AppColors.highText
          : priority == 'Medium'
              ? AppColors.mediumText
              : AppColors.lowText;
    }
  }
}
