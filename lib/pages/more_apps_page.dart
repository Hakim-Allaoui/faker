import 'dart:convert';

import 'package:faker/utils/ads_helper.dart';
import 'package:faker/utils/theme.dart';
import 'package:faker/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

const String MORE_APPS = "https://raw.githubusercontent.com/Hakim-Allaoui/More_apps/main/index.json";

class MoreApps extends StatefulWidget {
  @override
  _MoreAppsState createState() => _MoreAppsState();
}

class _MoreAppsState extends State<MoreApps> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  Ads ads;


  List<FeaturedApp> _appsList = [];
  Widget _body = CircularProgressIndicator();

  @override
  void initState() {
    super.initState();
    ads = new Ads();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              scaffoldKey: scaffoldKey,
              bannerAd: ads.getBannerAd(),
              leading: IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/backarrow.svg',
                  color: Colors.black,
                  width: 15.0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                'featured_apps'.tr().replaceAll("\\n", "\n"),
                style: MyTextStyles.bigTitleBold.apply(color: Palette.black),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: _appsList.length > 0 ? _buildBody() : Center(child: _body),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: getData,
      child: ListView.builder(
        itemCount: _appsList.length,
        itemBuilder: (BuildContext ctx, index) {
          return InkWell(
            onTap: () async {
              String url = _appsList[index].url;
              try{
                await launch(url);
              } catch (e) {
                print('Could not launch $url, error: $e');
              }
            },
            child: Card(
              elevation: 8,
              child: Row(
                children: [
                  SizedBox(
                    height: 80.0,
                    width: 80.0,
                    child: ClipRRect(
                      child: Image.network(
                        _appsList[index].iconUrl,
                        height: 80.0,
                      ),
                      borderRadius:
                      BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        children: [
                          Text(
                            _appsList[index].title,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.yellow[600], size: 20.0,),
                                  Text(_appsList[index].rating.toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.0,
                                      )),
                                ],
                              ),
                              Expanded(
                                child:Text("${index + 1}# trending",
                                  style: TextStyle(
                                    fontSize: 12.0,
                                  color: Colors.red), textAlign: TextAlign.end,),
                              )
                            ],
                          ),
                        ],
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<List<FeaturedApp>> getData() async {
    setState(() {
      _body = CircularProgressIndicator();
    });
    final response = await http.get(MORE_APPS);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      var values = json.decode(response.body);
      print(values);
      setState(() {
        _appsList = List<FeaturedApp>.from(
            values.map((model) => FeaturedApp.fromJson(model)));
      });
      setState(() {});
      return _appsList;
    } else {
      // If that call was not successful, throw an error.
      setState(() {
        _body = Text('No Data');
      });
      throw Exception('Failed to load post');
    }
  }
}

class FeaturedApp {
  String title;
  String url;
  String iconUrl;
  double rating;

  FeaturedApp({this.title, this.url, this.iconUrl, this.rating});

  factory FeaturedApp.fromJson(Map<String, dynamic> json) {
    return FeaturedApp(
      title: json["title"],
      url: json["url"],
      iconUrl: json["icon_url"],
      rating: double.parse(json["rating"].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": this.title,
      "url": this.url,
      "icon_url": this.iconUrl,
      "rating": this.rating,
    };
  }
//

}
