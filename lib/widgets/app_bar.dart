import 'package:flutter/material.dart';
import 'package:pelita_app/consts/theme_data.dart';
import 'package:pelita_app/models/enums.dart';
import 'package:pelita_app/utils/widget_utils.dart';

class PelitaAppBar extends StatelessWidget implements PreferredSizeWidget {
  ScreenType screenType;
  String screenTitle;

  PelitaAppBar({@required this.screenType, @required this.screenTitle, Key key}) : super(key: key);

  // Get Gradient Color for area under appbar

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(screenTitle, style: TextStyle(color: Colors.white)),
      flexibleSpace: Container(decoration: BoxDecoration(color: Colors.black)),
      bottom: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 4.0),
        child: Container(
          decoration: BoxDecoration(gradient: WidgetUtils.linearGradientByType(this.screenType)),
          //color: getColor(),
          height: 4.0,
        ),
      ),
    );
  }
}
