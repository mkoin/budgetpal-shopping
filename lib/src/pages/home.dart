import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:markets/src/controllers/delivery_addresses_controller.dart';
import 'package:markets/src/models/address.dart';
import 'package:markets/src/repository/settings_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/home_controller.dart';
import '../elements/CardsCarouselWidget.dart';
import '../elements/CaregoriesCarouselWidget.dart';
import '../elements/DeliveryAddressBottomSheetWidget.dart';
import '../elements/GridWidget.dart';
import '../elements/ProductsCarouselWidget.dart';
import '../elements/ReviewsListWidget.dart';
import '../elements/SearchBarWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../repository/settings_repository.dart' as settingsRepo;
import '../repository/user_repository.dart';

class HomeWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  HomeWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends StateMVC<HomeWidget> {
  HomeController _con;
  bool _hasLocation = false;
  var userAddress = "Set delivery location";

  _HomeWidgetState() : super(HomeController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
    _getLocationState();
    _locationScreenToShow();
  }

  _getLocationState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('locationState', false);
  }

  Future<bool> _locationScreenToShow() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool intValue = prefs.getBool('locationState');
    userAddress = prefs.getString('locationName');
    if (userAddress == null) {
      userAddress = "Set delivery location";
    }
    _hasLocation = intValue;
    return intValue;
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delivery Address'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Set Your Delivery Address'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () async {
                // Navigator.of(context).pop();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            DeliveryAddressBottomSheetWidget(
                                scaffoldKey: widget.parentScaffoldKey)));
                // var bottomSheetController = widget.parentScaffoldKey.currentState.showBottomSheet(
                //       (context) => DeliveryAddressBottomSheetWidget(scaffoldKey: widget.parentScaffoldKey),
                //   shape: RoundedRectangleBorder(
                //     borderRadius: new BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                //   ),
                // );
                // bottomSheetController.closed.then((value) {
                //   _con.refreshHome();
                // });
              },
            ),
          ],
        );
      },
    );
  }

  // _deliveryAddress() async {
  //   if (currentUser.value.apiToken == null) {
  //     _con.requestForCurrentLocation(context);
  //   } else {
  //     var bottomSheetController =
  //         widget.parentScaffoldKey.currentState.showBottomSheet(
  //       (context) => DeliveryAddressBottomSheetWidget(
  //           scaffoldKey: widget.parentScaffoldKey),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: new BorderRadius.only(
  //             topLeft: Radius.circular(10), topRight: Radius.circular(10)),
  //       ),
  //     );
  //     bottomSheetController.closed.then((value) {
  //       _con.refreshHome();
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    _locationScreenToShow();
    // _showMyDialog();
    // var bottomSheetController =
    //     widget.parentScaffoldKey.currentState.showBottomSheet(
    //   (context) => DeliveryAddressBottomSheetWidget(
    //       scaffoldKey: widget.parentScaffoldKey),
    //   shape: RoundedRectangleBorder(
    //     borderRadius: new BorderRadius.only(
    //         topLeft: Radius.circular(10), topRight: Radius.circular(10)),
    //   ),
    // );
    // bottomSheetController.closed.then((value) {
    //   _con.refreshHome();
    // });

    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
            child: Container(
              color: Colors.orange,
              height: 1.0,
            ),
            preferredSize: Size.fromHeight(2.0)),
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: ValueListenableBuilder(
          valueListenable: settingsRepo.setting,
          builder: (context, value, child) {
            return Text(
              value.appName ?? S.of(context).home,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .merge(TextStyle(letterSpacing: 1.3)),
            );
          },
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: !_hasLocation
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "To be Delivered At:\n",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  RaisedButton.icon(
                    onPressed: () {
                      if (currentUser.value.apiToken == null) {
                        _con.requestForCurrentLocation(context);
                      } else {
                        var bottomSheetController = widget
                            .parentScaffoldKey.currentState
                            .showBottomSheet(
                          (context) => DeliveryAddressBottomSheetWidget(
                              scaffoldKey: widget.parentScaffoldKey),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                          ),
                        );
                        bottomSheetController.closed.then((value) {
                          _con.refreshHome();
                        });
                      }
                    },
                    icon: Icon(
                      Icons.my_location,
                      color: Theme.of(context).hintColor,
                    ),
                    label: Text("Lets Know your delivery Address"),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _con.refreshHome,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.red,
                          ),
                          Text(
                            "${userAddress}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                        leading: Icon(
                          Icons.category,
                          color: Theme.of(context).hintColor,
                        ),
                        title: Text(
                          S.of(context).product_categories,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SearchBarWidget(
                        onClickFilter: (event) {
                          widget.parentScaffoldKey.currentState.openEndDrawer();
                        },
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                    //   child: ListTile(
                    //     dense: true,
                    //     contentPadding: EdgeInsets.symmetric(vertical: 0),
                    //     leading: Icon(
                    //       Icons.stars,
                    //       color: Theme.of(context).hintColor,
                    //     ),
                    //     trailing: IconButton(
                    //       onPressed: () {
                    //         if (currentUser.value.apiToken == null) {
                    //           _con.requestForCurrentLocation(context);
                    //         } else {
                    //           var bottomSheetController = widget
                    //               .parentScaffoldKey.currentState
                    //               .showBottomSheet(
                    //             (context) => DeliveryAddressBottomSheetWidget(
                    //                 scaffoldKey: widget.parentScaffoldKey),
                    //             shape: RoundedRectangleBorder(
                    //               borderRadius: new BorderRadius.only(
                    //                   topLeft: Radius.circular(10),
                    //                   topRight: Radius.circular(10)),
                    //             ),
                    //           );
                    //           bottomSheetController.closed.then((value) {
                    //             _con.refreshHome();
                    //           });
                    //         }
                    //       },
                    //       icon: Icon(
                    //         Icons.my_location,
                    //         color: Theme.of(context).hintColor,
                    //       ),
                    //     ),
                    //     title: Text(
                    //       S.of(context).top_markets,
                    //       style: Theme.of(context).textTheme.headline4,
                    //     ),
                    //     subtitle: Text(
                    //       S.of(context).near_to +
                    //           " " +
                    //           (settingsRepo.deliveryAddress.value?.address ??
                    //               S.of(context).unknown),
                    //       style: Theme.of(context).textTheme.caption,
                    //     ),
                    //   ),
                    // ),
                    // CardsCarouselWidget(
                    //     marketsList: _con.topMarkets, heroTag: 'home_top_markets'),

                    CategoriesCarouselWidget(
                      categories: _con.categories,
                      showGrid: true,
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    //   child: ListTile(
                    //     dense: true,
                    //     contentPadding: EdgeInsets.symmetric(vertical: 0),
                    //     leading: Icon(
                    //       Icons.trending_up,
                    //       color: Theme.of(context).hintColor,
                    //     ),
                    //     title: Text(
                    //       S.of(context).most_popular,
                    //       style: Theme.of(context).textTheme.headline4,
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 20),
                    //   child: GridWidget(
                    //     marketsList: _con.popularMarkets,
                    //     heroTag: 'home_markets',
                    //   ),
                    // ),
                    // ListTile(
                    //   dense: true,
                    //   contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    //   leading: Icon(
                    //     Icons.trending_up,
                    //     color: Theme.of(context).hintColor,
                    //   ),
                    //   title: Text(
                    //     S.of(context).trending_this_week,
                    //     style: Theme.of(context).textTheme.headline4,
                    //   ),
                    //   subtitle: Text(
                    //     S.of(context).clickOnTheProductToGetMoreDetailsAboutIt,
                    //     maxLines: 2,
                    //     style: Theme.of(context).textTheme.caption,
                    //   ),
                    // ),
                    // ProductsCarouselWidget(
                    //     productsList: _con.trendingProducts,
                    //     heroTag: 'home_product_carousel'),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 20),
                    //   child: ListTile(
                    //     dense: true,
                    //     contentPadding: EdgeInsets.symmetric(vertical: 20),
                    //     leading: Icon(
                    //       Icons.recent_actors,
                    //       color: Theme.of(context).hintColor,
                    //     ),
                    //     title: Text(
                    //       S.of(context).recent_reviews,
                    //       style: Theme.of(context).textTheme.headline4,
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 20),
                    //   child: ReviewsListWidget(reviewsList: _con.recentReviews),
                    // ),
                  ],
                ),
              ),
            ),
    );
  }
}
