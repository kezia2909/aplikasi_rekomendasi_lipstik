import 'package:flutter/material.dart';
import 'package:flutter_application_recommendation/utils/color_utils.dart';

Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 240,
    height: 240,
    color: hexStringToColor("f9e8e6"),
  );
}

Text reusableTextTitle(String title) {
  return Text(title,
      style: TextStyle(
          color: colorTheme(colorWhite),
          fontSize: 25,
          fontWeight: FontWeight.bold));
}

TextField reusableTextFieldLog(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: colorTheme(colorBlack),
    style: TextStyle(color: colorTheme(colorBlack)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: colorTheme(colorBlack),
      ),
      labelText: text,
      labelStyle: TextStyle(color: colorTheme(colorBlack).withOpacity(0.6)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: colorTheme(colorWhite).withOpacity(0.5),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container reusableButtonLog(
  BuildContext context,
  String text,
  Color buttonColor,
  Color fontColor,
  Function onTap,
) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    // margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
    // decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text(
        text,
        style: TextStyle(
            color: fontColor, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return buttonColor;
            }
            return buttonColor;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
    ),
  );
}

Row reusableLogOption(
  BuildContext context,
  String description,
  String logOption,
  Function onTap,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text("$description ", style: TextStyle(color: colorTheme(colorBlack))),
      GestureDetector(
        onTap: () {
          onTap();
        },
        child: Text(
          logOption,
          style: TextStyle(
              color: colorTheme(colorAccent), fontWeight: FontWeight.bold),
        ),
      )
    ],
  );
}

Container reusablePhotoFrame(Image image, double size) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.rectangle,
      border: Border.all(color: colorTheme(colorBlack), width: 5),
    ),
    child: image,
  );
}

Container reusableDataProfile(
    IconData icon, String title, String description, Function onTap) {
  return Container(
    padding: EdgeInsets.all(10.0),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0) //
            ),
        color: colorTheme(colorWhite)),
    child: Row(
      children: [
        Icon(icon, size: 30, color: colorTheme(colorBlack)),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    color: colorTheme(colorBlack),
                    fontSize: 18,
                    fontWeight: FontWeight.w300),
                textAlign: TextAlign.left,
              ),
              Text(
                description,
                style: TextStyle(
                    color: colorTheme(colorBlack),
                    fontSize: 20,
                    fontWeight: FontWeight.normal),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
        GestureDetector(
          child: Icon(Icons.edit, size: 30, color: colorTheme(colorShadow)),
          onTap: () {
            onTap();
          },
        ),
      ],
    ),
  );
}
