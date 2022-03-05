from marshmallow import fields

from src.schemas.CamelCaseSchema import CamelCaseSchema
from src.schemas.deliverer.DelivererBaseSchema import DelivererBaseSchema


class AuthDelivererSchema(CamelCaseSchema):
    phone = fields.Str(required=True)
    delivery_id = fields.UUID(required=True)


class AuthDelivererResponseSchema(CamelCaseSchema):
    token = fields.Str(required=True)
    deliverer = fields.Nested(DelivererBaseSchema, required=True)
