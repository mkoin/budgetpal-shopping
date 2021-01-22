import '../models/address.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../models/product_order.dart';
import '../models/user.dart';

class VoucherType {
  String id;
  String name;
  String status;
  String created_at;
  String updated_at;

  // VoucherType();
  VoucherType(
      this.id, this.name, this.status, this.created_at, this.updated_at);

  VoucherType.fromJSON(dynamic jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'].toString();
      status = jsonMap['status'].toString();
      created_at = jsonMap['created_at'].toString();
      updated_at = jsonMap['updated_at'].toString();
    } catch (e) {
      id = '';
      name = '';
      status = '';
      created_at = '';
      updated_at = '';
    }
  }

  factory VoucherType.fromJson(dynamic jsonMap) {
    return VoucherType(
        jsonMap['id'].toString(),
        jsonMap['name'].toString(),
        jsonMap['status'].toString(),
        jsonMap['created_at'].toString(),
        jsonMap['updated_at'].toString());
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["status"] = status;
    map["name"] = name;
    map["created_at"] = created_at;
    map["updated_at"] = updated_at;
    return map;
  }
}
