from http import HTTPStatus
from unittest.mock import MagicMock, patch
from uuid import uuid4

from src.models.DeliveryModel import DeliveryModel
from src.services.DeliveryService import DeliveryService
from tests import base_path
from tests.utils.models.BaseTest import BaseTest


class DeliveryControllerTests(BaseTest):

    @patch.object(DeliveryService, 'get_one_by_code')
    def test_VerifyDelivery_when_DeliveryFound(
        self,
        mock_get_one_by_code: MagicMock,
    ):
        """Test verify delivery when delivery was found
        """

        # when
        code = '12345'
        delivery_id = uuid4()
        delivery = DeliveryModel(
            {'access_code': code, 'delivery_id': delivery_id})

        # mock
        mock_get_one_by_code.return_value = delivery

        # then
        response = self.app.get(
            f'{base_path}/deliveries/verify/{code}',
            follow_redirects=True
        )

        # assert
        self.assertEqual(response.json.get('deliveryId'), str(delivery_id))
        self.assertEqual(response.status_code, HTTPStatus.OK)
        mock_get_one_by_code.assert_called_once_with(code)

    @patch.object(DeliveryService, 'get_one_by_code')
    def test_VerifyDelivery_when_DeliveryNotFound(
        self,
        mock_get_one_by_code: MagicMock,
    ):
        """Test verify delivery when delivery was not found
        """

        # when
        code = '12345'
        delivery = None

        # mock
        mock_get_one_by_code.return_value = delivery

        # then
        response = self.app.get(
            f'{base_path}/deliveries/verify/{code}',
            follow_redirects=True
        )

        # assert
        self.assertEqual(response.status_code, HTTPStatus.NOT_FOUND)
        mock_get_one_by_code.assert_called_once_with(code)
