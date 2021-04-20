import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:test_app/bloc/media-cubit.dart';
import 'package:test_app/bloc/media-states.dart';
import 'package:test_app/model/media.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart' show VideoPlayerController;

class ProfilePopUpPage extends StatefulWidget {
  final Media media;
  final UserMediaLoaded mediaLoaded;
  ProfilePopUpPage(
    this.media,
    this.mediaLoaded,
  );

  @override
  _ProfilePopUpPageState createState() => _ProfilePopUpPageState();
}

class _ProfilePopUpPageState extends State<ProfilePopUpPage> {
  VideoPlayerController videoPlayerController;
  Future<void> initializeVideoPlayer;

  @override
  void initState() { 
    super.initState();
    if (widget.media.longURL.endsWith('.mp4')) {
      videoPlayerController =
          VideoPlayerController.network(GlobalConfiguration().get('fileURL') + widget.media.longURL);
      initializeVideoPlayer = videoPlayerController.initialize();
    }
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
          child: Column(
            children: [
              if (widget.media.longURL.endsWith('.mp4'))
                Container(
                  height: MediaQuery.of(context).size.height * 0.65,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: FutureBuilder<void>(
                        future: initializeVideoPlayer,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting)
                            return Center(
                              child: CupertinoActivityIndicator(),
                            );
                          return Chewie(
                            controller: ChewieController(
                              videoPlayerController: videoPlayerController,
                              autoPlay: false,
                              autoInitialize: true,
                              errorBuilder: (context, errorMessage) {
                                return Container(
                                  child: Text(errorMessage),
                                );
                              },
                              looping: false,
                              placeholder: Container(
                                child: Center(
                                  child: CupertinoActivityIndicator(),
                                ),
                              ),
                              materialProgressColors: ChewieProgressColors(),
                            ),
                          );
                        }),
                  ),
                ),
              if (!widget.media.longURL.endsWith('.mp4'))
                Container(
                  height: MediaQuery.of(context).size.height * 0.65,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      '${GlobalConfiguration().get('fileURL')}${widget.media.longURL}',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              SizedBox(height: 40),
              Center(
                child: TextButton(
                  onPressed: () async {
                    widget.mediaLoaded.deleteMedia(widget.media.id);
                    BlocProvider.of<UserMediaCubit>(context).deleteUserMedia(
                        widget.media.id, widget.mediaLoaded.data);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Delete this file',
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
                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                    ),
                    onPressed: () {},
                    child: Text('Register'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
