import 'package:flutter/material.dart';
import 'package:markets/src/controllers/product_controller.dart';
import 'package:markets/src/helpers/helper.dart';
import 'package:markets/src/repository/settings_repository.dart';
import 'package:markets/src/repository/user_repository.dart';

import '../models/product.dart';
import '../models/route_argument.dart';

class ProductGridItemWidget extends StatefulWidget {
  final String heroTag;
  final Product product;
  final VoidCallback onPressed;

  ProductGridItemWidget({Key key, this.heroTag, this.product, this.onPressed})
      : super(key: key);

  @override
  _ProductGridItemWidgetState createState() => _ProductGridItemWidgetState();
}

class _ProductGridItemWidgetState extends State<ProductGridItemWidget> {
  ProductController _con = new ProductController();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      onTap: () {
        Navigator.of(context).pushNamed('/Product',
            arguments: new RouteArgument(
                heroTag: this.widget.heroTag, id: this.widget.product.id));
      },
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Hero(
                  tag: widget.heroTag + widget.product.id,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(this.widget.product.image.thumb),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text(
                "${widget.product.name}~${setting.value?.defaultCurrency}.${widget.product.price}",
                style: Theme.of(context).textTheme.bodyText1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2),
              Text(
                widget.product.market.name,
                style: Theme.of(context).textTheme.caption,
                overflow: TextOverflow.ellipsis,
              ),
              Center(
                child: RaisedButton(
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
              ),
            ],
          ),
          // Container(
          //   margin: EdgeInsets.all(10),
          //   width: 40,
          //   height: 40,
          //   child: FlatButton(
          //     padding: EdgeInsets.all(0),
          //     onPressed: () {
          //       widget.onPressed();
          //     },
          //     child: Icon(
          //       Icons.shopping_cart,
          //       color: Theme.of(context).primaryColor,
          //       size: 24,
          //     ),
          //     color: Theme.of(context).accentColor.withOpacity(0.9),
          //     shape: StadiumBorder(),
          //   ),
          // ),
        ],
      ),
    );
  }
}
