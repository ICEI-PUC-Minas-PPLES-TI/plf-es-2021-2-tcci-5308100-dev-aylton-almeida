from unittest.mock import MagicMock, patch

from werkzeug.exceptions import Forbidden, Unauthorized

from src.apis.AuthApi import AuthApi
from src.classes.Role import Role
from tests.utils.models.BaseTest import BaseTest


class AuthApiTests(BaseTest):

    auth_api: AuthApi

    def setUp(self):

        self.auth_api = AuthApi()

        super().setUp()

    @patch('src.apis.AuthApi.decode_jwt_token')
    @patch.object(Role, 'get_authorized_roles')
    def test_AuthorizeRequest_when_NoToken(
        self,
        mock_get_authorized_roles: MagicMock,
        mock_decode_jwt_token: MagicMock
    ):
        """Test authorize request when no token is provided
        """

        # when
        token = None
        role = Role.deliverer

        # then
        with self.assertRaises(Forbidden) as err:
            self.auth_api.authorize_request(token, role)

        # assert
        self.assertIn('No token provided', str(err.exception))
        mock_decode_jwt_token.assert_not_called()
        mock_get_authorized_roles.assert_not_called()

    @patch('src.apis.AuthApi.decode_jwt_token')
    def test_AuthorizeRequest_when_InvalidToken(
        self,
        mock_decode_jwt_token: MagicMock
    ):
        """Test authorize request when role is not allowed
        """

        # when
        token = 'Bearer invalid token'
        role = Role.deliverer

        # mock
        mock_decode_jwt_token.side_effect = Exception('Invalid token')

        # then
        with self.assertRaises(Unauthorized) as err:
            self.auth_api.authorize_request(token, role)

        # assert
        self.assertIn('Invalid token', str(err.exception))
        mock_decode_jwt_token.assert_called_once_with(
            token.replace('Bearer ', '')
        )

    @patch('src.apis.AuthApi.decode_jwt_token')
    def test_AuthorizeRequest_when_RoleNotAllowed(
        self,
        mock_decode_jwt_token: MagicMock
    ):
        """Test authorize request when role is not allowed
        """

        # when
        token = 'Bearer supplier token'
        role = Role.deliverer

        # mock
        mock_decode_jwt_token.return_value = ('1', Role.supplier)

        # then
        with self.assertRaises(Unauthorized) as err:
            self.auth_api.authorize_request(token, role)

        # assert
        self.assertIn(
            'User does not have access to this resource',
            str(err.exception)
        )
        mock_decode_jwt_token.assert_called_once_with(
            token.replace('Bearer ', '')
        )

    @patch('src.apis.AuthApi.decode_jwt_token')
    def test_AuthorizeRequest_when_ValidTokenAndRoleAllowed(
        self,
        mock_decode_jwt_token: MagicMock
    ):
        """Test authorize request when token is valid and role is allowed
        """

        # when
        token = 'Bearer deliverer token'
        role = Role.deliverer

        # mock
        mock_decode_jwt_token.return_value = ('1', Role.deliverer)

        # then
        response = self.auth_api.authorize_request(token, role)

        # assert
        self.assertEqual(response, {
            'roles': [Role.deliverer],
            'user_id': '1'
        })
        mock_decode_jwt_token.assert_called_once_with(
            token.replace('Bearer ', '')
        )
