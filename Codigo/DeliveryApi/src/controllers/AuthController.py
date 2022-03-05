from http import HTTPStatus

from flask_apispec import MethodResource, doc, use_kwargs
from flask_restful import Resource

from src.controllers.schemas.AuthControllerSchemas import (
    AuthDelivererResponseSchema, AuthDelivererSchema)
from src.guards.ExceptionGuard import exception_guard
from src.guards.MarshalResponse import marshal_response
from src.services.AuthService import AuthService


class DelivererAuthResource(MethodResource, Resource):

    @doc(description="Authenticates a new deliverer", tags=['Offer'])
    @exception_guard
    @use_kwargs(AuthDelivererSchema, location='json')
    @marshal_response(AuthDelivererResponseSchema)
    def post(self, **deliverer_data):
        """Authenticates a new deliverer"""

        # TODO: test

        token, deliverer = AuthService.auth_deliverer(**deliverer_data)

        return {'token': token, 'deliverer': deliverer}, HTTPStatus.OK
