import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart' show OpenContainer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:test_app/bloc/media-cubit.dart';
import 'package:test_app/bloc/media-states.dart';
import 'package:test_app/model/media.dart';
import 'package:test_app/view/profile-popup.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;

class ProfileFormPage extends StatefulWidget {
  @override
  _ProfileFormPageState createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {
  PlatformFile file;
  bool uploading = false;
  bool dragging = false;
  String currentGender = 'Male';
  Future<String> getVideoThumbnail(String videoUrl) async {
    var videoPath = (await getTemporaryDirectory()).path;
    var path = await VideoThumbnail.thumbnailFile(
      video: videoUrl,
      imageFormat: ImageFormat.JPEG,
      thumbnailPath: videoPath,
      maxWidth: 128,
      quality: 25,
    );
    return path;
  }

  Future<PlatformFile> pickFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['mp4', 'jpg', 'jpeg', 'png'],
    );
    if (result != null) {
      file = result.files[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        title: Text(
          'Profile Form',
          style: Theme.of(context).textTheme.headline1.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 25,
                color: Colors.black,
              ),
        ),
        leading: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  // padding: EdgeInsets.symmetric(horizontal: 15),
                  child: BlocBuilder<UserMediaCubit, UserMediaStates>(
                      builder: (context, state) {
                    if (state is UserMediaLoaded)
                      return GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 2 / 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: state.data.userMedia.length < 6
                            ? state.data.userMedia.length + 1
                            : state.data.userMedia.length,
                        itemBuilder: (context, index) {
                          var _images = state.data.userMedia;
                          if (index == _images.length) {
                            return InkWell(
                              onTap:uploading?null: () async {
                                await pickFile();
                                if (file != null) {
                                  print('uploading-file');
                                  setState(() {
                                    uploading = true;
                                  });
                                  BlocProvider.of<UserMediaCubit>(context)
                                      .postUserMedia(File(file.path))
                                      .then((value) {
                                    BlocProvider.of<UserMediaCubit>(context)
                                        .loadUserMedia();
                                    setState(() {
                                      uploading = false;
                                    });
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child:uploading?CupertinoActivityIndicator(): Icon(Icons.add, color: Colors.black),
                                alignment: Alignment.center,
                              ),
                            );
                          }
                          return OpenContainer(
                            openBuilder: (context, action) {
                              return ProfilePopUpPage(_images[index], state);
                            },
                            closedBuilder: (context, action) {
                              if (dragging)
                                return DragTarget<Media>(
                                  onAccept: (data) {
                                    var initImage = _images[index];
                                    var initIndex = _images.indexOf(initImage);
                                    var finalIndex = _images.indexOf(data);
                                    _images[initIndex] = data;
                                    _images[finalIndex] = initImage;
                                    dragging = false;
                                    setState(() {});
                                    BlocProvider.of<UserMediaCubit>(context)
                                        .rearrangeMedia(_images);
                                  },
                                  builder:
                                      (context, candidateData, rejectedData) {
                                    if (_images[index]
                                        .longURL
                                        .endsWith('.mp4')) {
                                      return buildVideoThumbnail(
                                          _images, index);
                                    }
                                    return Container(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.network(
                                          '${GlobalConfiguration().get('fileURL')}${state.data.userMedia[index].longURL}',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              return InkWell(
                                onTap: action,
                                child: Draggable<Media>(
                                  childWhenDragging: Container(
                                    child: Text('dragging'),
                                  ),
                                  onDragEnd: (details) {
                                    setState(() {
                                      dragging = false;
                                    });
                                    print('Drag-end');
                                    print(details);
                                  },
                                  onDragCompleted: () {
                                    setState(() {
                                      dragging = false;
                                    });
                                    print('drag-completed');
                                  },
                                  onDragUpdate: (details) {
                                    setState(() {
                                      dragging = true;
                                    });
                                    print('drag-update');
                                  },
                                  data: _images[index],
                                  feedback: Container(
                                    height: 200,
                                    width: 140,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: _images[index]
                                              .longURL
                                              .endsWith('.mp4')
                                          ? buildVideoThumbnail(_images, index)
                                          : Image.network(
                                              '${GlobalConfiguration().get('fileURL')}${state.data.userMedia[index].longURL}',
                                              fit: BoxFit.fill,
                                            ),
                                    ),
                                  ),
                                  child: Container(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: _images[index]
                                              .longURL
                                              .endsWith('.mp4')
                                          ? buildVideoThumbnail(_images, index)
                                          : Image.network(
                                              '${GlobalConfiguration().get('fileURL')}${state.data.userMedia[index].longURL}',
                                              fit: BoxFit.fill,
                                            ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    else {
                      return Center(child: CupertinoActivityIndicator());
                    }
                  }),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextFormField(
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          hintText: 'Full Name',
                          focusColor: Colors.black,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      TextFormField(
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Age',
                          focusColor: Colors.black,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gender',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(color: Colors.grey),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 220,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: ['Male', 'Female']
                                      .map(
                                        (e) => InkWell(
                                          onTap: () {
                                            setState(() {
                                              currentGender = e;
                                            });
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 100,
                                            alignment: Alignment.center,
                                            child: Text(
                                              '$e',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: currentGender == e
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                              color: currentGender == e
                                                  ? Colors.black
                                                  : Colors.grey[400],
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList()),
                            ),
                          ],
                        ),
                      ),
                      TextFormField(
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          hintText: 'Cost',
                          focusColor: Colors.black,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            BlocProvider.of<UserMediaCubit>(context)
                                .loadUserMedia();
                          },
                          child: Container(
                            width: 120,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Other Details',
                                  style: TextStyle(
                                    color: Colors.pink,
                                    fontSize: 13,
                                  ),
                                ),
                                Icon(
                                  Icons.navigate_next,
                                  color: Colors.pink,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              minimumSize: MaterialStateProperty.all(
                                Size(double.infinity, 50),
                              ),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.grey),
                            ),
                            onPressed: () {},
                            child: Text('Register'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FutureBuilder<String> buildVideoThumbnail(List<Media> _images, int index) {
    return FutureBuilder<String>(
        future: getVideoThumbnail(
            GlobalConfiguration().get('fileURL') + _images[index].longURL),
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.file(
                  File(snapshot.data),
                  fit: BoxFit.fill,
                ),
              ),
            );
          else {
            return Container(
              child: CupertinoActivityIndicator(),
            );
          }
        });
  }
}
