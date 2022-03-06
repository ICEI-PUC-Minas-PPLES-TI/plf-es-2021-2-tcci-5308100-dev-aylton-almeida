from http import HTTPStatus
from uuid import UUID

from flask_apispec import MethodResource, doc, use_kwargs
from flask_restful import Resource
from werkzeug.exceptions import NotFound

from src.classes.Role import Role
from src.controllers.schemas.AuthControllerSchemas import (
    AuthDelivererResponseSchema, AuthDelivererSchema, AuthorizeResponseSchema)
from src.guards.AuthGuard import auth_guard
from src.guards.ExceptionGuard import exception_guard
from src.guards.MarshalResponse import marshal_response
from src.services.AuthService import AuthService


class AuthorizeResource(MethodResource, Resource):

    @doc(tags=['Auth'], description='Authorizes an user')
    @exception_guard
    @auth_guard(needs_user_id=True, needs_role=True)
    @marshal_response(AuthorizeResponseSchema)
    def get(self, auth_user_id: UUID, roles: list[Role]):
        """Authorizes an user"""

        response = AuthService.authorize(auth_user_id, roles)

        if not any(response.values()):
            raise NotFound('User not found')

        return response, HTTPStatus.OK


class DelivererAuthResource(MethodResource, Resource):

    @doc(description="Authenticates a new deliverer", tags=['Offer'])
    @exception_guard
    @use_kwargs(AuthDelivererSchema, location='json')
    @marshal_response(AuthDelivererResponseSchema)
    def post(self, **deliverer_data):
        """Authenticates a new deliverer"""

        token, deliverer = AuthService.authenticate_deliverer(**deliverer_data)

        return {'token': token, 'deliverer': deliverer}, HTTPStatus.OK
