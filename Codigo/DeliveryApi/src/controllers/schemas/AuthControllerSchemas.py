from marshmallow import fields

from src.schemas.CamelCaseSchema import CamelCaseSchema


class AuthDelivererSchema(CamelCaseSchema):
    phone = fields.Str(required=True)
    delivery_id = fields.UUID(required=True)
