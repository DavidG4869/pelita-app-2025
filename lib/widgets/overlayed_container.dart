import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OverlayedContainer extends StatelessWidget {
  final String title, image, date;
  final onTap;

  const OverlayedContainer({Key key, this.title, this.image, this.date, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onTap,
      child: Container(
        width: 220,
        margin: const EdgeInsets.symmetric(horizontal: 9.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: Colors.black12),
          image: DecorationImage(
            image: NetworkImage(this.image),
            colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "${this.title}",
              style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
             ),
            Container(alignment: Alignment.bottomLeft, padding: EdgeInsets.only(left:15),
             child: Text(
                "${this.date}",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
