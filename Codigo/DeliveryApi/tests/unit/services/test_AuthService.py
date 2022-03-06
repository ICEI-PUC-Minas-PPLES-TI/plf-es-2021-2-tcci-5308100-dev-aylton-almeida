from unittest.mock import MagicMock, patch
from uuid import uuid4

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
