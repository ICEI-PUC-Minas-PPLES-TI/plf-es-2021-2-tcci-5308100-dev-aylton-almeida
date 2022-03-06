from datetime import datetime, timezone
from unittest.mock import MagicMock, patch

import jwt

from src.classes.Role import Role
from src.utils.JwtUtils import create_jwt_token, decode_jwt_token
from tests.utils.models.BaseTest import BaseTest


class JwtUtilsTests(BaseTest):

    @patch('src.utils.JwtUtils.datetime')
    @patch('src.utils.JwtUtils.os.getenv')
    def test_CreateJwtToken_when_Default(self, mock_getenv: MagicMock, mock_datetime: MagicMock):
        """Test create JWT token when default.
        """

        # when
        key = 'aylton'
        role = Role.deliverer
        now = datetime.now(tz=timezone.utc)

        # mock
        mock_datetime.now.return_value = now
        mock_getenv.return_value = 'secret'

        # then
        token = create_jwt_token(key, role)
        decoded = jwt.decode(token, 'secret', algorithms='HS256')

        # assert
        self.assertIsNotNone(token)
        self.assertDictEqual(decoded, {
            'key': key,
            'iat': int(now.timestamp()),
            'role': str(role)
        })

    @patch('src.utils.JwtUtils.datetime')
    @patch('src.utils.JwtUtils.os.getenv')
    def test_DecodeJwtToken_when_Default(self, mock_getenv: MagicMock, mock_datetime: MagicMock):
        """Test decode JWT token when default.
        """

        # when
        key = 'aylton'
        role = Role.deliverer
        now = datetime.now(tz=timezone.utc)

        # mock
        mock_datetime.now.return_value = now
        mock_getenv.return_value = 'secret'
        token = create_jwt_token(key, role)

        # then
        key, role = decode_jwt_token(token)

        # assert
        self.assertEqual(key, 'aylton')
        self.assertEqual(role, Role.deliverer)
