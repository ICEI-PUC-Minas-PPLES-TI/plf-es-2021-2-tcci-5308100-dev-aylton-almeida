from http import HTTPStatus

from flask_apispec import MethodResource, doc
from flask_restful import Resource
from werkzeug.exceptions import NotFound

from src.classes.Role import Role
from src.controllers.schemas.DeliveryControllerSchemas import \
    VerifyDeliveryResponseSchema
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

        delivery = DeliveryService.get_one_by_code(code)

        if not delivery:
            raise NotFound('Delivery not found with given code')

        return {'delivery_id': delivery.delivery_id}, HTTPStatus.OK


class DeliveryListResource(MethodResource, Resource):

    @doc(description="Returns all deliveries based on signed in user", tags=['Delivery'])
    @exception_guard
    @auth_guard(Role.supplier, needs_user_id=True)
    @marshal_response(VerifyDeliveryResponseSchema, many=True)
    def get(self):
        """Returns all deliveries based on signed in user"""

        deliveries = DeliveryService.get_all()

        return deliveries, HTTPStatus.OK
