from src.models.DeliveryRouteModel import DeliveryRouteModel
from tests.utils.models.BaseTest import BaseTest


class DeliveryRouteModelTests(BaseTest):

    def test_Route_when_Default(self):
        """Test route property when default"""

        # when
        delivery_route = DeliveryRouteModel({
            'delivery_route_id': 1,
            'estimate_time': '00:00:00',
            'addresses': [
                {'address_id': 1, 'position': 1},
                {'address_id': 2, 'position': 3},
                {'address_id': 3, 'position': 2},
            ]
        })

        # assert
        self.assertEqual(delivery_route.route[0].address_id, 1)
        self.assertEqual(delivery_route.route[1].address_id, 3)
        self.assertEqual(delivery_route.route[2].address_id, 2)
