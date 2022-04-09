import 'package:delivery_manager/app/data/models/order.dart';

final orderSample = Order.fromJson({
  'orderId': 'id',
  'buyerName': 'buyer name',
  'delivered': false,
  'shippingAddressId': 1,
  'deliveryId': 'id',
  'shippingAddress': {
    'addressId': 1,
    'cityName': 'value',
    'countryState': 'value',
    'streetName': 'value',
    'streetNumber': 'value',
    'unitNumber': 'value',
    'postalCode': 'value',
    'neighborhoodName': 'value',
    'lat': 1,
    'lng': 1,
  },
  'orderProducts': [
    {
      'orderProductId': 1,
      'productSku': 1,
      'name': 'product 1',
      'quantity': 2,
      'variant': 'variant 1',
    },
    {
      'orderProductId': 2,
      'productSku': 2,
      'name': 'product 2',
      'quantity': 2,
      'variant': 'variant 2',
    },
  ]
});
