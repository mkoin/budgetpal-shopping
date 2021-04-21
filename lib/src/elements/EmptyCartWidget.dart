import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:markets/src/helpers/helper.dart';
import 'package:http/http.dart' as http;
import 'package:http/src/streamed_response.dart';
import 'package:markets/src/models/market.dart';
import 'package:markets/src/models/market_model.dart';
import 'package:markets/src/repository/market_repository.dart';

import '../../generated/l10n.dart';
import '../helpers/app_config.dart' as config;

List<Soko> soks = <Soko>[];

String s = "";

Future<String> fetchMarkets() async {
  Uri uri = Helper.getUri('api/markets');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    final resp = jsonDecode(response.body);

    List<dynamic> allData = resp['data'];
    allData.forEach((data) {
      Soko markt = Soko.fromJSON(data);
      soks.add(markt);
      print(markt.name);
    });
    return response.body.toString();
  } else {
    throw Exception('Failed to load album');
  }
}


class EmptyCartWidget extends StatefulWidget {

  EmptyCartWidget({
    Key key,
  }) : super(key: key);

  @override
  _EmptyCartWidgetState createState() => _EmptyCartWidgetState();
}

class _EmptyCartWidgetState extends State<EmptyCartWidget> {
  bool loading = true;

  List<String> names = <String>[
    "Naivas Supermarket",
    "Choppies Supermarket",
  ];


  @override
  void initState() {
    // futureMarkets = fetchMarkets();
    fetchMarkets();
    Timer(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        loading
            ? SizedBox(
          height: 3,
          child: LinearProgressIndicator(
            backgroundColor:
            Theme
                .of(context)
                .accentColor
                .withOpacity(0.2),
          ),
        )
            : SizedBox(),
        Container(
          alignment: AlignmentDirectional.center,
          padding: EdgeInsets.symmetric(horizontal: 30),
          height: config.App(context).appHeight(70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 170,
                width: double.infinity,
                child: ListView(
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      Padding(
                        padding:
                        const EdgeInsets.only(top: 15, left: 10, right: 10),
                        child: Text(
                          "Choose a market",
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyText1,
                        ),
                      ),
                      Container(
                          width: double.infinity,
                          height: 150,
                          margin: EdgeInsets.only(top: 15),
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,

                              itemCount: soks.length,
                              itemBuilder: (BuildContext context, int index) {
                                return __marketList(context, index);
                              }
                          )
                      )
                    ]
                ),
              ),

              Stack(
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              Theme
                                  .of(context)
                                  .focusColor
                                  .withOpacity(0.7),
                              Theme
                                  .of(context)
                                  .focusColor
                                  .withOpacity(0.05),
                            ])),
                    child: Icon(
                      Icons.shopping_cart,
                      color: Theme
                          .of(context)
                          .scaffoldBackgroundColor,
                      size: 70,
                    ),
                  ),
                  Positioned(
                    right: -30,
                    bottom: -50,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.15),
                        borderRadius: BorderRadius.circular(150),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -20,
                    top: -50,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.15),
                        borderRadius: BorderRadius.circular(150),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 15),
              Opacity(
                opacity: 0.4,
                child: Text(
                  S
                      .of(context)
                      .dont_have_any_item_in_your_cart,
                  textAlign: TextAlign.center,
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline3
                      .merge(TextStyle(fontWeight: FontWeight.w300)),
                ),
              ),
              SizedBox(height: 50),
              !loading
                  ? FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/Pages', arguments: 4);
                },
                padding:
                EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                color: Theme
                    .of(context)
                    .accentColor
                    .withOpacity(1),
                shape: StadiumBorder(),
                child: Text(
                  S
                      .of(context)
                      .start_exploring,
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline6
                      .merge(
                      TextStyle(
                          color:
                          Theme
                              .of(context)
                              .scaffoldBackgroundColor)),
                ),
              )
                  : SizedBox(),
            ],
          ),
        ),
      ],
    );
  }


  Widget __marketList(BuildContext context, int index) {
    return  InkWell(
      onTap:(){
        Navigator.of(context).pushNamed('/Pages', arguments: 4);
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Column(

          children: <Widget>[
            Container(
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(10),
              //   color: Colors.black,
              //   image: DecorationImage(
              //     image:
              //   )
              //   // image: CachedNetworkImageProvider()
              //
              // )
              child: Image.network(soks[index].image.thumb,
                width: 50,
                fit: BoxFit.cover,
              ),

            ),
            SizedBox(height: 10),
            Text(soks[index].name)
          ],
        ),
      ),
    );
  }


}
