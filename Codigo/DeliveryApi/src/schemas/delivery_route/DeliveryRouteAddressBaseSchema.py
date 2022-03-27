from marshmallow import Schema, fields

from src.schemas.AddressBaseSchema import AddressBaseSchema


class DeliveryRouteAddressBaseSchema(Schema):

    delivery_route_id = fields.Int()
    address_id = fields.Int()
    position = fields.Int()
    address = fields.Nested(AddressBaseSchema)
