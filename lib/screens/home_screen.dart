import 'dart:developer';
import 'dart:io';

import 'package:dog_or_cat/utils/assets.dart';
import 'package:dog_or_cat/utils/common_codes.dart';
import 'package:dog_or_cat/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List? output;
  File img = File("");
  bool isLoading = false;

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/ml_data/model_unquant.tflite",
      labels: "assets/ml_data/labels.txt",
    );
  }

  findImage(File image) async {
    output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    log(output.toString());
  }

  @override
  void initState() {
    loadModel();
    super.initState();
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detect Dogs and Cats"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            img.path != ""
                ? Image.file(
                    img,
                    fit: BoxFit.cover,
                    height: getProportionateScreenHeight(200),
                    width: getProportionateScreenWidth(150),
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) =>
                            SizedBox(
                      height: getProportionateScreenHeight(225),
                      width: getProportionateScreenWidth(200),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: child,
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () => setState(() {
                                img = File("");
                              }),
                              color: Colors.red,
                              icon: const Icon(Icons.delete),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Hero(
                    tag: "logo",
                    child: Image.asset(
                      AppAssets.appLogo,
                      height: getProportionateScreenHeight(200),
                      width: getProportionateScreenWidth(150),
                    ),
                  ),
            if (img.path != "") ...<Widget>[
              sizeBoxHeight(10),
              isLoading
                  ? SizedBox(
                      height: getProportionateScreenHeight(30),
                      width: getProportionateScreenHeight(30),
                      child: const CircularProgressIndicator(),
                    )
                  : Text(
                      output!.isEmpty
                          ? "We are not sure about this picture!"
                          : output![0]["label"].split(" ").last,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
            ],
            sizeBoxHeight(50),
            MaterialButton(
              onPressed: () async {
                img = await getImage(ImageSource.gallery);
                setState(() {
                  isLoading = true;
                });
                if (img.path != "") await findImage(img);
                setState(() {
                  isLoading = false;
                });
              },
              color: Theme.of(context).primaryColor,
              minWidth: getProportionateScreenHeight(200),
              child: const Text("Select Photo"),
            ),
            MaterialButton(
              onPressed: () async {
                img = await getImage(ImageSource.camera);
                setState(() {
                  isLoading = true;
                });
                if (img.path != "") await findImage(img);
                setState(() {
                  isLoading = false;
                });
              },
              color: Theme.of(context).primaryColor,
              minWidth: getProportionateScreenHeight(200),
              child: const Text("Take Photo"),
            ),
          ],
        ),
      ),
    );
  }
}
