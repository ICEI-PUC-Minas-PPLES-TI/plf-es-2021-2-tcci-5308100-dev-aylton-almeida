from marshmallow import Schema, fields, validate

from src.classes.DeliveryStatus import DeliveryStatus
from src.schemas.OrderBaseSchema import OrderBaseSchema


class DeliveryBaseSchema(Schema):

    delivery_id = fields.UUID()
    offer_id = fields.UUID()
    name = fields.Str()
    status = fields.Str(validate=validate.OneOf(
        [str(status) for status in DeliveryStatus]))
    access_code = fields.Str(validate=validate.Length(equal=6))
    report_sent = fields.Bool()
    delivery_date = fields.DateTime()
    start_time = fields.DateTime()
    end_time = fields.DateTime()
    supplier_id = fields.Int()

    orders = fields.Nested(OrderBaseSchema, many=True)

    @staticmethod
    def from_offer(offer: dict):
        """Create a delivery based on an offer"""

        schema = DeliveryBaseSchema(unknown='EXCLUDE')

        return schema.load({
            **offer,
            'supplier_id': offer.get('supplier').get('supplier_id'),
            'orders': [
                OrderBaseSchema.from_offer_order(order)
                for order in offer.get('orders', [])
            ]
        })
