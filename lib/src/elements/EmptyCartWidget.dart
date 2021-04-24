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
    throw Exception('Failed to load Market');
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
                      Theme.of(context).accentColor.withOpacity(0.2),
                ),
              )
            : SizedBox(),

        Text("Select a branch", style: Theme.of(context).textTheme.headline3.merge(TextStyle(fontWeight: FontWeight.w300)), ),
        SizedBox(height: 10,),

        Expanded(
            child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          children: soks
              .map(
                (e) => GestureDetector(
                  onTap: ()
                  {
                    Navigator.of(context).pushNamed("/Pages", arguments: 4);
                  },
                  child: Card(
                   // color: Colors.transparent,
                    elevation: 0,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 90,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: NetworkImage(e.image.icon),
                                    fit: BoxFit.cover)),
                            child: Transform.translate(
                              offset: Offset(50, -50),
                              child: Container(
                                margin:
                                EdgeInsets.symmetric(horizontal: 65, vertical: 63),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                // child: Icon(
                                //   Icons.bookmark_border,
                                //   size: 15,
                                // ),
                              ),
                            ),
                          ),
                          Text(e.name,style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(fontWeight: FontWeight.w300)),)
                        ],
                      ),
                    )

                  ),
                ),
              )
              .toList(),
        )),

      ],
    );
  }
}
