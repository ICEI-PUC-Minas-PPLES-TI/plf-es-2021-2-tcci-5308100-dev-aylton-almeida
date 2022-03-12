import json
from http import HTTPStatus
from unittest.mock import MagicMock, patch
from uuid import UUID, uuid4

from src.apis.gateway import gateway
from src.classes.Role import Role
from src.models.SupplierModel import SupplierModel
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
            'deliverer': {'deliverer_id': uid},
            'supplier': {'supplier_id': uid}
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
        self.assertEqual(response.json, {
            'deliverer': {'delivererId': uid},
            'supplier': {'supplierId': uid},
        })
        mock_authorize_request.assert_called_once_with(token, Role.any)
        mock_authorize.assert_called_once_with(uid, roles)

    @patch.object(AuthService, 'authenticate_deliverer')
    def test_AuthenticateDeliverer_when_Default(
        self,
        mock_authenticate_deliverer: MagicMock,
    ):
        """Test authenticate deliverer user when default
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

    @patch.object(AuthService, 'authenticate_supplier')
    def test_AuthenticateSupplier_when_Default(
        self,
        mock_authenticate_supplier: MagicMock,
    ):
        """Test authenticate supplier user when default
        """

        # when
        supplier_id = 123
        authenticate_response = SupplierModel({'supplier_id': supplier_id})
        payload = {
            'phone': 'valid phone',
        }

        # mock
        mock_authenticate_supplier.return_value = authenticate_response

        # then
        response = self.app.post(
            f'{base_path}/auth/suppliers',
            follow_redirects=True,
            data=json.dumps(payload),
            headers={
                'Content-Type': 'application/json'
            },
        )

        # assert
        self.assertEqual(response.status_code, HTTPStatus.OK)
        self.assertEqual(response.json, {
            'supplierId': supplier_id
        })
        mock_authenticate_supplier.assert_called_once_with(payload['phone'])

    @patch.object(AuthService, 'verify_supplier_code')
    def test_VerifySupplierAuthCode_when_Default(
        self,
        mock_verify_supplier_code: MagicMock,
    ):
        """Test verify supplier auth code when default
        """

        # when
        code = '12332'
        supplier_id = 123
        authenticate_response = {'supplier_id': supplier_id}
        token = 'valid jwt token'
        payload = {
            'supplierId': supplier_id,
            'code': code
        }

        # mock
        mock_verify_supplier_code.return_value = token, authenticate_response

        # then
        response = self.app.post(
            f'{base_path}/auth/suppliers/verify-code',
            follow_redirects=True,
            data=json.dumps(payload),
            headers={
                'Content-Type': 'application/json'
            },
        )

        # assert
        self.assertEqual(response.status_code, HTTPStatus.OK)
        self.assertDictEqual(response.json, {
            'supplier': {'supplierId': supplier_id},
            'token': token
        })
        mock_verify_supplier_code.assert_called_once_with(supplier_id, code)
