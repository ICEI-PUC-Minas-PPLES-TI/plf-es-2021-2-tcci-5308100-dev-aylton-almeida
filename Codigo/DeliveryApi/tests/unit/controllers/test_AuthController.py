import json
from http import HTTPStatus
from unittest.mock import MagicMock, patch
from uuid import UUID, uuid4

from src.apis.gateway import gateway
from src.classes.Role import Role
from src.services.AuthService import AuthService
from tests import base_path
from tests.utils.models.BaseTest import BaseTest


class AuthControllerTests(BaseTest):

    @patch.object(gateway.service['auth'], 'authorize_request')
    @patch.object(AuthService, 'authorize')
    def test_Authorize_when_NotFound(
        self,
        mock_authorize: MagicMock,
        mock_authorize_request: MagicMock,
    ):
        """Test authorize user when not found
        """

        # when
        token = 'Bearer valid token'
        roles = [Role.deliverer]
        uid = 'deliverer id'
        authorize_respose = {}

        # mock
        mock_authorize_request.return_value = {
            'roles': roles,
            'uid': uid,
        }
        mock_authorize.return_value = authorize_respose

        # then
        response = self.app.get(
            f'{base_path}/auth',
            follow_redirects=True,
            headers={
                'Authorization': token,
                'Content-Type': 'application/json'
            },
        )

        # assert
        self.assertEqual(response.status_code, HTTPStatus.NOT_FOUND)
        mock_authorize_request.assert_called_once_with(token, Role.any)
        mock_authorize.assert_called_once_with(uid, roles)

    @patch.object(gateway.service['auth'], 'authorize_request')
    @patch.object(AuthService, 'authorize')
    def test_Authorize_when_UserFound(
        self,
        mock_authorize: MagicMock,
        mock_authorize_request: MagicMock,
    ):
        """Test authorize when user found
        """

        # when
        token = 'Bearer valid token'
        roles = [Role.deliverer]
        uid = 123
        authorize_respose = {
            'deliverer': {'deliverer_id': uid}
        }

        # mock
        mock_authorize_request.return_value = {
            'roles': roles,
            'uid': uid,
        }
        mock_authorize.return_value = authorize_respose

        # then
        response = self.app.get(
            f'{base_path}/auth',
            follow_redirects=True,
            headers={
                'Authorization': token,
                'Content-Type': 'application/json'
            },
        )

        # assert
        self.assertEqual(response.status_code, HTTPStatus.OK)
        self.assertEqual(response.json, {'deliverer': {'delivererId': uid}})
        mock_authorize_request.assert_called_once_with(token, Role.any)
        mock_authorize.assert_called_once_with(uid, roles)

    @patch.object(AuthService, 'authenticate_deliverer')
    def test_AuthenticateDeliverer_when_Default(
        self,
        mock_authenticate_deliverer: MagicMock,
    ):
        """Test authenticate user when default
        """

        # when
        token = 'Bearer valid token'
        uid = 123
        authenticate_response = {'deliverer_id': uid}
        payload = {
            'phone': 'valid phone',
            'deliveryId': str(uuid4())
        }

        # mock
        mock_authenticate_deliverer.return_value = token, authenticate_response

        # then
        response = self.app.post(
            f'{base_path}/auth/deliverers',
            follow_redirects=True,
            data=json.dumps(payload),
            headers={
                'Authorization': token,
                'Content-Type': 'application/json'
            },
        )

        # assert
        self.assertEqual(response.status_code, HTTPStatus.OK)
        self.assertEqual(response.json, {
            'token': token,
            'deliverer': {'delivererId': uid}
        })
        mock_authenticate_deliverer.assert_called_once_with(**{
            'phone': 'valid phone',
            'delivery_id': UUID(payload['deliveryId'])
        })
