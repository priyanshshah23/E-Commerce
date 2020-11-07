import 'dart:async';
import 'dart:io';
import 'package:diamnow/app/constant/constants.dart';
import 'package:flutter/material.dart';

import 'package:flutter_files_picker/flutter_files_picker.dart';

import 'CustomDialog.dart';

Future openImagePicker(
    BuildContext context, Function getImage(File file)) async {
  FocusScope.of(context).unfocus();
  await FlutterFilePicker.pickImage(
    onFileSelect: (fileArray) {
      if (fileArray != null && fileArray.length > 0) {
        File _imageFile = File(fileArray[0].fileUrl);
        var fileSize = _imageFile.lengthSync() / 1024;
        if (fileSize > IMAGE_FILE_SIZE * 1024) {
          showToast(
            "File size must be less than 10 Mb",
            context: context,
          );
          return null;
        } else {
          getImage(_imageFile);
        }
      }
    },
  );
}

Future openFilePicker(
    BuildContext context, Function getImage(File file)) async {
  FocusScope.of(context).unfocus();
  await FlutterFilePicker.pickAny((fileArray) {
    if (fileArray != null && fileArray.length > 0) {
      File _imageFile = File(fileArray[0].fileUrl);
      var fileSize = _imageFile.lengthSync() / 1024;
      if (fileSize > IMAGE_FILE_SIZE * 1024) {
        showToast(
          "File size must be less than 10 Mb",
          context: context,
        );
        return null;
      } else {
        getImage(_imageFile);
      }
    }
  }, [
    'GALLARY',
    'DOCUMENTS',
  ]);
}
