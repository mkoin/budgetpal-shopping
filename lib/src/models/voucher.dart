import '../models/address.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../models/product_order.dart';
import '../models/user.dart';

class Voucher {
  String id;
  String creater_id;
  String delegated_id;
  String amount;
  String voucher_type_id;
  String daily_limit;
  String monthly_limit;
  String name;
  String image_url;
  String status;
  String created_at;
  String updated_at;

  Voucher();

  Voucher.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      creater_id = jsonMap['creater_id'].toString();
      name = jsonMap['name'].toString();
      image_url = jsonMap['image_url'].toString();
      delegated_id = jsonMap['delegated_id'].toString();
      amount = jsonMap['amount'].toString();
      voucher_type_id = jsonMap['voucher_type_id'].toString();
      daily_limit = jsonMap['daily_limit'].toString();
      monthly_limit = jsonMap['monthly_limit'].toString();
      status = jsonMap['status'].toString();
      created_at = jsonMap['created_at'].toString();
      updated_at = jsonMap['updated_at'].toString();
    } catch (e) {
      id = '';
      creater_id = '';
      delegated_id = '';
      amount = '';
      voucher_type_id = '';
      daily_limit = '';
      monthly_limit = '';
      name = '';
      status = '';
      image_url = '';
      created_at = '';
      updated_at = '';
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["creater_id"] = creater_id;
    map["delegated_id"] = delegated_id;
    map["amount"] = amount;
    map["voucher_type_id"] = voucher_type_id;
    map["daily_limit"] = daily_limit;
    map["monthly_limit"] = monthly_limit;
    map["status"] = status;
    map["name"] = name;
    map["image_url"] = image_url;
    map["created_at"] = created_at;
    map["updated_at"] = updated_at;
    return map;
  }

}
