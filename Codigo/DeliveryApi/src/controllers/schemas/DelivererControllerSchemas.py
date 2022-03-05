from marshmallow import fields

from src.schemas.CamelCaseSchema import CamelCaseSchema


class DelivererCreateSchema(CamelCaseSchema):
    phone = fields.Str(required=True)
    delivery_id = fields.UUID(required=True)
