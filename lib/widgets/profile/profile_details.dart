import 'package:faker/utils/theme.dart';
import 'package:faker/widgets/post/custom_editable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileDetails extends StatefulWidget {
  final Map<String, String> details;
  final Function(String, String) onChanged;

  const ProfileDetails({Key key, this.details, this.onChanged}) : super(key: key);

  @override
  _ProfileDetailsState createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.details.entries.map((entry) {
        return Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: entry.key == "lives" || entry.key == "followed" ? 2.0 : 0.0),
                  child: SvgPicture.asset(
                    'assets/icons/profile/${entry.key}.svg',
                    width: entry.key == "lives" || entry.key == "followed"  ? 20.0 : 25.0,
                    color: Color(0xff8F939A)
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
                    children: [
                      Text(
                        labels[entry.key],
                        style: MyTextStyles.fbTitle,
                      ),
                      CustomEditableText(
                        text: entry.value,
                        textStyle: MyTextStyles.fbTitleBold,
                        onSubmit: (val) {
                          widget.onChanged(entry.key, val);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            )
          ],
        );
      }).toList(),
    );
  }

  Map<String ,String> labels= {
    'lives' : "Lives at ",
    'went' : "Studied at ",
    'manage' : "Manages ",
    'worked' : "Worked at ",
    'relationship' : "",
    'from' : "From ",
    'followed' : "Followed by ",
  };
}
