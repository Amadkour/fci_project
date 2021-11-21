import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonTemplate {
  Function onPressed;
  Function onLongPress;
  Widget widget;
  BuildContext context;
  Widget elevatedButton;
  Color color;

  ButtonTemplate(this.onPressed, this.widget, this.context,{this.onLongPress,this.color,padding=const EdgeInsets.all(5.0)}) {
    elevatedButton = Padding(
      padding: padding,
      child: ElevatedButton(
        style: ButtonStyle(
          alignment: Alignment.center,
          side: MaterialStateProperty.all<BorderSide>(
            BorderSide(width: 0, color: Colors.transparent),
          ),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(
                MaterialState.pressed,
              )) return Theme.of(context).primaryColor;
              return color??Colors.white;
            },
          ),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        onPressed: onPressed ?? () {},
        onLongPress: onLongPress??(){},
        child: widget,
      ),
    );
  }
}
