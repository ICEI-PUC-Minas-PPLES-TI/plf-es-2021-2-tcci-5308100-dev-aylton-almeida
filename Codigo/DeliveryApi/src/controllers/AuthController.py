from http import HTTPStatus

from flask_apispec import MethodResource, doc, use_kwargs
from flask_restful import Resource

# from src.apis.AuthApi import Role
from src.controllers.schemas.AuthControllerSchemas import AuthDelivererSchema
# from src.guards.AuthGuard import auth_guard
from src.guards.ExceptionGuard import exception_guard
from src.guards.MarshalResponse import marshal_response
from src.schemas.deliverer.DelivererBaseSchema import DelivererBaseSchema
from src.services.DelivererService import DelivererService


class DelivererResource(MethodResource, Resource):

    @doc(description="Authenticates a new deliverer", tags=['Offer'])
    @exception_guard
    @use_kwargs(AuthDelivererSchema, location='json')
    @marshal_response(DelivererBaseSchema)
    def post(self, **deliverer_data):
        """Authenticates a new deliverer"""

        # TODO: test

        deliverer = DelivererService.create(deliverer_data)

        return deliverer, HTTPStatus.OK
