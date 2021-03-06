from http import HTTPStatus

from flask_apispec import MethodResource, doc
from flask_restful import Resource

from src.controllers.schemas.TestsControllerSchemas import \
    SetupDeliveryResponseSchema
from src.guards.ExceptionGuard import exception_guard
from src.guards.MarshalResponse import marshal_response
from src.services.TestsService import TestsService


class IntegrationTestResource(MethodResource, Resource):

    @doc(description="Sets up a delivery for integration tests", tags=['Delivery'])
    @exception_guard
    @marshal_response(SetupDeliveryResponseSchema)
    def post(self):
        """Sets up a delivery for integration tests"""

        delivery = TestsService.setup_test_delivery()

        return delivery, HTTPStatus.OK
