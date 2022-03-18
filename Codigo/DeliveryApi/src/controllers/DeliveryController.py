from http import HTTPStatus
from uuid import UUID

from flask_apispec import MethodResource, doc
from flask_restful import Resource
from werkzeug.exceptions import Forbidden, NotFound

from src.classes.Role import Role
from src.controllers.schemas.DeliveryControllerSchemas import (
    GetDeliveryResponseSchema, GetSupplierDeliveriesResponseSchema,
    VerifyDeliveryResponseSchema)
from src.guards.AuthGuard import auth_guard
from src.guards.ExceptionGuard import exception_guard
from src.guards.MarshalResponse import marshal_response
from src.services.DeliveryService import DeliveryService


class VerifyDeliveryResource(MethodResource, Resource):

    @doc(description="Verifies if delivery with given code exists", tags=['Delivery'])
    @exception_guard
    @marshal_response(VerifyDeliveryResponseSchema)
    def get(self, code: str):
        """Verifies if delivery with given code exists"""

        delivery = DeliveryService.get_available_one_by_code(code)

        if not delivery:
            raise NotFound('Delivery not found with given code')

        return {'delivery_id': delivery.delivery_id}, HTTPStatus.OK


class DeliveryListResource(MethodResource, Resource):

    @doc(description="Get Supplier deliveries", tags=['Delivery'])
    @exception_guard
    @auth_guard(Role.supplier, needs_user_id=True)
    @marshal_response(GetSupplierDeliveriesResponseSchema)
    def get(self, auth_user_id: str):
        """Get Supplier deliveries"""

        deliveries = DeliveryService.get_all_by_supplier(auth_user_id)

        return {'deliveries': deliveries}, HTTPStatus.OK


class DeliveryResource(MethodResource, Resource):

    @doc(description="Gets one delivery", tags=['Delivery'])
    @exception_guard
    @auth_guard(Role.supplier, needs_user_id=True)
    @marshal_response(GetDeliveryResponseSchema)
    def get(self, delivery_id: str, auth_user_id: str):
        """Gets one delivery"""

        delivery = DeliveryService.get_one_by_id(UUID(delivery_id))

        if delivery.supplier_id != auth_user_id:
            raise Forbidden('You do not have access to this resource')

        return {'delivery': delivery}, HTTPStatus.OK
