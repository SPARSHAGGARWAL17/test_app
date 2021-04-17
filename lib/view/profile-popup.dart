import 'package:flutter/material.dart';

class ProfilePopUpPage extends StatelessWidget {
  final String image;
  ProfilePopUpPage(this.image);
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
              Container(
                height: MediaQuery.of(context).size.height * 0.65,
                width: double.infinity,
                // padding: EdgeInsets.symmetric(horizontal: 15),

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    'assets/$image',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: 40),
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
