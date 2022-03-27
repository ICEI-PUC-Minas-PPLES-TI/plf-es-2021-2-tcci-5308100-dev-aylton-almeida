from marshmallow import Schema, fields

from src.schemas.delivery_route.DeliveryRouteAddressBaseSchema import \
    DeliveryRouteAddressBaseSchema


class DeliveryRouteBaseSchema(Schema):
    delivery_route_id = fields.Int()
    estimate_time = fields.Time()
    delivery_id = fields.UUID()
    addresses = fields.List(fields.Nested(DeliveryRouteAddressBaseSchema))
