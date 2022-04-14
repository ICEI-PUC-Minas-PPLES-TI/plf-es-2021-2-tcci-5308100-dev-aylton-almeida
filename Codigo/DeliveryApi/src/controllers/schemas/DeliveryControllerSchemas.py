from marshmallow import fields, validate

from src.classes.ProblemType import ProblemType
from src.schemas.CamelCaseSchema import CamelCaseSchema
from src.schemas.delivery_route.DeliveryRouteBaseSchema import \
    DeliveryRouteBaseSchema
from src.schemas.DeliveryBaseSchema import DeliveryBaseSchema


class VerifyDeliveryResponseSchema(CamelCaseSchema):
    delivery_id = fields.UUID()


class GetSupplierDeliveriesResponseSchema(CamelCaseSchema):
    deliveries = fields.List(fields.Nested(
        DeliveryBaseSchema,
        only=[
            'delivery_id',
            'status',
            'delivery_date',
            'name'
        ]
    ))


class GetDeliveryResponseSchema(CamelCaseSchema):
    delivery = fields.Nested(DeliveryBaseSchema)
    route = fields.Nested(DeliveryRouteBaseSchema)


class CreateOrderProblemSchema(CamelCaseSchema):
    type = fields.Str(
        required=True,
        validate=validate.OneOf([
            problem.name for problem in ProblemType
        ])
    )
    description = fields.Str()


class DeliverOrderFromDeliverySchema(CamelCaseSchema):
    delivery_id = fields.UUID()
    order_id = fields.UUID()
    problem = fields.Nested(CreateOrderProblemSchema)
