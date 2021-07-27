import 'package:faker/utils/strings.dart';
import 'package:faker/utils/theme.dart';
import 'package:faker/widgets/profile/profile_widgets.dart';
import 'package:flutter/material.dart';

class ButtonRowPage extends StatefulWidget {
  @override
  _ButtonRowPageState createState() => _ButtonRowPageState();
}

class _ButtonRowPageState extends State<ButtonRowPage> {
  String _chosenValue = 'Send Messege';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Center(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: Palette.facebookBlue.withOpacity(0.9),
                    ),
                    child: DropdownButton<String>(
                      value: _chosenValue,
                      underline: SizedBox(),
                      iconSize: 0.0,
                      isExpanded: true,
                      items: Strings.labelIconsButton
                          .map<DropdownMenuItem<String>>((String item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: BlueButton(
                                    title: item,
                                    svgIcon: Strings.svgIconsButton[
                                    Strings.labelIconsButton.indexOf(item)],
                                  ),
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                GreyButton(
                                  svgIcon: 'assets/icons/messenger.svg',
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                GreyButton(
                                  svgIcon: 'assets/icons/more_hor.svg',
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String value) {
                        setState(() {
                          _chosenValue = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
