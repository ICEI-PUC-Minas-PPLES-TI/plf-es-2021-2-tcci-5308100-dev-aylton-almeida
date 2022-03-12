from marshmallow import fields, validate

from src.schemas.CamelCaseSchema import CamelCaseSchema
from src.schemas.deliverer.DelivererBaseSchema import DelivererBaseSchema
from src.schemas.SupplierBaseSchema import SupplierBaseSchema


class AuthDelivererSchema(CamelCaseSchema):
    phone = fields.Str(required=True)
    delivery_id = fields.UUID(required=True)


class AuthDelivererResponseSchema(CamelCaseSchema):
    token = fields.Str(required=True)
    deliverer = fields.Nested(DelivererBaseSchema, required=True)


class AuthorizeResponseSchema(CamelCaseSchema):
    deliverer = fields.Nested(DelivererBaseSchema)
    supplier = fields.Nested(SupplierBaseSchema)


class AuthSupplierSchema(CamelCaseSchema):
    phone = fields.Str(required=True)


class AuthSupplierResponseSchema(CamelCaseSchema):
    supplier_id = fields.Int()


class VerifyAuthCode(CamelCaseSchema):
    supplier_id = fields.Int(required=True)
    code = fields.Str(required=True, validate=validate.Length(equal=5))


class VerifyAuthCodeResponse(CamelCaseSchema):
    token = fields.Str(required=True)
    supplier = fields.Nested(SupplierBaseSchema)
