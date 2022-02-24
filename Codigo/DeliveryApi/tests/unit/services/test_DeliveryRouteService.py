from datetime import time
from unittest.mock import MagicMock, patch
from uuid import uuid4

from src.models.AddressModel import AddressModel
from src.models.DeliveryModel import DeliveryModel
from src.models.DeliveryRouteAddressModel import DeliveryRouteAddressModel
from src.models.DeliveryRouteModel import DeliveryRouteModel
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
        new_time = time(2, 30)

        # mock
        mock_optimize_route.return_value = new_time

        # then
        response = DeliveryRouteService.create_from_delivery(delivery)

        # assert
        self.assertEqual(response.estimate_time, new_time)
        self.assertEqual(response.addresses[0].address.address_id, 1)
        self.assertEqual(response.addresses[1].address.address_id, 2)
        self.assertEqual(response.delivery_id, delivery.delivery_id)
        self.assertEqual(
            response.addresses[0].address_id, delivery.orders[0].shipping_address.address_id)
        self.assertEqual(
            response.addresses[1].address_id, delivery.orders[1].shipping_address.address_id)
        mock_optimize_route.assert_called_once()

    @patch('src.services.DeliveryRouteService.seconds_to_time')
    @patch('src.services.DeliveryRouteService.get_directions')
    def test_OptimizeRoute_when_DirectionsFound(
        self,
        mock_get_directions: MagicMock,
        mock_seconds_to_time: MagicMock
    ):
        """Test optimize_route when directions were found"""

        # when
        delivery_route = DeliveryRouteModel({'delivery_id': uuid4()})
        delivery_route.addresses = [
            DeliveryRouteAddressModel({'address_id': 1}),
            DeliveryRouteAddressModel({'address_id': 2}),
            DeliveryRouteAddressModel({'address_id': 3}),
            DeliveryRouteAddressModel({'address_id': 4}),
            DeliveryRouteAddressModel({'address_id': 5}),
        ]
        for route_address in delivery_route.addresses:
            route_address.address = AddressModel({
                'address_id': route_address.address_id,
                'lat': route_address.address_id,
                'lng': route_address.address_id,
            })
        expected_time = time(2, 30)
        expected_directions = [{
            'legs': [
                {'duration': {'value': 1}},
                {'duration': {'value': 2}},
                {'duration': {'value': 3}},
            ],
            'waypoint_order': [2, 0, 1, 3],
        }]

        # mock
        mock_get_directions.return_value = expected_directions
        mock_seconds_to_time.return_value = expected_time

        # then
        response = DeliveryRouteService.optimize_route(delivery_route)

        # assert
        self.assertEqual(response, time(2, 30))
        self.assertEqual(delivery_route.addresses[0].position, 0)
        self.assertEqual(delivery_route.addresses[1].position, 2)
        self.assertEqual(delivery_route.addresses[2].position, 3)
        self.assertEqual(delivery_route.addresses[3].position, 1)
        self.assertEqual(delivery_route.addresses[4].position, 4)
        mock_get_directions.assert_called_once_with(
            delivery_route.addresses[0].address.get_lat_lng(),
            delivery_route.addresses[0].address.get_lat_lng(),
            [
                route_address.address.get_lat_lng()
                for route_address in delivery_route.addresses[1:]
            ],
        )
        mock_seconds_to_time.assert_called_once_with(6)
