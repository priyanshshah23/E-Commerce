import 'dart:io';

import 'package:diamnow/app/Helper/Themehelper.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/ImageConstant.dart';
import 'package:diamnow/app/utils/CommonWidgets.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/ImageUtils.dart';
import 'package:diamnow/app/utils/math_utils.dart';
import 'package:diamnow/app/utils/string_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'DiamondDetailScreen.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:share/share.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';

class DiamondImageBrowserScreen extends StatefulWidget {
  static const route = "DiamondImageBrowseScreen";

  List<DiamondDetailImagePagerModel> arrImages =
      List<DiamondDetailImagePagerModel>();

  DiamondImageBrowserScreen(Map<String, dynamic> dictArgument) {
    arrImages = dictArgument["imageData"];
  }

  @override
  _DiamondImageBrowserScreenState createState() =>
      _DiamondImageBrowserScreenState();
}

class _DiamondImageBrowserScreenState extends State<DiamondImageBrowserScreen> {
  int currentIndex = 0;
  PageController pageController;

  @override
  void initState() {
    // TODO: implement initState
    pageController = PageController(initialPage: currentIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteColor,
      appBar: getAppBar(
        context,
        "Photo viewer",
        bgColor: appTheme.whiteColor,
        leadingButton: getBackButton(context),
        centerTitle: false,
        actionItems: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              getImageViewForDownloadAndShare(
                onTap: () {
                  downloadSingleImage(
                    widget.arrImages[currentIndex].url,
                    widget.arrImages[currentIndex].title +
                        "." +
                        getExtensionOfUrl(widget.arrImages[currentIndex].url),
                    isFileShare: true,
                  );
                },
                imageName: share,
              ),
              getImageViewForDownloadAndShare(
                onTap: () {
                  downloadSingleImage(
                    widget.arrImages[currentIndex].url,
                    widget.arrImages[currentIndex].title +
                        "." +
                        getExtensionOfUrl(widget.arrImages[currentIndex].url),
                  );
                },
                imageName: download,
              ),
              SizedBox(
                width: getSize(10),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        color: appTheme.whiteColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Container(
                color: appTheme.whiteColor,
                child: PhotoViewGallery.builder(
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: _buildItem,
                  pageController: pageController,
                  loadingBuilder: (context, progress) => Center(
                    child: Container(
                      width: getSize(20),
                      height: getSize(20),
                      child: CircularProgressIndicator(
                        value: progress == null
                            ? null
                            : progress.cumulativeBytesLoaded /
                                progress.expectedTotalBytes,
                        backgroundColor: Colors.black,
                      ),
                    ),
                  ),
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemCount: widget.arrImages.length,
                  backgroundDecoration: BoxDecoration(
                    color: appTheme.whiteColor,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                bottom: getSize(30),
                top: getSize(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      if (currentIndex > 0) {
                        setState(
                          () {
                            currentIndex = currentIndex - 1;
                          },
                        );
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(getSize(12)),
                      child: Image.asset(
                        leftArrrow,
                        width: getSize(22),
                        height: getSize(22),
                        color: appTheme.blackColor,
                      ),
                    ),
                  ),
                  Text(
                    "${currentIndex + 1} / ${widget.arrImages.length}",
                    style: appTheme.black16TextStyle,
                  ),
                  InkWell(
                    onTap: () {
                      if (currentIndex >= 0 &&
                          currentIndex < widget.arrImages.length - 1) {
                        setState(() {
                          currentIndex = currentIndex + 1;
                        });
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(getSize(12)),
                      child: Image.asset(
                        rightArrow,
                        width: getSize(22),
                        height: getSize(22),
                        color: appTheme.blackColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getImageViewForDownloadAndShare({
    @required String imageName,
    @required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
//        decoration: BoxDecoration(
//            borderRadius: BorderRadius.circular(getSize(5)),
//            border: Border.all(color: appTheme.borderColor),
//            color: appTheme.unSelectedBgColor),
        child: Padding(
          padding: EdgeInsets.all(getSize(8)),
          child: Image.asset(
            imageName,
            height: getSize(20),
            width: getSize(20),
          ),
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    var model = widget.arrImages[currentIndex];
    return PhotoViewGalleryPageOptions.customChild(
      child: Container(
        width: getSize(300),
        height: getSize(300),
        child: getImageView(
          (model.arr != null &&
                  model.arr.length > 0 &&
                  isStringEmpty(model.url) == false)
              ? model.arr[model.subIndex].url
              : model.url,
          placeHolderImage: diamond,
          width: getSize(300),
          height: getSize(300),
        ),
      ),
      childSize: const Size(300, 300),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: model.title),
    );
  }

  Future<File> downloadSingleImage(
    String url,
    String filename, {
    bool isFileShare = false,
  }) async {
    final dir = await getDownloadDirectory();
    final savePath = path.join(dir.path, filename);

    Dio dio = Dio();

    dio.download(
      url,
      savePath,
      onReceiveProgress: (rcv, total) {
//        print(
//            'received: ${rcv.toStringAsFixed(0)} out of total: ${total.toStringAsFixed(0)}');
      },
      deleteOnError: true,
    ).then((value) {
      if (value.statusCode == successStatusCode) {
        if (Platform.isIOS) {
          isImage(savePath)
              ? GallerySaver.saveImage(savePath)
              : GallerySaver.saveVideo(savePath);
        }
        if (isFileShare) {
          Share.shareFiles([savePath], text: 'Great picture');
        }
        showToast(
          "Download complete",
          context: context,
        );
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          showToast(
            DioError().message,
            context: context,
          );
        });
      }
    });
  }

  Future<Directory> getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await DownloadsPathProvider.downloadsDirectory;
    }

    if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    }
    return await getExternalStorageDirectory();
  }
}
