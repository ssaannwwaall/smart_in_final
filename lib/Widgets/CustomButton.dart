import 'package:flutter/material.dart';
import 'package:smarty/shared/res/colors.dart';

class CustomButton extends StatelessWidget {
  final String lable;
  final void Function()? _function_handler;
  final double width;
  Color? background;

  CustomButton(this.lable, this.width, this._function_handler,
      {this.background});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      width: width,
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: background != null ? MaterialStateProperty.all(background) : MaterialStateProperty.all(SmartyColors.primary),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side:  BorderSide(color: SmartyColors.primary),
                  )
              )
          ),

        onPressed: _function_handler,
        child: Padding(
          padding: const EdgeInsets.only(top: 13.0, bottom: 13),
          child: Text(
            lable,
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20,
                color: background != null ? SmartyColors.primary :  Colors.white),
              // background != null
              // ? SmartyColors.primary
              // :
          ),
        ),
      ),
    );
  }
}
