// For generate Map
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/ApiConstants.dart';

CachedNetworkImage getImageView(String url,
    {height = 100.0,
    width = 100.0,
    placeHolderImage,
    fit: BoxFit.contain,
    BoxShape shape}) {
  String imageUrl = (url == null || url.length == 0)
      ? ""
      : ((url.startsWith("images") || url.startsWith("/"))
          ? (ApiConstants.imageBaseURL + url)
          : url);
  return new CachedNetworkImage(
    height: height,
    width: width,
    imageUrl: imageUrl,
//    imageBuilder: (context, imageProvider) => Container(
//      width: width,
//      height: height,
//      decoration: BoxDecoration(
//        shape: shape,
//        image: DecorationImage(
//            image: imageProvider, fit: BoxFit.cover),
//      ),
//    ),
    fit: fit,
    placeholder: (context, url) => Container(
      //decoration: decoration,
      height: height,
      width: width,
      child: SpinKitFadingCircle(
        color: ColorConstants.colorPrimary,
        size: getSize(20),
      ),
    ),
    errorWidget: (context, url, error) => Image.asset(
      placeHolderImage == null || placeHolderImage.length == 0
          ? placeHolder
          : placeHolderImage,
      width: width,
      height: height,
      fit: fit,
    ),
  );
}

// static func getGoogleMapImageUrl(size:CGSize, startLocation:LocationModel, endLocation:LocationModel) -> String {

//         let strUrl1 = "http://maps.google.com/maps/api/staticmap?path=color:0x3C97D3FF|weight:4|\(startLocation.latitude),\(startLocation.longitude)|\(endLocation.latitude),\(endLocation.longitude)&size=\(Int(size.width))x\(Int(size.height))&sensor=true&markers=size:".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

//         let strUrl2 = "tiny%7C"

//         let strUrl3 = "color:0xFF0000FF|\(startLocation.latitude),\(startLocation.longitude)|\(endLocation.latitude),\(endLocation.longitude)&key=\(AppConstants.googleApiKeyForImage)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

//         return "\(strUrl1)\(strUrl2)\(strUrl3)"

//         //        return "http://maps.google.com/maps/api/staticmap?path=color:0x3C97D3FF|weight:4|21.171021,72.854210|21.267553,72.960861&size=\(Int(size.width))x\(Int(size.height))&sensor=true&markers=size:mid%7Ccolor:0xFF0000FF|21.171021,72.854210|21.267553,72.960861&key=\(AppConstants.googleApiKeyForImage)"
//         //            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

//     }
