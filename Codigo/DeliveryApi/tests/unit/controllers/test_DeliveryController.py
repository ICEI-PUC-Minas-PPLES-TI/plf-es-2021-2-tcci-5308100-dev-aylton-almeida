from http import HTTPStatus
from unittest.mock import MagicMock, patch
from uuid import uuid4

from src.apis.gateway import gateway
from src.classes.Role import Role
from src.models.DelivererModel import DelivererModel
from src.models.DeliveryModel import DeliveryModel
from src.models.DeliveryRouteModel import DeliveryRouteModel
from src.services.DeliveryService import DeliveryService
from tests import base_path
from tests.utils.models.BaseTest import BaseTest


class DeliveryControllerTests(BaseTest):

    @patch.object(DeliveryService, 'get_available_one_by_code')
    def test_VerifyDelivery_when_DeliveryFound(
        self,
        mock_get_available_one_by_code: MagicMock,
    ):
        """Test verify delivery when delivery was found
        """

        # when
        code = '12345'
        delivery_id = uuid4()
        delivery = DeliveryModel(
            {'access_code': code, 'delivery_id': delivery_id})

        # mock
        mock_get_available_one_by_code.return_value = delivery

        # then
        response = self.app.get(
            f'{base_path}/deliveries/verify/{code}',
            follow_redirects=True
        )

        # assert
        self.assertEqual(response.json.get('deliveryId'), str(delivery_id))
        self.assertEqual(response.status_code, HTTPStatus.OK)
        mock_get_available_one_by_code.assert_called_once_with(code)

    @patch.object(DeliveryService, 'get_available_one_by_code')
    def test_VerifyDelivery_when_DeliveryNotFound(
        self,
        mock_get_available_one_by_code: MagicMock,
    ):
        """Test verify delivery when delivery was not found
        """

        # when
        code = '12345'
        delivery = None

        # mock
        mock_get_available_one_by_code.return_value = delivery

        # then
        response = self.app.get(
            f'{base_path}/deliveries/verify/{code}',
            follow_redirects=True
        )

        # assert
        self.assertEqual(response.status_code, HTTPStatus.NOT_FOUND)
        mock_get_available_one_by_code.assert_called_once_with(code)

    @patch.object(gateway.service['auth'], 'authorize_request')
    @patch.object(DeliveryService, 'get_all_by_supplier')
    def test_GetSupplierDeliveries_when_Default(
        self,
        mock_get_all_by_supplier: MagicMock,
        mock_authorize_request: MagicMock,
    ):
        """Test get supplier deliveries when default behavior
        """

        # when
        supplier_id = 1
        deliveries = [
            DeliveryModel({'delivery_id': uuid4()}),
            DeliveryModel({'delivery_id': uuid4()})
        ]
        token = 'Bearer 12345'

        # mock
        mock_get_all_by_supplier.return_value = deliveries
        mock_authorize_request.return_value = {
            'roles': [Role.supplier], 'user_id': supplier_id}

        # then
        response = self.app.get(
            f'{base_path}/deliveries',
            follow_redirects=True,
            headers={
                'Authorization': token
            }
        )

        # assert
        self.assertEqual(response.status_code, HTTPStatus.OK)
        for index, delivery in enumerate(deliveries):
            self.assertDictEqual(
                response.json.get('deliveries')[index] | {
                    'deliveryId': str(delivery.delivery_id),
                },
                response.json.get('deliveries')[index]
            )
        mock_authorize_request.assert_called_once_with(
            token,
            [Role.supplier]
        )

    @patch.object(gateway.service['auth'], 'authorize_request')
    @patch.object(DeliveryService, 'get_one_by_id')
    def test_GetDelivery_when_SupplierAllowed(
        self,
        mock_get_one_by_id: MagicMock,
        mock_authorize_request: MagicMock,
    ):
        """Test get delivery when supplier is allowed to access delivery
        """

        # when
        supplier_id = 1
        delivery = DeliveryModel(
            {
                'delivery_id': uuid4(),
                'supplier_id': supplier_id
            }
        )
        token = 'Bearer 12345'

        # mock
        mock_get_one_by_id.return_value = delivery
        mock_authorize_request.return_value = {
            'roles': [Role.supplier], 'user_id': supplier_id}

        # then
        response = self.app.get(
            f'{base_path}/deliveries/{delivery.delivery_id}',
            follow_redirects=True,
            headers={
                'Authorization': token
            }
        )

        # assert
        self.assertEqual(response.status_code, HTTPStatus.OK)
        self.assertEqual(
            response.json.get('delivery').get('deliveryId'),
            str(delivery.delivery_id)
        )
        self.assertIsNone(response.json.get('route'))
        mock_authorize_request.assert_called_once_with(
            token,
            [Role.supplier, Role.deliverer]
        )

    @patch.object(gateway.service['auth'], 'authorize_request')
    @patch.object(DeliveryService, 'get_one_by_id')
    def test_GetDelivery_when_DelivererAllowed(
        self,
        mock_get_one_by_id: MagicMock,
        mock_authorize_request: MagicMock,
    ):
        """Test get delivery when deliverer is allowed to access delivery
        """

        # when
        deliverer_id = 1
        route_id = 5
        delivery = DeliveryModel(
            {
                'delivery_id': uuid4(),
                'supplier_id': 2
            }
        )
        delivery.deliverers = [
            DelivererModel({
                'delivery_id': delivery.delivery_id,
                'deliverer_id': deliverer_id
            })
        ]
        delivery.route = DeliveryRouteModel({'delivery_route_id': route_id})
        token = 'Bearer 12345'

        # mock
        mock_get_one_by_id.return_value = delivery
        mock_authorize_request.return_value = {
            'roles': [Role.deliverer], 'user_id': deliverer_id}

        # then
        response = self.app.get(
            f'{base_path}/deliveries/{delivery.delivery_id}',
            follow_redirects=True,
            headers={
                'Authorization': token
            }
        )

        # assert
        self.assertEqual(response.status_code, HTTPStatus.OK)
        self.assertEqual(
            response.json.get('delivery').get('deliveryId'),
            str(delivery.delivery_id)
        )
        self.assertEqual(
            response.json.get('route').get('deliveryRouteId'),
            delivery.route.delivery_route_id
        )
        mock_authorize_request.assert_called_once_with(
            token,
            [Role.supplier, Role.deliverer]
        )

    @patch.object(gateway.service['auth'], 'authorize_request')
    @patch.object(DeliveryService, 'get_one_by_id')
    def test_GetDelivery_when_SupplierNotAllowed(
        self,
        mock_get_one_by_id: MagicMock,
        mock_authorize_request: MagicMock,
    ):
        """Test get delivery when supplier is not allowed to access delivery
        """

        # when
        supplier_id = 1
        delivery = DeliveryModel(
            {
                'delivery_id': uuid4(),
                'supplier_id': 2
            }
        )
        token = 'Bearer 12345'

        # mock
        mock_get_one_by_id.return_value = delivery
        mock_authorize_request.return_value = {
            'roles': [Role.supplier], 'user_id': supplier_id}

        # then
        response = self.app.get(
            f'{base_path}/deliveries/{delivery.delivery_id}',
            follow_redirects=True,
            headers={
                'Authorization': token
            }
        )

        # assert
        self.assertEqual(response.status_code, HTTPStatus.FORBIDDEN)
        mock_authorize_request.assert_called_once_with(
            token,
            [Role.supplier, Role.deliverer]
        )

    @patch.object(gateway.service['auth'], 'authorize_request')
    @patch.object(DeliveryService, 'get_one_by_id')
    def test_GetDelivery_when_DeliveryHasNoDeliverers(
        self,
        mock_get_one_by_id: MagicMock,
        mock_authorize_request: MagicMock,
    ):
        """Test get delivery when delivery has no deliverers
        """

        # when
        deliverer_id = 1
        delivery = DeliveryModel(
            {
                'delivery_id': uuid4(),
                'supplier_id': 2
            }
        )
        delivery.deliverers = []
        token = 'Bearer 12345'

        # mock
        mock_get_one_by_id.return_value = delivery
        mock_authorize_request.return_value = {
            'roles': [Role.deliverer], 'user_id': deliverer_id}

        # then
        response = self.app.get(
            f'{base_path}/deliveries/{delivery.delivery_id}',
            follow_redirects=True,
            headers={
                'Authorization': token
            }
        )

        # assert
        self.assertEqual(response.status_code, HTTPStatus.FORBIDDEN)
        mock_authorize_request.assert_called_once_with(
            token,
            [Role.supplier, Role.deliverer]
        )

    @patch.object(gateway.service['auth'], 'authorize_request')
    @patch.object(DeliveryService, 'get_one_by_id')
    def test_GetDelivery_when_DelivererNotAllowed(
        self,
        mock_get_one_by_id: MagicMock,
        mock_authorize_request: MagicMock,
    ):
        """Test get delivery when deliverer not allowed in this delivery
        """

        # when
        deliverer_id = 1
        delivery = DeliveryModel(
            {
                'delivery_id': uuid4(),
                'supplier_id': 2
            }
        )
        delivery.deliverers = [
            DelivererModel({
                'delivery_id': delivery.delivery_id,
                'deliverer_id': 2
            })
        ]
        token = 'Bearer 12345'

        # mock
        mock_get_one_by_id.return_value = delivery
        mock_authorize_request.return_value = {
            'roles': [Role.deliverer], 'user_id': deliverer_id}

        # then
        response = self.app.get(
            f'{base_path}/deliveries/{delivery.delivery_id}',
            follow_redirects=True,
            headers={
                'Authorization': token
            }
        )

        # assert
        self.assertEqual(response.status_code, HTTPStatus.FORBIDDEN)
        mock_authorize_request.assert_called_once_with(
            token,
            [Role.supplier, Role.deliverer]
        )

    @patch.object(gateway.service['auth'], 'authorize_request')
    @patch.object(DeliveryService, 'start_delivery')
    def test_StartDelivery_when_Default(
        self,
        mock_start_delivery: MagicMock,
        mock_authorize_request: MagicMock,
    ):
        """Test start delivery when default behavior"""

        # when
        deliverer_id = 1
        delivery_id = uuid4()
        token = 'Bearer 12345'

        # mock
        mock_authorize_request.return_value = {
            'roles': [Role.deliverer], 'user_id': deliverer_id}

        # then
        response = self.app.post(
            f'{base_path}/deliveries/{delivery_id}',
            follow_redirects=True,
            headers={
                'Authorization': token
            }
        )

        # assert
        self.assertEqual(response.status_code, HTTPStatus.OK)
        mock_authorize_request.assert_called_once_with(
            token,
            [Role.deliverer]
        )
        mock_start_delivery.assert_called_once_with(
            delivery_id,
            deliverer_id,
        )
