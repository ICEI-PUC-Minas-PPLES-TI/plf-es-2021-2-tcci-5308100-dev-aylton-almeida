import 'package:delivery_manager/app/data/models/delivery.dart';

final baseOrder = {
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
};

final deliverySample = Delivery.fromJson({
  'deliveryId': 'delivery_id',
  'supplierId': 1,
  'offerId': 'offer_id',
  'name': 'Sample Delivery',
  'status': 'created',
  'accessCode': 'ABCDE',
  'reportSent': false,
  'deliveryDate': '2022-03-19T20:52:08.354Z',
  'orders': [
    {
      ...baseOrder,
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
    },
    {
      ...baseOrder,
      'orderProducts': [
        {
          'orderProductId': 3,
          'productSku': 2,
          'name': 'product 2',
          'quantity': 2,
          'variant': 'variant 2',
        },
      ]
    },
  ]
});
