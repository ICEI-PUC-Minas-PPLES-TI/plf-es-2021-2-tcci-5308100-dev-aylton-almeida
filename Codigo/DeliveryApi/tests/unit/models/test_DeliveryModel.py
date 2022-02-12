from unittest.mock import MagicMock, call, patch

from src.models.BaseModel import BaseModel
from src.models.DeliveryModel import (DeliveryModel,
                                      _generate_delivery_access_code)
from tests.utils.models.BaseTest import BaseTest


class DeliveryModelTests(BaseTest):

    @patch('src.models.DeliveryModel.generate_secret_code')
    @patch.object(BaseModel, 'get_one_filtered')
    def test_GenerateDeliveryAccessCode_when_FirstCodeDoesNotExist(
        self,
        mock_get_one_filtered: MagicMock,
        mock_generate_secret_code: MagicMock
    ):
        """Test _generate_delivery_access_code when first code does not exist
            It should return it
        """

        # when
        codes = ['123456']

        # mock
        mock_generate_secret_code.side_effect = codes
        mock_get_one_filtered.side_effect = [None]

        # then
        response = _generate_delivery_access_code(None)

        # assert
        self.assertEqual(response, codes[0])
        mock_generate_secret_code.assert_has_calls([
            call(6)
            for _ in codes
        ])
        call_args_list = mock_get_one_filtered.call_args_list
        for index, call_args in enumerate(call_args_list):
            self.assertTrue(call_args[0][0][0].compare(
                DeliveryModel.access_code == codes[index])
            )

    @patch('src.models.DeliveryModel.generate_secret_code')
    @patch.object(BaseModel, 'get_one_filtered')
    def test_GenerateDeliveryAccessCode_when_FirstCodeAlreadyExists(
        self,
        mock_get_one_filtered: MagicMock,
        mock_generate_secret_code: MagicMock
    ):
        """Test _generate_delivery_access_code when first code already exists
            It should generate 2 codes, since the first one already exists
        """

        # when
        codes = ['123456', '654321']

        # mock
        mock_generate_secret_code.side_effect = codes
        mock_get_one_filtered.side_effect = ['Valid Delivery Model', None]

        # then
        response = _generate_delivery_access_code(None)

        # assert
        self.assertEqual(response, codes[1])
        mock_generate_secret_code.assert_has_calls([
            call(6)
            for _ in codes
        ])
        call_args_list = mock_get_one_filtered.call_args_list
        for index, call_args in enumerate(call_args_list):
            self.assertTrue(call_args[0][0][0].compare(
                DeliveryModel.access_code == codes[index])
            )
