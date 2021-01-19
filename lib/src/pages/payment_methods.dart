import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:markets/src/models/voucher.dart';
import 'package:markets/src/repository/order_repository.dart';

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

  List<Voucher> voucher = <Voucher>[];

  @override
  void initState() {
    listenForOrders();
    super.initState();
  }

  void listenForOrders() async {
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
            voucher.length > 0
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 5),
                    child: Text("Choose a voucher"),
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
                      // Navigator.of(context).pushNamed(this.paymentMethod.route);
                      // print(this.paymentMethod.name);
                    },
                    child: Card(
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
                child: Text(S.of(context).select_your_preferred_payment_mode)),
            ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: list.cashList.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                return PaymentMethodListItemWidget(
                    paymentMethod: list.cashList.elementAt(index));
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
          ],
        ),
      ),
    );
  }
}
