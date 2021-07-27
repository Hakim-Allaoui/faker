import 'package:faker/utils/strings.dart';
import 'package:faker/widgets/profile/profile_widgets.dart';
import 'package:flutter/material.dart';
import 'package:faker/utils/theme.dart';

class ButtonRowProfile extends StatefulWidget {
  final String button;
  final Function(String) onChanged;

  const ButtonRowProfile({Key key, this.onChanged, this.button}) : super(key: key);
  @override
  _ButtonRowProfileState createState() => _ButtonRowProfileState();
}

class _ButtonRowProfileState extends State<ButtonRowProfile> {
  // String chosenValue = widget.button ?? 'Add to Story';

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
                      canvasColor: Palette.white.withOpacity(0.5),
                    ),
                    child: DropdownButton<String>(
                      value: widget.button ?? 'Add to Story',
                      underline: SizedBox(),
                      iconSize: 0.0,
                      isExpanded: true,
                      items: Strings.labelIconsProfile
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
                                    svgIcon: Strings.svgIconsProfile[
                                    Strings.labelIconsProfile.indexOf(item)],
                                  ),
                                ),
                                SizedBox(
                                  width: item == 'Add to Story' ? 0.0 : 8.0,
                                ),
                                item == 'Add to Story'
                                    ? SizedBox()
                                    : GreyButton(
                                  svgIcon: item == 'Message'
                                      ? 'assets/icons/profile/friend.svg'
                                      : 'assets/icons/messenger.svg',
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
                          widget.onChanged(value);
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
