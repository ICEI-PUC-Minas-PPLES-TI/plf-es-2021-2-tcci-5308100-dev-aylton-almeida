from http import HTTPStatus
from uuid import UUID

from flask_apispec import MethodResource, doc, use_kwargs
from flask_restful import Resource
from werkzeug.exceptions import NotFound

from src.classes.Role import Role
from src.controllers.schemas.AuthControllerSchemas import (
    AuthDelivererResponseSchema, AuthDelivererSchema,
    AuthorizeDelivererResponseSchema)
from src.guards.AuthGuard import auth_guard
from src.guards.ExceptionGuard import exception_guard
from src.guards.MarshalResponse import marshal_response
from src.schemas.deliverer.DelivererBaseSchema import DelivererBaseSchema
from src.services.AuthService import AuthService


class DelivererAuthResource(MethodResource, Resource):

    @doc(tags=['Auth'], description='Authorize a deliverer')
    @exception_guard
    @auth_guard(Role.deliverer, needs_user_id=True, needs_role=True)
    @marshal_response(AuthorizeDelivererResponseSchema)
    def get(self, auth_user_id: UUID, roles: list[Role]):
        """Authorizes a deliverer"""

        # TODO: test

        deliverer = AuthService.authorize_deliverer(deliverer_id=auth_user_id)

        if not deliverer:
            raise NotFound('Deliverer not found')

        deliverer.roles = roles

        return deliverer

    @doc(description="Authenticates a new deliverer", tags=['Offer'])
    @exception_guard
    @use_kwargs(AuthDelivererSchema, location='json')
    @marshal_response(AuthDelivererResponseSchema)
    def post(self, **deliverer_data):
        """Authenticates a new deliverer"""

        # TODO: test

        token, deliverer = AuthService.authenticate_deliverer(**deliverer_data)

        return {'token': token, 'deliverer': deliverer}, HTTPStatus.OK
