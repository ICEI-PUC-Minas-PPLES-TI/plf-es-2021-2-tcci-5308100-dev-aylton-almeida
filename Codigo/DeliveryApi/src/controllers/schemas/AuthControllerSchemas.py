from marshmallow import fields, validate

from src.classes.Role import Role
from src.schemas.CamelCaseSchema import CamelCaseSchema
from src.schemas.deliverer.DelivererBaseSchema import DelivererBaseSchema


class AuthDelivererSchema(CamelCaseSchema):
    phone = fields.Str(required=True)
    delivery_id = fields.UUID(required=True)


class AuthDelivererResponseSchema(CamelCaseSchema):
    token = fields.Str(required=True)
    deliverer = fields.Nested(DelivererBaseSchema, required=True)


class AuthorizeDelivererResponseSchema(CamelCaseSchema, DelivererBaseSchema):
    roles = fields.List(
        fields.Str(validate=validate.OneOf([
            str(role) for role in Role
        ])),
        required=True
    )
