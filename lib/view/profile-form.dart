import 'package:flutter/material.dart';
import 'package:animations/animations.dart' show OpenContainer;
import 'package:test_app/view/profile-popup.dart';

class ProfileFormPage extends StatefulWidget {
  @override
  _ProfileFormPageState createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {
  final List<String> images = [
    'image0.jpg',
    'image1.jpg',
    'image2.jpg',
    'image3.jpg',
    'image4.jpg',
    'image5.jpg',
  ];
  bool dragging = false;
  String currentGender = 'Male';
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
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2 / 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return OpenContainer(
                        openBuilder: (context, action) {
                          return ProfilePopUpPage(images[index]);
                        },
                        closedBuilder: (context, action) {
                          if (dragging)
                            return DragTarget<String>(
                              onAccept: (data) {
                                var initImage = images[index];
                                var initIndex = images.indexOf(initImage);
                                var finalIndex = images.indexOf(data);
                                images[initIndex] = data;
                                images[finalIndex] = initImage;
                                dragging = false;
                                setState(() {});
                              },
                              builder: (context, candidateData, rejectedData) {
                                return Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.asset(
                                      'assets/${images[index]}',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                );
                              },
                            );
                          return InkWell(
                            onTap: action,
                            child: Draggable<String>(
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
                              data: images[index],
                              feedback: Container(
                                height: 200,
                                width: 140,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.asset(
                                    'assets/${images[index]}',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              child: Container(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.asset(
                                    'assets/${images[index]}',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
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
                          onPressed: () {},
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
}
