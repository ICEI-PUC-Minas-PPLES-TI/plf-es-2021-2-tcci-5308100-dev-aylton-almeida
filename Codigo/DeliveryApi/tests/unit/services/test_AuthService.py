from unittest.mock import MagicMock, patch
from uuid import uuid4

from werkzeug.exceptions import NotFound, Unauthorized

from src.apis.gateway import gateway
from src.classes.Role import Role
from src.models.BaseModel import BaseModel
from src.models.DelivererModel import DelivererModel
from src.models.SupplierModel import SupplierModel
from src.services.AuthService import AuthService
from src.services.DelivererService import DelivererService
from src.services.SupplierService import SupplierService
from tests.utils.models.BaseTest import BaseTest


class AuthServiceTests(BaseTest):

    @patch.object(DelivererService, 'get_one_by_id')
    @patch.object(SupplierService, 'get_one_by_id')
    def test_Authorize_when_RoleIncludesDeliverer(
        self,
        mock_get_supplier: MagicMock,
        mock_get_deliverer: MagicMock,
    ):
        """Test authorize when role includes deliverer
        """

        # when
        roles = [Role.deliverer]
        uid = 123
        expected_deliverer = DelivererModel({'deliverer_id': uid})
        expected_supplier = None

        # mock
        mock_get_deliverer.return_value = expected_deliverer
        mock_get_supplier.return_value = expected_supplier

        # then
        response = AuthService.authorize(uid, roles)

        # assert
        self.assertDictEqual(response, {'deliverer': expected_deliverer})
        mock_get_deliverer.assert_called_once_with(uid)
        mock_get_supplier.assert_not_called()

    @patch.object(DelivererService, 'get_one_by_id')
    @patch.object(SupplierService, 'get_one_by_id')
    def test_Authorize_when_RoleIncludesSupplier(
        self,
        mock_get_supplier: MagicMock,
        mock_get_deliverer: MagicMock,
    ):
        """Test authorize when role includes supplier
        """

        # when
        roles = [Role.supplier]
        uid = 123
        expected_deliverer = None
        expected_supplier = SupplierModel({'supplier_id': uid})

        # mock
        mock_get_deliverer.return_value = expected_deliverer
        mock_get_supplier.return_value = expected_supplier

        # then
        response = AuthService.authorize(uid, roles)

        # assert
        self.assertDictEqual(response, {'supplier': expected_supplier})
        mock_get_supplier.assert_called_once_with(uid)
        mock_get_deliverer.assert_not_called()

    @patch.object(DelivererService, 'get_one_by_id')
    @patch.object(SupplierService, 'get_one_by_id')
    def test_Authorize_when_RoleIncludesSupplierAndDeliverer(
        self,
        mock_get_supplier: MagicMock,
        mock_get_deliverer: MagicMock,
    ):
        """Test authorize when role includes supplier and deliverer
        """

        # when
        roles = [Role.supplier, Role.deliverer]
        uid = 123
        expected_deliverer = DelivererModel({'deliverer_id': uid})
        expected_supplier = SupplierModel({'supplier_id': uid})

        # mock
        mock_get_deliverer.return_value = expected_deliverer
        mock_get_supplier.return_value = expected_supplier

        # then
        response = AuthService.authorize(uid, roles)

        # assert
        self.assertDictEqual(response, {
            'deliverer': expected_deliverer,
            'supplier': expected_supplier
        })
        mock_get_supplier.assert_called_once_with(uid)
        mock_get_deliverer.assert_called_once_with(uid)

    @patch.object(DelivererService, 'create')
    @patch.object(BaseModel, 'commit')
    @patch('src.services.AuthService.create_jwt_token')
    def test_AuthenticateDeliverer_when_Default(
        self,
        mock_create_jwt_token: MagicMock,
        mock_commit: MagicMock,
        mock_create: MagicMock,
    ):
        """Test authenticate deliverer when default behavior"""

        # when
        phone = 'valid phone'
        delivery_id = uuid4()
        deliverer_id = 123
        token = 'valid token'
        expected_deliverer = DelivererModel({
            'deliverer_id': deliverer_id,
            'phone': phone,
            'delivery_id': delivery_id,
        })

        # mock
        mock_create.return_value = expected_deliverer
        mock_create_jwt_token.return_value = token

        # then
        response = AuthService.authenticate_deliverer(phone, delivery_id)

        # assert
        self.assertTupleEqual(response, (token, expected_deliverer))
        mock_create.assert_called_once_with(
            {'phone': phone, 'delivery_id': delivery_id},
            False
        )
        mock_create_jwt_token.assert_called_once_with(
            deliverer_id, Role.deliverer)
        mock_commit.assert_called_once()

    @patch.object(gateway.service['auth'], 'authenticate_supplier')
    @patch.object(SupplierService, 'get_one_by_phone')
    def test_AuthenticateSupplier_when_Found(
        self,
        mock_get_one_by_phone: MagicMock,
        mock_authenticate_supplier: MagicMock,
    ):
        """Test authenticate supplier when supplier was found"""

        # when
        phone = 'valid phone'
        supplier_id = 123
        expected_supplier = SupplierModel({
            'supplier_id': supplier_id,
        })

        # mock
        mock_get_one_by_phone.return_value = expected_supplier

        # then
        response = AuthService.authenticate_supplier(phone)

        # assert
        self.assertEqual(response, expected_supplier)
        mock_get_one_by_phone.assert_called_once_with(phone)
        mock_authenticate_supplier.assert_called_once_with(supplier_id)

    @patch.object(gateway.service['auth'], 'authenticate_supplier')
    @patch.object(SupplierService, 'get_one_by_phone')
    def test_AuthenticateSupplier_when_NotFound(
        self,
        mock_get_one_by_phone: MagicMock,
        mock_authenticate_supplier: MagicMock,
    ):
        """Test authenticate supplier when supplier was not found"""

        # when
        phone = 'valid phone'

        # mock
        mock_get_one_by_phone.return_value = None

        # then
        with self.assertRaises(NotFound) as err:
            AuthService.authenticate_supplier(phone)

        # assert
        self.assertIn(
            f'Supplier not found with phone {phone}', str(err.exception))
        mock_get_one_by_phone.assert_called_once_with(phone)
        mock_authenticate_supplier.assert_not_called()

    @patch.object(gateway.service['auth'], 'verify_auth_code')
    @patch.object(SupplierService, 'get_one_by_id')
    @patch('src.services.AuthService.create_jwt_token')
    def test_VerifySupplierCode_when_CodeIsValid(
        self,
        mock_create_jwt_token: MagicMock,
        mock_get_one_by_id: MagicMock,
        mock_verify_auth_code: MagicMock
    ):
        """Test verify supplier code when code is valid"""

        # when
        supplier_id = 123
        code = '12332'
        token = 'valid token'
        expected_supplier = SupplierModel({
            'supplier_id': supplier_id,
        })

        # mock
        mock_get_one_by_id.return_value = expected_supplier
        mock_create_jwt_token.return_value = token
        mock_verify_auth_code.return_value = True

        # then
        response = AuthService.verify_supplier_code(supplier_id, code)

        # assert
        self.assertTupleEqual(response, (token, expected_supplier))
        mock_get_one_by_id.assert_called_once_with(supplier_id)
        mock_create_jwt_token.assert_called_once_with(
            supplier_id, Role.supplier)
        mock_verify_auth_code.assert_called_once_with(code)

    @patch.object(gateway.service['auth'], 'verify_auth_code')
    @patch.object(SupplierService, 'get_one_by_id')
    @patch('src.services.AuthService.create_jwt_token')
    def test_VerifySupplierCode_when_CodeIsInvalid(
        self,
        mock_create_jwt_token: MagicMock,
        mock_get_one_by_id: MagicMock,
        mock_verify_auth_code: MagicMock
    ):
        """Test verify supplier code when code is invalid"""

        # when
        supplier_id = 123
        code = '123322'
        token = 'valid token'
        expected_supplier = SupplierModel({
            'supplier_id': supplier_id,
        })

        # mock
        mock_get_one_by_id.return_value = expected_supplier
        mock_create_jwt_token.return_value = token
        mock_verify_auth_code.return_value = False

        # then
        with self.assertRaises(Unauthorized) as err:
            AuthService.verify_supplier_code(supplier_id, code)

        # assert
        self.assertIn('Invalid code received', str(err.exception))
        mock_get_one_by_id.assert_called_once_with(supplier_id)
        mock_create_jwt_token.assert_not_called()
        mock_verify_auth_code.assert_called_once_with(code)

    @patch.object(SupplierService, 'get_one_by_id')
    @patch('src.services.AuthService.create_jwt_token')
    def test_VerifySupplierCode_when_SupplierNotFound(
        self,
        mock_create_jwt_token: MagicMock,
        mock_get_one_by_id: MagicMock,
    ):
        """Test verify supplier code when supplier not found"""

        # when
        supplier_id = 123
        code = '123322'
        token = 'valid token'
        expected_supplier = None

        # mock
        mock_get_one_by_id.return_value = expected_supplier
        mock_create_jwt_token.return_value = token

        # then
        with self.assertRaises(NotFound) as err:
            AuthService.verify_supplier_code(supplier_id, code)

        # assert
        self.assertIn(
            f'Supplier not found with id {supplier_id}', str(err.exception))
        mock_get_one_by_id.assert_called_once_with(supplier_id)
        mock_create_jwt_token.assert_not_called()
