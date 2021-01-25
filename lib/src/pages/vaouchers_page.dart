import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markets/generated/l10n.dart';
import 'package:markets/src/models/voucher.dart';
import 'package:markets/src/models/voucher_type.dart';
import 'package:markets/src/repository/order_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VouchersPage extends StatefulWidget {
  @override
  _VouchersPageState createState() => _VouchersPageState();
}

class _VouchersPageState extends State<VouchersPage> {
  List<VoucherType> voucherTypes = <VoucherType>[];
  List<Voucher> delegatedVouchers = <Voucher>[];
  List<Voucher> createdVouchers = <Voucher>[];
  String selectedSpinnerItem = 'none';
  final phoneController = TextEditingController();
  final amountController = TextEditingController();
  final dailyLimitController = TextEditingController();
  final monthLimitController = TextEditingController();
  final voucherTypeController = TextEditingController();

  VoucherType dropdownValue = VoucherType("", "", "", "", "");
  List<String> spinnerItems = ['One', 'Two', 'Three', 'Four', 'Five'];

  @override
  void initState() {
    listenForVoucherType();
    super.initState();
  }

  void listenForVoucherType() async {
    // final stream = await getVoucherTypes();
    getVoucherTypes().then((value) {
      var _voucherTypes = value['data']['vourcherType'] as List;
      var _createdVouchers = value['data']['created'] as List;
      var _delegatedVouchers = value['data']['delegated'] as List;
      setState(() {
        voucherTypes = _voucherTypes
            .map((tagJson) => VoucherType.fromJson(tagJson))
            .toList();

        delegatedVouchers = _delegatedVouchers
            .map((tagJson) => Voucher.fromJSON(tagJson))
            .toList();

        createdVouchers = _createdVouchers
            .map((tagJson) => Voucher.fromJSON(tagJson))
            .toList();
      });
    }).catchError((e) {
      print(e);
      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text(e),
      // ));
    }).whenComplete(() {
      //refreshOrders();
      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text(S.of(context).orderThisorderidHasBeenCanceled(order.id)),
      // ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Vouchers & Beneficiaries"),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.create),
                child: Text("Created"),
              ),
              Tab(
                icon: Icon(Icons.wallet_giftcard),
                child: Text("Deligated"),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: createdVouchers.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                createdVouchers[index].name,
                                style: Theme.of(context).textTheme.headline6,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "${createdVouchers[index].created_at}",
                                style: Theme.of(context).textTheme.caption,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Expanded(child: Text("")),
                          Text(
                            "Ksh.${createdVouchers[index].amount}",
                            style: Theme.of(context).textTheme.headline6,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              child: ListView.builder(
                itemCount: delegatedVouchers.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                delegatedVouchers[index].name,
                                style: Theme.of(context).textTheme.headline6,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "${delegatedVouchers[index].created_at}",
                                style: Theme.of(context).textTheme.caption,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Expanded(child: Text("")),
                          Text(
                            "Ksh.${delegatedVouchers[index].amount}",
                            style: Theme.of(context).textTheme.headline6,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                // return object of type Dialog
                return AlertDialog(
                  title: Column(
                    children: <Widget>[
                      Text(
                        "Create a Voucher/Beneficiary",
                        style: TextStyle(color: Colors.blue),
                      ),
                      Divider(),
                    ],
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.number,
                          decoration: new InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.2)),
                              ),
                              focusedBorder: new UnderlineInputBorder(
                                borderSide: new BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.5),
                                ),
                              ),
                              labelText: 'Receiver Phone Number',
                              labelStyle: TextStyle(color: Colors.orange)),
                        ),
                        TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          decoration: new InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.2)),
                              ),
                              focusedBorder: new UnderlineInputBorder(
                                borderSide: new BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.5),
                                ),
                              ),
                              labelText: 'Amount',
                              labelStyle: TextStyle(color: Colors.orange)),
                        ),
                        TextField(
                          controller: dailyLimitController,
                          keyboardType: TextInputType.number,
                          decoration: new InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.2)),
                              ),
                              focusedBorder: new UnderlineInputBorder(
                                borderSide: new BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.5),
                                ),
                              ),
                              labelText: 'Daily Amount(Optional)',
                              labelStyle: TextStyle(color: Colors.orange)),
                        ),
                        TextField(
                          controller: monthLimitController,
                          keyboardType: TextInputType.number,
                          decoration: new InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.2)),
                              ),
                              focusedBorder: new UnderlineInputBorder(
                                borderSide: new BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.5),
                                ),
                              ),
                              labelText: 'Monthly Amount(Optional)',
                              labelStyle: TextStyle(color: Colors.orange)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Choose Type",
                          style: Theme.of(context).textTheme.caption,
                        ),
                        DropdownButton<VoucherType>(
                          isExpanded: true,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            size: 24,
                          ),
                          hint: Text(
                            "Select tags",
                            style: TextStyle(color: Color(0xFF9F9F9F)),
                          ),
                          items: voucherTypes.map((foo) {
                            return DropdownMenuItem(
                              value: foo,
                              child: Text(foo.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedSpinnerItem = value.id;
                            });
                          },
                          value: voucherTypes[0],
                        ),
                      ],
                    ),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                  actions: <Widget>[
                    FlatButton(
                      child: new Text(
                        S.of(context).close,
                        style: TextStyle(color: Theme.of(context).hintColor),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: new Text(
                        S.of(context).yes,
                        style: TextStyle(color: Colors.orange),
                      ),
                      onPressed: () {
                        // createVoucher().
                        if (phoneController.text.trim().isEmpty ||
                            amountController.text.trim().isEmpty) {
                          Fluttertoast.showToast(
                            msg: "Add required Fields",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 5,
                          );
                          return;
                        }

                        Navigator.of(context).pop();
                        createVoucher(
                                phoneController.text,
                                amountController.text,
                                dailyLimitController.text,
                                monthLimitController.text,
                                selectedSpinnerItem)
                            .then((value) {
                          listenForVoucherType();
                          setState(() {
                            // this.loadCart = false;
                          });
                        }).whenComplete(() {});
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Text("Create"),
        ),
      ),
    );
  }
}
