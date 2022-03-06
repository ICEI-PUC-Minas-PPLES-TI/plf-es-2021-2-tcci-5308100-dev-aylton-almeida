from http import HTTPStatus

from flask_apispec import MethodResource, doc
from flask_restful import Resource
from werkzeug.exceptions import NotFound

from src.controllers.schemas.DeliveryControllerSchemas import \
    VerifyDeliveryResponseSchema
from src.guards.ExceptionGuard import exception_guard
from src.guards.MarshalResponse import marshal_response
from src.services.DeliveryService import DeliveryService


class VerifyDeliveryResource(MethodResource, Resource):

    @doc(description="Verifies if delivery with given code exists", tags=['Offer'])
    @exception_guard
    @marshal_response(VerifyDeliveryResponseSchema)
    def get(self, code: str):
        """Verifies if delivery with given code exists"""

        # TODO: test

        delivery = DeliveryService.get_one_by_code(code)

        if not delivery:
            raise NotFound('Delivery not found with given code')

        return {'delivery_id': delivery.delivery_id}, HTTPStatus.ACCEPTED
