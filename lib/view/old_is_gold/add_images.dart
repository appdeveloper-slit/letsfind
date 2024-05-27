import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letsfind/data/static_method.dart';
import 'package:letsfind/values/colors.dart';
import 'package:letsfind/values/dimens.dart';
import 'package:letsfind/values/strings.dart';
import 'package:letsfind/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'owner_contact_details.dart';

class AddImages extends StatefulWidget {
  final sProductID;

  const AddImages({super.key, this.sProductID});

  @override
  State<AddImages> createState() => _AddImagesState();
}

class _AddImagesState extends State<AddImages> {
  late BuildContext ctx;

  File? imageFile;
  String? productImage;
  bool isFocused = false;

  List<File> _selectedImages = []; // List of local images
  List<dynamic> _imageUrlList = []; // List of URL images
  List<dynamic> base64List = []; // List of URL images

  Future<void> _pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      allowMultiple: true,
      // type: FileType.image,
      // allowMultiple: true,
    );

    if (result != null) {
      List<File> pickedImages =
          result.files.map((file) => File(file.path!)).toList();

      setState(() {
        _selectedImages.addAll(pickedImages);
      });
    } else {
      // User canceled the file picking
    }
  }

  void _removeImageUrl(int index) {
    setState(() {
      _imageUrlList.removeAt(index);
      // _imageUrlList.removeAt(index - _selectedImages.length);
    });
  }

  String fileToBase64(File file) {
    List<int> imageBytes = file.readAsBytesSync();
    return base64Encode(imageBytes);
  }

// Function to convert a list of Files to base64
  List<String> filesToBase64(List<File> files) {
    return files.map((file) => fileToBase64(file)).toList();
  }

  var editState, editCity;

  List<dynamic> categoryList = [];

  List<dynamic> subCategoryList = [];

  String? sCategory, sSubCategory, sProductID, sToken;

  getsessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sProductID = sp.getString("product_id") ?? "";
    sToken = sp.getString("token") ?? "";
    print("sProduct ID :: $sProductID");
  }

  @override
  void initState() {
    getsessionData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;

    print("sProduct Id:: ${widget.sProductID}");

    Uint8List ProductImages = base64Decode(productImage.toString());

    return Scaffold(
      backgroundColor: Clr().background,
      appBar: AppBar(
        forceMaterialTransparency: true,
        surfaceTintColor: Clr().white,
        backgroundColor: Clr().white,
        leading: InkWell(
          onTap: () {
            STM().back2Previous(ctx);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(55),
                color: Clr().primaryLightColor,
              ),
              width: 20,
              height: 20,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset("assets/back.svg"),
              ),
            ),
          ),
        ),
        title: RichText(
          text: TextSpan(
            text: "Step ",
            // text: '₹10,000 ',
            style: Sty().smallText.copyWith(
                  color: Clr().textcolor,
                  fontFamily: 'SP',
                  fontWeight: FontWeight.w400,
                ),
            children: [
              TextSpan(
                text: '2 ',
                style: Sty().smallText.copyWith(
                      color: Color(0xffFF8000),
                      fontFamily: 'SP',
                      fontWeight: FontWeight.w600,
                    ),
              ),
              TextSpan(
                text: 'of 3',
                style: Sty().smallText.copyWith(
                      color: Clr().textcolor,
                      fontFamily: 'SP',
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dim().d16),
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                          color: Clr().borderColor.withOpacity(0.3),
                          blurRadius: 5,
                          spreadRadius: 0)
                    ],
                  ),
                  child: Card(
                    elevation: 0,
                    shape: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Clr().borderColor.withOpacity(0.8)),
                        borderRadius: BorderRadius.circular(18)),
                    color: Clr().white,
                    surfaceTintColor: Clr().white,
                    child: Padding(
                      padding: EdgeInsets.all(Dim().d16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add Product Photos :',
                            style: Sty().largeText.copyWith(
                                color: Clr().textcolor,
                                fontSize: 18,
                                fontWeight: FontWeight.w800),
                          ),
                          SizedBox(
                            height: Dim().d20,
                          ),
                          // InkWell(
                          //   onTap: () {
                          //     // _getCamera(ImageSource.gallery, "Image");
                          //   },
                          //   child: DottedBorder(
                          //     borderType: BorderType.RRect,
                          //     dashPattern: [8, 10],
                          //     color: Clr().textcolor,
                          //     radius: Radius.circular(55),
                          //     strokeWidth: 0.8,
                          //     padding: EdgeInsets.all(6),
                          //     child: ClipRRect(
                          //       borderRadius:
                          //           BorderRadius.all(Radius.circular(12)),
                          //       child: Container(
                          //         height: 30,
                          //         width: double.infinity,
                          //         child: Center(
                          //           child: Text(
                          //             'Add Images',
                          //             style: Sty().smallText.copyWith(
                          //                 color: Color(0xff464646),
                          //                 fontWeight: FontWeight.w600),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          productImage != null
                              ? SizedBox(
                                  height: Dim().d20,
                                )
                              : SizedBox(
                                  height: Dim().d0,
                                ),
                          productImage != null
                              ? Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      height: 180,
                                      width: MediaQuery.of(context).size.width /
                                          2.5,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.memory(
                                          ProductImages,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        top: 10,
                                        right: 10,
                                        child: Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Clr().white,
                                            border:
                                                Border.all(color: Clr().red),
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            color: Clr().red,
                                            size: 14,
                                          ),
                                        ))
                                  ],
                                )
                              : Container(),


                          TextFormField(
                            onTap: _pickImages,
                            readOnly: true,
                            // controller: sampleImagesCtrl,
                            cursorColor: Clr().textcolorsgray,
                            style: Sty().mediumText,
                            maxLines: 1,
                            // keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            obscureText: false,
                            decoration: Sty().textFieldOutlineStyle2.copyWith(
                              contentPadding: EdgeInsets.only(left: 120),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(width: 0.3),
                                      borderRadius: BorderRadius.circular(15)),
                                  hintStyle: Sty().smallText.copyWith(
                                        color: Clr().textcolor,
                                      ),
                                  filled: true,
                                  fillColor: Clr().background,
                                  hintText: "Add Images",
                                  counterText: "",
                                  // suffixIcon: Icon(Icons.navigate_next)
                                ),
                          ),
                          if (_selectedImages.length >= 1)
                            SizedBox(
                              height: Dim().d20,
                            ),
                          if (_selectedImages.length >= 1)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Current Image",
                                  style: Sty().mediumText.copyWith(
                                        fontSize: 14,
                                      ),
                                ),
                                _selectedImages.length > 4
                                    ? TextButton(
                                        style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            minimumSize: Size(50, 30),
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                            alignment: Alignment.centerLeft),
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context,
                                            useSafeArea: true,
                                            isScrollControlled: true,
                                            // Set this to true for a full-page bottom sheet
                                            builder: (context) {
                                              return StatefulBuilder(builder:
                                                  (BuildContext context,
                                                      setState) {
                                                return SingleChildScrollView(
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      children: [
                                                        GridView.builder(
                                                          shrinkWrap: true,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          gridDelegate:
                                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 2,
                                                            mainAxisExtent: 145,
                                                            mainAxisSpacing: 4,
                                                            crossAxisSpacing: 4,
                                                          ),
                                                          itemCount:
                                                              _selectedImages
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            var z =
                                                                _selectedImages[
                                                                    index];
                                                            return Center(
                                                              child: Stack(
                                                                children: [
                                                                  ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                    child: Image
                                                                        .file(
                                                                      z,
                                                                      width:
                                                                          160,
                                                                      height:
                                                                          120,
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    top: 0,
                                                                    right: 0,
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          _selectedImages
                                                                              .removeAt(index);
                                                                        });
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            20,
                                                                        width:
                                                                            20,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Clr().primaryColor,
                                                                            borderRadius: BorderRadius.circular(50),
                                                                            border: Border.all(color: Clr().borderColor)),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .close,
                                                                          size:
                                                                              18,
                                                                          color:
                                                                              Clr().white,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(); // Close the bottom sheet
                                                          },
                                                          child: Text('Close',
                                                              style: Sty()
                                                                  .mediumText
                                                                  .copyWith(
                                                                      decoration:
                                                                          TextDecoration
                                                                              .underline)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                            },
                                          );
                                        },
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            'view more',
                                            style: Sty().mediumText.copyWith(
                                                  color: Clr().primaryColor,
                                                  fontSize: 14,
                                                  height: 1.2,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          if (_selectedImages.length >= 1)
                            SizedBox(
                              height: 10,
                            ),
                          if (_selectedImages.length >= 1)
                            GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisExtent: 120,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                              ),
                              itemCount: _selectedImages.length > 4
                                  ? 4
                                  : _selectedImages.length,
                              itemBuilder: (context, index) {
                                var z = _selectedImages[index];
                                return Center(
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          z,
                                          width: 160,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 5,
                                        right: 5,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _selectedImages.removeAt(index);
                                            });
                                          },
                                          child: Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                                color: Clr().white,
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                border: Border.all(
                                                    color: Clr().red)),
                                            child: Icon(
                                              Icons.close,
                                              size: 12,
                                              color: Clr().red,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          if (_imageUrlList.length >= 1)
                            SizedBox(
                              height: 10,
                            ),
                          if (_imageUrlList.length >= 1)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Previous Image",
                                  style: Sty().mediumText.copyWith(
                                        fontSize: 14,
                                      ),
                                ),
                                _imageUrlList.length > 4
                                    ? TextButton(
                                        style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            minimumSize: Size(50, 30),
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                            alignment: Alignment.centerLeft),
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context,
                                            useSafeArea: true,
                                            isScrollControlled: true,
                                            // Set this to true for a full-page bottom sheet
                                            builder: (context) {
                                              return StatefulBuilder(builder:
                                                  (BuildContext context,
                                                      setState) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SingleChildScrollView(
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    child: Column(
                                                      children: [
                                                        GridView.builder(
                                                          shrinkWrap: true,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          gridDelegate:
                                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 2,
                                                            mainAxisExtent: 145,
                                                            mainAxisSpacing: 4,
                                                            crossAxisSpacing: 4,
                                                          ),
                                                          itemCount:
                                                              _imageUrlList
                                                                  .length,
                                                          itemBuilder: (context,
                                                              index2) {
                                                            var z =
                                                                _imageUrlList[
                                                                    index2];
                                                            return Center(
                                                              child: Stack(
                                                                children: [
                                                                  ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                    child:
                                                                        CachedNetworkImage(
                                                                      width:
                                                                          160,
                                                                      height:
                                                                          120,
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      imageUrl:
                                                                          z['image'] ??
                                                                              'https://www.famunews.com/wp-content/themes/newsgamer/images/dummy.png',
                                                                      // imageUrl:v['user']['profile']!=null ?v['user']:'',
                                                                      placeholder: (context,
                                                                              url) =>
                                                                          STM()
                                                                              .loadingPlaceHolder(),
                                                                      errorWidget: (context, url, error) => Image.network(
                                                                          'https://www.famunews.com/wp-content/themes/newsgamer/images/dummy.png',
                                                                          height:
                                                                              120,
                                                                          width:
                                                                              160,
                                                                          fit: BoxFit
                                                                              .fill),
                                                                    ),
                                                                    // Image.network('${z['image'].toString()}', height: 120, width: 160, fit: BoxFit.fill),
                                                                  ),
                                                                  Positioned(
                                                                    top: -14,
                                                                    right: -14,
                                                                    child:
                                                                        IconButton(
                                                                      icon:
                                                                          Container(
                                                                        height:
                                                                            20,
                                                                        width:
                                                                            20,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Clr().primaryColor,
                                                                            borderRadius: BorderRadius.circular(50),
                                                                            border: Border.all(color: Clr().borderColor)),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .close,
                                                                          size:
                                                                              18,
                                                                          color:
                                                                              Clr().white,
                                                                        ),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        // deleteImage(z['id'].toString());
                                                                        setState(
                                                                            () {
                                                                          _removeImageUrl(
                                                                              index2);
                                                                          // deleteProjects(
                                                                          //     z['id']);
                                                                          // v['images'].removeAt(index2);
                                                                        });
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(); // Close the bottom sheet
                                                          },
                                                          child: Text('Close',
                                                              style: Sty()
                                                                  .mediumText
                                                                  .copyWith(
                                                                      decoration:
                                                                          TextDecoration
                                                                              .underline)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                            },
                                          );
                                        },
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            'view more',
                                            style: Sty().mediumText.copyWith(
                                                  color: Clr().primaryColor,
                                                  fontSize: 14,
                                                  height: 1.2,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          if (_imageUrlList.length >= 1)
                            SizedBox(
                              height: 10,
                            ),
                          if (_imageUrlList.length >= 1)
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisExtent: 80,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                              ),
                              itemCount: _imageUrlList.length > 4
                                  ? 4
                                  : _imageUrlList.length,
                              itemBuilder: (context, index2) {
                                var z = _imageUrlList[index2];

                                return Center(
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CachedNetworkImage(
                                          width: 160,
                                          height: 120,
                                          fit: BoxFit.fill,
                                          imageUrl: z['image'] ??
                                              'https://www.famunews.com/wp-content/themes/newsgamer/images/dummy.png',
                                          // imageUrl:v['user']['profile']!=null ?v['user']:'',
                                          placeholder: (context, url) =>
                                              STM().loadingPlaceHolder(),
                                          errorWidget: (context, url, error) =>
                                              Image.network(
                                                  'https://www.famunews.com/wp-content/themes/newsgamer/images/dummy.png',
                                                  height: 120,
                                                  width: 160,
                                                  fit: BoxFit.fill),
                                        ),
                                        // Image.network('${z['image'].toString()}', height: 120, width: 160, fit: BoxFit.fill),
                                      ),
                                      Positioned(
                                        top: -14,
                                        right: -14,
                                        child: IconButton(
                                          icon: Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                                color: Clr().primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                border: Border.all(
                                                    color: Clr().borderColor)),
                                            child: Icon(
                                              Icons.close,
                                              size: 18,
                                              color: Clr().white,
                                            ),
                                          ),
                                          onPressed: () {
                                            // deleteImage(z['id'].toString());
                                            setState(() {
                                              _removeImageUrl(index2);
                                              // deleteProjects(z['id']);
                                              // v['images'].removeAt(index2);
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          side: BorderSide(
                              color: _selectedImages.isNotEmpty
                                  ? Clr().transparent
                                  : Clr().borderColor),
                          elevation: 0,
                          backgroundColor: _selectedImages.isNotEmpty
                              ? Clr().primaryColor
                              : Clr().lightGrey),
                      onPressed: () {
                        setState(
                          () {
                            // Convert the list of images to base64
                            base64List = filesToBase64(_selectedImages);

                            // Print the base64-encoded images
                            for (String base64List in base64List) {
                              print('Base 64 List :: $base64List');
                            }
                            _selectedImages.isNotEmpty
                                ? addImage()
                                : STM().displayToast(
                                    "Please select atleast 1 image to proceed");
                          },
                        );
                      },
                      child: Text(
                        'Next',
                        style: Sty().mediumText.copyWith(
                            color: _selectedImages.isNotEmpty
                                ? Clr().white
                                : Clr().grey),
                      )),
                ),
                SizedBox(
                  height: Dim().d32,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  /////////////////////////////////////////////////
  // _getCamera(ImageSource source, type) async {
  //   XFile? pickedFile = await ImagePicker().pickImage(
  //     source: source,
  //     maxHeight: 1800,
  //     maxWidth: 1800,
  //   );
  //
  //   if (pickedFile != null) {
  //     setState(() {
  //       imageFile = File(pickedFile.path);
  //       print("Image File :: $imageFile");
  //       var image = imageFile!.readAsBytesSync();
  //       log("Image :: $image");
  //
  //       switch (type) {
  //         case "Image":
  //           productImage = base64Encode(image);
  //           break;
  //       }
  //       ;
  //     });
  //   }
  // }

  ///Add Images
  void addImage() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    Map<String, dynamic> body = {
      "product_id": sProductID,
      "images": base64List,
    };
    var result = await STM().postDialogToken2(
        ctx, Str().loading, 'add_product_image', body, sToken);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(
        () {
          STM().displayToast(message);
          STM().replacePage(
            ctx,
            OwnerContact(),
          );
        },
      );
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
