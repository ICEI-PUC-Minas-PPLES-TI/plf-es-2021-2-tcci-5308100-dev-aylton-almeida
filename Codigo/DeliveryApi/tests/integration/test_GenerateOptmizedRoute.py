from datetime import time
from unittest.mock import MagicMock, patch
from uuid import UUID

from src.events.listen.OfferQueue import offer_completed_queue
from src.models.DeliveryModel import DeliveryModel
from src.models.SupplierModel import SupplierModel
from src.utils.CaseConverter import convert_to_case, to_snake_case
from tests.utils.models.BaseIntegrationTest import BaseIntegrationTest
from tests.utils.sample_reader import get_sample


class GenerateOptimizedRouteTest(BaseIntegrationTest):

    @patch('src.services.DeliveryRouteService.get_directions')
    @patch('src.models.AddressModel.get_lat_lng_from_address')
    def test_GenerateOptimizedRoute_when_OfferSample1(
        self,
        mock_get_lat_lng_from_address: MagicMock,
        mock_get_directions: MagicMock
    ):
        """test generate optimized route when offer sample 1 was sent.
            It should create a delivery route with it's optimized route.
        """

        # when
        offer_sample = convert_to_case(
            get_sample('offer_sample_1'), to_snake_case)
        offer_addresses = get_sample('offer_sample_1_addresses')
        directions_response = get_sample('offer_sample_1_directions_response')
        ordered_addresses = [1, 16, 17, 26, 5, 21, 10, 2, 3, 7, 12,
                             14, 18, 19, 25, 13, 24, 20, 15, 23, 22, 8, 6, 9, 11, 4]

        # mock
        mock_get_lat_lng_from_address.side_effect = lambda address: offer_addresses[
            f'{address.street_name}, {address.street_number}'
        ]
        mock_get_directions.return_value = directions_response

        # then
        offer_completed_queue('test.offer.status.completed', offer_sample, 1)

        # fetch
        delivery: DeliveryModel = DeliveryModel.query.first()
        supplier: SupplierModel = SupplierModel.query.first()

        # assert
        mock_get_lat_lng_from_address.assert_called()
        mock_get_directions.assert_called_once()

        self.assertEqual(delivery.offer_id, UUID(offer_sample['offer_id']))
        self.assertEqual(delivery.status, 'created')
        self.assertEqual(delivery.supplier_id, supplier.supplier_id)
        self.assertDictEqual(
            vars(supplier) | {
                'supplier_id': offer_sample['supplier']['supplier_id'],
                'name': offer_sample['supplier']['name'],
                'phone': offer_sample['supplier']['phone'],
                'legal_id': offer_sample['supplier']['legal_id'],
            },
            vars(supplier)
        )
        self.assertEqual(len(delivery.orders), len(offer_sample['orders']))
        for index, order in enumerate(delivery.orders):
            self.assertEqual(
                len(order.order_products),
                len(offer_sample['orders'][index]['order_products'])
            )
        self.assertEqual(delivery.route.estimate_time, time(3, 13, 49))
        self.assertListEqual(
            [route_address.address_id for route_address in sorted(
                delivery.route.addresses, key=lambda x: x.position)],
            ordered_addresses
        )
