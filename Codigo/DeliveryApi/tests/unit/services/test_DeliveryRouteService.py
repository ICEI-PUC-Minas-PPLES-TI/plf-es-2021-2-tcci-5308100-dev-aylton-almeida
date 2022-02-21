from unittest.mock import MagicMock, patch
from uuid import uuid4

from src.models.DeliveryModel import DeliveryModel
from src.services.DeliveryRouteService import DeliveryRouteService
from tests.utils.models.BaseTest import BaseTest


class DeliveryRouteServiceTests(BaseTest):

    @patch.object(DeliveryRouteService, 'optimize_route')
    def test_CreateFromDelivery_when_Default(self, mock_optimize_route: MagicMock):
        """Test create_from_delivery when default behavior"""

        # when
        delivery = DeliveryModel({
            'delivery_id': uuid4(),
            'orders': [
                {'shipping_address': {'address_id': 1, 'lat': 1, 'lng': 1}},
                {'shipping_address': {'address_id': 2, 'lat': 2, 'lng': 2}},
            ]
        })

        # then
        response = DeliveryRouteService.create_from_delivery(delivery)

        # assert
        self.assertEqual(response.delivery_id, delivery.delivery_id)
        self.assertEqual(
            response.addresses[0].address_id, delivery.orders[0].shipping_address.address_id)
        self.assertEqual(
            response.addresses[1].address_id, delivery.orders[1].shipping_address.address_id)
        mock_optimize_route.assert_called_once()
