from marshmallow import Schema, fields


class OrderProductBaseSchema(Schema):

    order_product_id = fields.Int()
    product_sku = fields.Int()
    name = fields.Str()
    quantity = fields.Int()
    order_id = fields.UUID()
    variant = fields.Str()

    @staticmethod
    def from_offer_order_product(offer_order_product: list[dict]):
        """Create an order product based on an offer order
        """

        schema = OrderProductBaseSchema(unknown='EXCLUDE')

        # Remove old order_product_id if any
        offer_order_product.pop('order_product_id', None)

        return schema.load({
            **offer_order_product,
            'product_sku': offer_order_product.get('sku'),
            'name': offer_order_product.get('product_name'),
            'variant': ', '.join([
                value.get('value')
                for value in offer_order_product.get('variant', {}).get('values', [])
            ]),
        })
