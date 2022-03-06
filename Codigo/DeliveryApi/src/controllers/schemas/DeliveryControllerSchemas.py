

from marshmallow import fields

from src.schemas.CamelCaseSchema import CamelCaseSchema


class VerifyDeliveryResponseSchema(CamelCaseSchema):
    delivery_id = fields.UUID()
