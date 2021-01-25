import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../controllers/delivery_pickup_controller.dart';
import '../elements/CartBottomDetailsWidget.dart';
import '../elements/DeliveryAddressDialog.dart';
import '../elements/DeliveryAddressesItemWidget.dart';
import '../elements/NotDeliverableAddressesItemWidget.dart';
import '../elements/PickUpMethodItemWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../helpers/helper.dart';
import '../models/address.dart';
import '../models/payment_method.dart';
import '../models/route_argument.dart';

enum SingingCharacter { ASAP, SCHEDULED }

class DeliveryPickupWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  DeliveryPickupWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _DeliveryPickupWidgetState createState() => _DeliveryPickupWidgetState();
}

class _DeliveryPickupWidgetState extends StateMVC<DeliveryPickupWidget> {
  DeliveryPickupController _con;
  var userAddress = 'info';
  var userSchedules = 'SCHEDULE';
  var chosenSchedules = 'none';
  SingingCharacter _character = SingingCharacter.ASAP;

  _DeliveryPickupWidgetState() : super(DeliveryPickupController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.schedulePickUpTimes();
    super.initState();
    _locationScreenToShow();
  }

  Future<void> _locationScreenToShow() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userAddress = prefs.getString('locationName');
  }

  @override
  Widget build(BuildContext context) {
    if (_con.list == null) {
      _con.list = new PaymentMethodList(context);
//      widget.pickup = widget.list.pickupList.elementAt(0);
//      widget.delivery = widget.list.pickupList.elementAt(1);
    }
    return Scaffold(
      key: _con.scaffoldKey,
      bottomNavigationBar: CartBottomDetailsWidget(con: _con),
      appBar: AppBar(
        bottom: PreferredSize(
            child: Container(
              color: Colors.orange,
              height: 1.0,
            ),
            preferredSize: Size.fromHeight(2.0)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).delivery_or_pickup,
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.only(left: 20, right: 10),
            //   child: ListTile(
            //     contentPadding: EdgeInsets.symmetric(vertical: 0),
            //     leading: Icon(
            //       Icons.domain,
            //       color: Theme.of(context).hintColor,
            //     ),
            //     title: Text(
            //       S.of(context).pickup,
            //       maxLines: 1,
            //       overflow: TextOverflow.ellipsis,
            //       style: Theme.of(context).textTheme.headline4,
            //     ),
            //     subtitle: Text(
            //       S.of(context).pickup_your_product_from_the_market,
            //       maxLines: 1,
            //       overflow: TextOverflow.ellipsis,
            //       style: Theme.of(context).textTheme.caption,
            //     ),
            //   ),
            // ),
            // PickUpMethodItem(
            //     paymentMethod: _con.getPickUpMethod(),
            //     onPressed: (paymentMethod) {
            //       _con.togglePickUp();
            //     }),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 10, left: 20, right: 10),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    leading: Icon(
                      Icons.map,
                      color: Theme.of(context).hintColor,
                    ),
                    title: Text(
                      S.of(context).delivery,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    subtitle: _con.carts.isNotEmpty &&
                            Helper.canDelivery(_con.carts[0].product.market,
                                carts: _con.carts)
                        ? Text(
                            S
                                .of(context)
                                .click_to_confirm_your_address_and_pay_or_long_press,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.caption,
                          )
                        : Text(
                            S.of(context).deliveryMethodNotAllowed,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.caption,
                          ),
                  ),
                ),
                _con.carts.isNotEmpty &&
                        Helper.canDelivery(_con.carts[0].product.market,
                            carts: _con.carts)
                    ? DeliveryAddressesItemWidget(
                        paymentMethod: _con.getDeliveryMethod(),
                        address: _con.deliveryAddress,
                        onPressed: (Address _address) {
                          if (_con.deliveryAddress.id == null ||
                              _con.deliveryAddress.id == 'null') {
                            DeliveryAddressDialog(
                              context: context,
                              address: _address,
                              onChanged: (Address _address) {
                                _con.addAddress(_address);
                              },
                            );
                          } else {
                            _con.toggleDelivery();
                          }
                        },
                        onLongPress: (Address _address) {
                          DeliveryAddressDialog(
                            context: context,
                            address: _address,
                            onChanged: (Address _address) {
                              _con.updateAddress(_address);
                            },
                          );
                        },
                      )
                    : NotDeliverableAddressesItemWidget(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    leading: Icon(
                      Icons.map,
                      color: Theme.of(context).hintColor,
                    ),
                    title: Text(
                      "Extra Delivery Information",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    subtitle: Text(
                      userAddress,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 0),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    leading: Icon(
                      Icons.delivery_dining,
                      color: Theme.of(context).hintColor,
                    ),
                    title: Text(
                      "Delivery Time",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RadioListTile<SingingCharacter>(
                        title: Text('ASAP', style: TextStyle(fontSize: 12)),
                        value: SingingCharacter.ASAP,
                        groupValue: _character,
                        onChanged: (SingingCharacter value) async{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setString('delivery_schedule_id', "1");
                          setState(() {
                            _character = value;
                            userSchedules = "SCHEDULE";
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<SingingCharacter>(
                        title: Text('$userSchedules',
                            style: TextStyle(fontSize: 12)),
                        value: SingingCharacter.SCHEDULED,
                        groupValue: _character,
                        onChanged: (SingingCharacter value) {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (_) => new AlertDialog(
                              title: Column(
                                children: [
                                  new Text("Schedule Delivery"),
                                  Divider(
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                              content: Container(
                                // color: Colors.blue,
                                height: 170,
                                child: ListView.builder(
                                  itemCount: _con.schedules.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () async{
                                        Navigator.of(context).pop();
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        prefs.setString('delivery_schedule_id', _con.schedules[index].id);
                                        setState(() {
                                          chosenSchedules =
                                              _con.schedules[index].id;
                                          userSchedules =
                                              "SCHEDULE\n${_con.schedules[index].name} ${_con.schedules[index].timeline}";
                                        });
                                      },
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${(index + 1)}. ${_con.schedules[index].name}",
                                                style: TextStyle(
                                                    // color: Colors.blue,
                                                    fontSize: 16),
                                                textAlign: TextAlign.start,
                                              ),
                                              Text(
                                                " Time: ${_con.schedules[index].timeline}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              // actions: <Widget>[
                              //   FlatButton(
                              //     child: Text('Close'),
                              //     onPressed: () {
                              //       Navigator.of(context).pop();
                              //       _character = SingingCharacter.ASAP;
                              //     },
                              //   ),
                              // ],
                            ),
                          );
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
