import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:markets/src/models/voucher.dart';
import 'package:markets/src/repository/order_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../elements/PaymentMethodListItemWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../models/payment_method.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';

class PaymentMethodsWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  PaymentMethodsWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _PaymentMethodsWidgetState createState() => _PaymentMethodsWidgetState();
}

class _PaymentMethodsWidgetState extends State<PaymentMethodsWidget> {
  PaymentMethodList list;
  var _subTotal = 0.0;
  var _chosenVoucher;
  var _chosenCashPayment;
  var _chosenEnabledPayment;
  var theChoseRoute;
  bool _setVoucherPaymentSuccessVisible = false;
  bool _submitPurchase = false;
  List<Voucher> voucher = <Voucher>[];

  @override
  void initState() {
    listenForOrders();
    super.initState();
  }

  void listenForOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _subTotal = prefs.getDouble("SubTotal");
    final Stream<Voucher> stream = await getMyVouchers();
    stream.listen((Voucher _voucher) {
      setState(() {
        voucher.add(_voucher);
      });
    }, onError: (a) {
      print("IKOERROR$a");
    }, onDone: () {});
  }

  @override
  Widget build(BuildContext context) {
    list = new PaymentMethodList(context);
    if (!setting.value.payPalEnabled)
      list.paymentsList.removeWhere((element) {
        return element.id == "paypal";
      });
    if (!setting.value.razorPayEnabled)
      list.paymentsList.removeWhere((element) {
        return element.id == "razorpay";
      });
    if (!setting.value.stripeEnabled)
      list.paymentsList.removeWhere((element) {
        return element.id == "visacard" || element.id == "mastercard";
      });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).payment_mode,
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
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: SearchBarWidget(),
            // ),
            Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  S.of(context).select_your_preferred_payment_mode,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            voucher.length > 0
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 5),
                    child: Text("\nBy my vouchers"),
                  )
                : SizedBox(
                    height: 0,
                  ),
            Container(
              height: 105,
              child: ListView.builder(
                itemCount: this.voucher.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  double _marginLeft = 0;
                  (index == 0) ? _marginLeft = 20 : _marginLeft = 0;
                  return InkWell(
                    splashColor: Theme.of(context).accentColor,
                    focusColor: Theme.of(context).accentColor,
                    highlightColor: Theme.of(context).primaryColor,
                    onTap: () {
                      if (_subTotal > int.parse(voucher[index].amount)) {
                        showDialog(
                            context: context,
                            builder: (_) => new CupertinoAlertDialog(
                                  title: new Text("Funds Insufficient"),
                                  content: new Text(
                                      "\nVoucher Insufficient for this Shopping"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('Ok'),
                                      onPressed: () {
                                        setState(() {
                                          _setVoucherPaymentSuccessVisible =
                                              false;
                                          _chosenCashPayment = '';
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ));
                      } else {
                        setState(() {
                          _submitPurchase = true;
                          _chosenCashPayment = '';
                          theChoseRoute = '/vouchers';
                          _setVoucherPaymentSuccessVisible = true;
                        });
                      }
                      setState(() {
                        _chosenVoucher = index;
                        _chosenCashPayment = '';
                      });
                      // Navigator.of(context).pushNamed(this.paymentMethod.route);
                      // print(this.paymentMethod.name);
                    },
                    child: Card(
                      color:
                          _chosenVoucher == index ? Colors.cyan : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Center(
                              child: CachedNetworkImage(
                                height: 40,
                                width: 60,
                                fit: BoxFit.fill,
                                imageUrl: voucher[index].image_url,
                                placeholder: (context, url) => Image.asset(
                                  'assets/img/loading.gif',
                                  fit: BoxFit.cover,
                                  height: 40,
                                  width: 60,
                                ),
                                errorWidget: (context, url, error) =>
                                    Center(child: Icon(Icons.error)),
                              ),
                            ),
                            Text(
                              voucher[index].name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Ksh.${voucher[index].amount}",
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style:
                                  TextStyle(color: Colors.green, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            _setVoucherPaymentSuccessVisible
                ? Container(
                    color: Colors.red.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                          Text(
                            "Proceed to Make a Payment Of Ksh.$_subTotal",
                            style: TextStyle(color: Colors.green),
                          )
                        ],
                      ),
                    ),
                  )
                : SizedBox(),
            // SizedBox(height: 10),
            // list.paymentsList.length > 0
            //     ? Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 20),
            //         child: ListTile(
            //           contentPadding: EdgeInsets.symmetric(vertical: 0),
            //           leading: Icon(
            //             Icons.payment,
            //             color: Theme.of(context).hintColor,
            //           ),
            //           title: Text(
            //             S.of(context).payment_options,
            //             maxLines: 1,
            //             overflow: TextOverflow.ellipsis,
            //             style: Theme.of(context).textTheme.headline4,
            //           ),
            //           subtitle: Text(
            //               S.of(context).select_your_preferred_payment_mode),
            //         ),
            //       )
            //     : SizedBox(
            //         height: 0,
            //       ),
            // SizedBox(height: 10),
            // ListView.separated(
            //   scrollDirection: Axis.vertical,
            //   shrinkWrap: true,
            //   primary: false,
            //   itemCount: list.paymentsList.length,
            //   separatorBuilder: (context, index) {
            //     return SizedBox(height: 10);
            //   },
            //   itemBuilder: (context, index) {
            //     return PaymentMethodListItemWidget(
            //         paymentMethod: list.paymentsList.elementAt(index));
            //   },
            // ),
            // list.cashList.length > 0
            //     ? Padding(
            //         padding: const EdgeInsets.symmetric(
            //             vertical: 10, horizontal: 20),
            //         child: ListTile(
            //           contentPadding: EdgeInsets.symmetric(vertical: 0),
            //           leading: Icon(
            //             Icons.monetization_on,
            //             color: Theme.of(context).hintColor,
            //           ),
            //           title: Text(
            //             S.of(context).cash_on_delivery,
            //             maxLines: 1,
            //             overflow: TextOverflow.ellipsis,
            //             style: Theme.of(context).textTheme.headline4,
            //           ),
            //           subtitle: Text(
            //               S.of(context).select_your_preferred_payment_mode),
            //         ),
            //       )
            //     : SizedBox(
            //         height: 0,
            //       ),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("\nBy Payment Gateway")),
            ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: list.cashList.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _chosenCashPayment = index;
                      theChoseRoute = list.cashList[index].route;
                      _setVoucherPaymentSuccessVisible = false;
                      _chosenVoucher = '';
                      _submitPurchase = true;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: _chosenCashPayment == index
                          ? Colors.red.withOpacity(0.1)
                          : Theme.of(context).primaryColor.withOpacity(0.9),
                      boxShadow: [
                        BoxShadow(
                            color:
                                Theme.of(context).focusColor.withOpacity(0.1),
                            blurRadius: 5,
                            offset: Offset(0, 2)),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            image: DecorationImage(
                                image: AssetImage(list.cashList[index].logo),
                                fit: BoxFit.fill),
                          ),
                        ),
                        SizedBox(width: 15),
                        Flexible(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      list.cashList[index].name,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                    Text(
                                      list.cashList[index].description,
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: Theme.of(context).focusColor,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: list.paymentsList.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                return PaymentMethodListItemWidget(
                    paymentMethod: list.paymentsList.elementAt(index));
              },
            ),
            _submitPurchase
                ? InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(theChoseRoute);
                      print(theChoseRoute);
                    },
                    child: Container(
                      height: 50,
                      decoration: new BoxDecoration(
                        color: Colors.green,
                        border: Border.all(color: Colors.white, width: 0.0),
                        borderRadius:
                            new BorderRadius.all(Radius.elliptical(50, 50)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Proceed",
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(
                            Icons.navigate_next,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
