import 'dart:io';

// import 'package:app_settings/app_settings.dart';
import 'package:flowder/flowder.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jci/models/pdfDownloadModel.dart';
import 'package:jci/services/downloadService.dart';
import 'package:jci/services/local_notification_service.dart';
import 'package:jci/widgets/custAppBar.dart';
import 'package:get/get.dart';
import 'package:jci/widgets/titles.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustAppBar(titles.green_channel).initAppBar(),
      body: FutureBuilder(
          future: pdfDownloadService.getPdfList(),
          builder: (_, AsyncSnapshot<List<pdfDownload>> snapshot) {
            return OrientationBuilder(builder: (ctx, orientation) {
              if (snapshot.data == null &&
                  snapshot.connectionState == ConnectionState.waiting) {
                // var snap = snapshot.data!;
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data == null) {
                return Center(
                    child: Lottie.asset("assets/lottie/no_data.json"));
              } else {
                var snap = snapshot.data!;
                if (snap.length < 1) {
                  return Center(
                    child: Container(
                      child: Lottie.asset("assets/lottie/no_data.json"),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 18, bottom: 20),
                  child: GridView.builder(
                      itemCount: snap.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              orientation == Orientation.portrait ? 2 : 4,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0),
                      itemBuilder: (ctx, index) {
                        return GestureDetector(
                          onTap: () => _checkPermissionAndDownloadFile(
                              link: "${snap[index].url}",
                              name: "${snap[index].name}"),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: HexColor('eeeeee'),
                            ),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/icons/pdf.png",
                                    width: 80,
                                    height: 80,
                                  ),
                                  SizedBox(
                                    height: 13,
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      "${snap[index].name}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'pop-semibold',
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ),
                                  Text(
                                    "${snap[index].time}",
                                    style: TextStyle(
                                        fontFamily: 'pop-reg', fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                );
              }
            });
          }),
    );
  }

  void _checkPermissionAndDownloadFile(
      {required String link, required String name}) async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      var reqStatus = await Permission.storage.request();
      if (reqStatus.isDenied) {
        await Permission.storage.request();
      } else if (reqStatus.isPermanentlyDenied) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Storage Permission Required'),
                content: Text(
                    'storage permission required to provide file downloading feature'),
                actions: [
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  ElevatedButton(
                    child: Text("Open Settings"),
                    onPressed: () {
                      openAppSettings();
                      //AppSettings.openAppSettings();
                    },
                  )
                ],
              );
            });
      } else if (reqStatus.isGranted || status.isGranted) {
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (ctx) {
              return AlertDialog(
                  title: Text(
                    'Download',
                    style: TextStyle(fontFamily: 'pop-bold'),
                  ),
                  content: Container(
                    height: Get.height * 0.08,
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => _download('$link', '$name'),
                          child: ListTile(
                            title: Text(
                              "Download PDF",
                              style: TextStyle(fontFamily: 'pop-med'),
                            ),
                            dense: true,
                            contentPadding: EdgeInsets.all(0),
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Icon(
                                Icons.cloud_download_outlined,
                              ),
                            ),
                            minVerticalPadding: 0,
                          ),
                        )
                      ],
                    ),
                  ));
            });
      }
    } else if (status.isGranted) {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (ctx) {
            return AlertDialog(
                title: Text(
                  'Download',
                  style: TextStyle(fontFamily: 'pop-bold'),
                ),
                content: Container(
                  height: Get.height * 0.08,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () => _download("$link", "$name"),
                        child: ListTile(
                          title: Text(
                            "Download PDF",
                            style: TextStyle(fontFamily: 'pop-med'),
                          ),
                          dense: true,
                          contentPadding: EdgeInsets.all(0),
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.cloud_download_outlined,
                            ),
                          ),
                          minVerticalPadding: 0,
                        ),
                      )
                    ],
                  ),
                ));
          });
    }
  }

  void _download(var link, var filename) async {
    Get.back();
    var dir = await getApplicationDocumentsDirectory();
    var path = "/storage/emulated/0/Download";
    var options = DownloaderUtils(
      progressCallback: (current, total) {
        final progress = (current / total) * 100;
        LocalNotificationService.display(
            null, progress.toInt(), "$filename.pdf");
      },
      file: File('$path/$filename.pdf'),
      progress: ProgressImplementation(),
      onDone: () {
        // LocalNotificationService.filename = "$filename,pdf";
        //LocalNotificationService.display(null,100);
        //  Get.snackbar(
        //    "File Downloaded",
        //    "File downloaded in download folder",
        //    backgroundColor: Colors.blue,
        //    snackPosition: SnackPosition.BOTTOM,
        //    margin: EdgeInsets.all(10),
        //    borderRadius: 0,
        //    colorText: Colors.white,
        //  );
      },
      deleteOnCancel: true,
    );
    var core = await Flowder.download('$link', options);
  }
}
