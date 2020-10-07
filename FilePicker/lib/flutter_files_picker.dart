import 'dart:async';
import 'package:flutter/services.dart';

class FlutterFilePicker {
  static const _themeColor = "#2D0DB2";
  static const _backgroundColor = "#FFFFFF";

  static const MethodChannel _channel =
      const MethodChannel('flutter_files_picker');

  /// only in android
  ///
  ///
  static Future pickAny(
      Function(List<FileModel>) onFileSelect, List<String> sourceTypes,
      {String themeColor = _themeColor,
      String foregroundColor = _backgroundColor,
      showDirectoryFilter = false,
      List<String> mimeTypes}) async {
    var result = await _channel.invokeMethod<dynamic>(
      'pickAny',
      <String, dynamic>{
        "themeColor": themeColor,
        "foregroundColor": foregroundColor,
        "allowNewFile": true,
        "allowCrop": true,
        "mimeTypes": mimeTypes,
        "sourceTypes": sourceTypes,
        "showDirectoryFilter": true
      },
    );
//    print(result);
    // List<dynamic> fileArray = json.decode(result);
    // var list = fileArray.map((it) => FileModel.fromJson(it)).toList();
    // onFileSelect(list);

    var finalList = List<FileModel>();
    result.forEach((v) {
      finalList.add(
        FileModel.fromJson(v),
      );
    });

    onFileSelect(finalList);
  }

  static Future pickImage(
      {String themeColor = _themeColor,
      String foregroundColor = _backgroundColor,
      Function(List<FileModel>) onFileSelect}) async {
    var result = await _channel.invokeMethod<dynamic>(
      'pickImage',
      <String, dynamic>{
        "themeColor": themeColor,
        "foregroundColor": foregroundColor,
        "allowNewFile": true,
        "allowCrop": true
      },

      //"allowNewFile": true,
    );

    // List<dynamic> fileArray = json.decode(result);
    // var list = result.map((it) => FileModel.fromJson(it));

    var finalList = List<FileModel>();
    result.forEach((v) {
      finalList.add(
        FileModel.fromJson(v),
      );
    });

    onFileSelect(finalList);
  }

  static Future pickVideo(
      {String themeColor = _themeColor,
      String foregroundColor = _backgroundColor,
      Function(List<FileModel>) onFileSelect}) async {
    var result = await _channel.invokeMethod<dynamic>(
      'pickVideo',
      <String, dynamic>{
        "themeColor": themeColor,
        "foregroundColor": foregroundColor,
        "allowNewFile": true
      },
    );
//    print(result);
    // List<dynamic> fileArray = json.decode(result);
    // var list = fileArray.map((it) => FileModel.fromJson(it)).toList();
    // onFileSelect(list);

    var finalList = List<FileModel>();
    result.forEach((v) {
      finalList.add(
        FileModel.fromJson(v),
      );
    });

    onFileSelect(finalList);
  }

  static Future pickDocument(
      {String themeColor = _themeColor,
      String foregroundColor = _backgroundColor,
      Function(List<FileModel>) onFileSelect}) async {
    List<String> mipmap = ["application/pdf"];
    var result = await _channel.invokeMethod<dynamic>(
      'pickDocument',
      <String, dynamic>{
        "themeColor": themeColor,
        "foregroundColor": foregroundColor,
        "mimeTypes": mipmap
      },
    );
//    print(result);
    // List<dynamic> fileArray = json.decode(result);
    // var list = fileArray.map((it) => FileModel.fromJson(it)).toList();
    // onFileSelect(list);

    var finalList = List<FileModel>();
    result.forEach((v) {
      finalList.add(
        FileModel.fromJson(v),
      );
    });

    onFileSelect(finalList);
  }
}

class FileModel {
  String strTitle;
  String image;
  String fileSize;
  String fileUrl;
  String fileType;
  String attachmentName;
  String fileExtension;
  double fileSizeDouble;
  String filepath;

  FileModel(
      {this.strTitle,
      this.image,
      this.fileSize,
      this.fileUrl,
      this.fileType,
      this.attachmentName,
      this.fileExtension,
      this.fileSizeDouble,
      this.filepath});

  FileModel.fromJson(dynamic json) {
    strTitle = json['strTitle'];
    image = json['image'];
    fileSize = json['fileSize'];
    fileUrl = json['fileUrl'];
    fileType = json['fileType'];
    attachmentName = json['attachmentName'];
    fileExtension = json['fileExtension'];
    fileSizeDouble = json['fileSizeDouble'];
    filepath = json['filepath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['strTitle'] = this.strTitle;
    data['image'] = this.image;
    data['fileSize'] = this.fileSize;
    data['fileUrl'] = this.fileUrl;
    data['fileType'] = this.fileType;
    data['attachmentName'] = this.attachmentName;
    data['fileExtension'] = this.fileExtension;
    data['fileSizeDouble'] = this.fileSizeDouble;
    data['filepath'] = this.filepath;
    return data;
  }
}

class SourceTypes {
  static const String GALLARY = "GALLARY";
  static const String AUDIO = "AUDIO";
  static const String VIDEO = "VIDEO";
  static const String DOCUMENTS = "DOCUMENTS";
  static const String GOOGLE_DRIVE = "GOOGLE_DRIVE"; // not implemented
  static const String DROPBOX = "DROPBOX"; // not implemented
}
