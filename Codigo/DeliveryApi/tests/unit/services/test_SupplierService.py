from unittest.mock import MagicMock, patch

from src.models.SupplierModel import SupplierModel
from src.services.SupplierService import SupplierService
from tests.utils.models.BaseTest import BaseTest


class SupplierServiceTests(BaseTest):

    @patch.object(SupplierModel, 'save')
    @patch.object(SupplierModel, 'get_one_filtered')
    def test_CreateIfNotCreated_when_AlreadyCreated(
        self,
        mock_get_one_filtered: MagicMock,
        mock_save: MagicMock
    ):
        """Test create_if_not_created when supplier was already created"""

        # when
        supplier = {
            'supplier_id': 123
        }

        # mock
        mock_get_one_filtered.return_value = SupplierModel({})

        # then
        response = SupplierService.create_if_not_created(supplier)

        # assert
        self.assertIsNone(response)
        self.assertTrue(mock_get_one_filtered.call_args_list[0][0][0][0].compare(
            SupplierModel.supplier_id == supplier.get('supplier_id'),
        ))
        mock_save.assert_not_called()

    @patch.object(SupplierModel, 'save')
    @patch.object(SupplierModel, 'get_one_filtered')
    def test_CreateIfNotCreated_when_NotCreated(
        self,
        mock_get_one_filtered: MagicMock,
        mock_save: MagicMock
    ):
        """Test create_if_not_created when supplier was not already created"""

        # when
        supplier = {
            'supplier_id': 123
        }

        # mock
        mock_get_one_filtered.return_value = None

        # then
        response = SupplierService.create_if_not_created(supplier)

        # assert
        self.assertEqual(response.supplier_id, supplier.get('supplier_id'))
        self.assertTrue(mock_get_one_filtered.call_args_list[0][0][0][0].compare(
            SupplierModel.supplier_id == supplier.get('supplier_id'),
        ))
        mock_save.assert_called_once_with()

    @patch.object(SupplierModel, 'get_one_filtered')
    def test_GetOneById_when_Default(self, mock_get_one_filtered: MagicMock):
        """Test get_one_by_id when default behavior"""

        # when
        supplier_id = 123
        found_supplier = SupplierModel({})

        # mock
        mock_get_one_filtered.return_value = found_supplier

        # then
        response = SupplierService.get_one_by_id(supplier_id)

        # assert
        self.assertEqual(response, found_supplier)
        self.assertTrue(
            mock_get_one_filtered.call_args_list[0][0][0][0].compare(
                SupplierModel.supplier_id == supplier_id
            ),
            'assert filter has supplier_id == supplier_id'
        )

    @patch.object(SupplierModel, 'get_one_filtered')
    def test_GetOneByPhone_when_Default(self, mock_get_one_filtered: MagicMock):
        """Test get_one_by_phone when default behavior"""

        # when
        phone = 'valid phone'
        found_supplier = SupplierModel({})

        # mock
        mock_get_one_filtered.return_value = found_supplier

        # then
        response = SupplierService.get_one_by_phone(phone)

        # assert
        self.assertEqual(response, found_supplier)
        self.assertTrue(
            mock_get_one_filtered.call_args_list[0][0][0][0].compare(
                SupplierModel.phone == phone
            ),
            'assert filter has phone == phone'
        )
