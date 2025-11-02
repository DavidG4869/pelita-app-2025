import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final String imagePath;
  final String launchPath;
  final String title;

  HomeCard({@required this.title, @required this.imagePath, @required this.launchPath});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // if (this.launchPath.contains("http"))
        // await launch(this.launchPath);
        //else
        Navigator.of(context).pushNamed(this.launchPath);
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 20),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 2,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.12,
          child: Row(children: [
            Expanded(
              flex: 4,
              child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          alignment: Alignment.centerLeft, image: AssetImage(this.imagePath), fit: BoxFit.cover))),
            ),
            Expanded(
                flex: 3,
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      this.title,
                      maxLines: 1,
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
                    ))),
            //SizedBox(width: 50),
            Expanded(flex: 2, child: Icon(CupertinoIcons.right_chevron, color: Color(0xffD0D0D0), size: 30))
          ]),
        ),
      ),
    );
  }
}
