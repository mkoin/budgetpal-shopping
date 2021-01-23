import '../models/address.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../models/product_order.dart';
import '../models/user.dart';

class Schedule {
  String id;
  String name;
  String timeline;
  String status;
  String created_at;
  String updated_at;

  Schedule();

  Schedule.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      timeline = jsonMap['timeline'].toString();
      name = jsonMap['name'].toString();
      status = jsonMap['status'].toString();
      created_at = jsonMap['created_at'].toString();
      updated_at = jsonMap['updated_at'].toString();
    } catch (e) {
      id = '';
      timeline = '';
      status = '';
      name = '';
      created_at = '';
      updated_at = '';
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["timeline"] = timeline;
    map["name"] = name;
    map["status"] = status;
    map["created_at"] = created_at;
    map["updated_at"] = updated_at;
    return map;
  }
}
