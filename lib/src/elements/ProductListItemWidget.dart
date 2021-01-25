import 'package:flutter/material.dart';
import 'package:markets/src/controllers/product_controller.dart';
import 'package:markets/src/repository/user_repository.dart';

import '../helpers/helper.dart';
import '../models/product.dart';
import '../models/route_argument.dart';

// ignore: must_be_immutable
class ProductListItemWidget extends StatefulWidget {
  String heroTag;
  Product product;
  final bool isAddedToCart;
  final VoidCallback onPressed;
  var quantity = 1;

  ProductListItemWidget(
      {Key key, this.heroTag, this.isAddedToCart, this.product, this.onPressed})
      : super(key: key);

  @override
  _ProductListItemWidgetState createState() => _ProductListItemWidgetState();
}

class _ProductListItemWidgetState extends State<ProductListItemWidget> {
  ProductController _con = new ProductController();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        Navigator.of(context).pushNamed('/Product',
            arguments: new RouteArgument(
                heroTag: this.widget.heroTag, id: this.widget.product.id));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).focusColor.withOpacity(0.1),
                blurRadius: 5,
                offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: widget.heroTag + widget.product.id,
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  image: DecorationImage(
                      image: NetworkImage(widget.product.image.thumb),
                      fit: BoxFit.cover),
                ),
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
                          widget.product.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Text(
                          widget.product.market.name,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Column(
                    children: [
                      Helper.getPrice(widget.product.price, context,
                          style: Theme.of(context).textTheme.headline4),
                      widget.isAddedToCart
                          ? Container(
                              color: Colors.orangeAccent,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if(widget.quantity>0){
                                            widget.quantity -= 1;
                                          }
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Icon(
                                          Icons.remove,
                                          size: 28,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      widget.quantity.toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          widget.quantity += 1;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Icon(
                                          Icons.add,
                                          size: 28,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : RaisedButton(
                              color: Theme.of(context).accentColor,
                              onPressed: () {
                                if (currentUser.value.apiToken == null) {
                                  Navigator.of(context).pushNamed("/Login");
                                } else {
                                  widget.onPressed();
                                }
                              },
                              child: Text(
                                "Order",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
