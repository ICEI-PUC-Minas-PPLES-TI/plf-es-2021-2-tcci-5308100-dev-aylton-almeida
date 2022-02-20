from marshmallow import Schema, fields

from src.schemas.AddressBaseSchema import AddressBaseSchema
from src.schemas.OrderProductBaseSchema import OrderProductBaseSchema


class OrderBaseSchema(Schema):

    order_id = fields.UUID()
    buyer_name = fields.Str(default='unknown')
    delivered = fields.Bool()
    shipping_address_id = fields.Int()
    delivery_id = fields.UUID()

    shipping_address = fields.Nested(AddressBaseSchema)
    order_products = fields.Nested(OrderProductBaseSchema, many=True)

    @staticmethod
    def from_offer_order(offer_order: dict):
        """Create an order based on an offer order
        """
        # TODO: test

        schema = OrderBaseSchema(unknown='EXCLUDE')

        return schema.load({
            **offer_order,
            'buyer_name': offer_order.get('buyer', {}).get('name'),
            'shipping_address': AddressBaseSchema.from_offer_order_address(offer_order.get('shipping_address')),
            'order_products': [
                OrderProductBaseSchema.from_offer_order_product(order_product)
                for order_product in offer_order.get('order_products', [])
            ]
        })
