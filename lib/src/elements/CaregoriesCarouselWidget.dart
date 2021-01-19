import 'package:flutter/material.dart';

import '../elements/CategoriesCarouselItemWidget.dart';
import '../elements/CircularLoadingWidget.dart';
import '../models/category.dart';

// ignore: must_be_immutable
class CategoriesCarouselWidget extends StatelessWidget {
  List<Category> categories;
  bool showGrid;

  CategoriesCarouselWidget({Key key, this.categories, this.showGrid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return this.categories.isEmpty
        ? CircularLoadingWidget(height: 150)
        : showGrid
            ? Container(
                height: MediaQuery.of(context).size.height-250,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: GridView.builder(
                  itemCount: this.categories.length,
                  itemBuilder: (context, index) {
                    double _marginLeft = 0;
                    (index == 0) ? _marginLeft = 20 : _marginLeft = 0;
                    return new CategoriesCarouselItemWidget(
                      categories: this.categories,
                      marginLeft: _marginLeft,
                      category: this.categories.elementAt(index),
                    );
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          (orientation == Orientation.portrait) ? 3 : 4),
                ))
            : Container(
                height: 105,
                child: ListView.builder(
                  itemCount: this.categories.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    double _marginLeft = 0;
                    (index == 0) ? _marginLeft = 20 : _marginLeft = 0;
                    return new CategoriesCarouselItemWidget(
                      categories: this.categories,
                      marginLeft: _marginLeft,
                      category: this.categories.elementAt(index),
                    );
                  },
                ));
  }
}
