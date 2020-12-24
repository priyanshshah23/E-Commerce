import 'package:diamnow/app/Helper/Themehelper.dart';
import 'package:diamnow/app/constant/ImageConstant.dart';
import 'package:diamnow/app/utils/CommonWidgets.dart';
import 'package:diamnow/app/utils/ImageUtils.dart';
import 'package:diamnow/app/utils/math_utils.dart';
import 'package:diamnow/app/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'DiamondDetailScreen.dart';

class DiamondImageBrowseScreen extends StatefulWidget {
  static const route = "DiamondImageBrowseScreen";

  List<DiamondDetailImagePagerModel> arrImages =
  List<DiamondDetailImagePagerModel>();

  DiamondImageBrowseScreen(Map<String, dynamic> dictArgument) {
    arrImages = dictArgument["imageData"];
  }

  @override
  _DiamondImageBrowseScreenState createState() =>
      _DiamondImageBrowseScreenState();
}

class _DiamondImageBrowseScreenState extends State<DiamondImageBrowseScreen> {
  ItemScrollController _scrollController = ItemScrollController();
  int currentIndex = 0;
  PageController pageController;

  @override
  void initState() {
    // TODO: implement initState
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
                    "${currentIndex + 1} / ${widget.arrImages.length }",
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
      heroAttributes: PhotoViewHeroAttributes(tag: "Hero"),
    );
  }
}
