from datetime import datetime, timezone
from unittest.mock import MagicMock, call, patch
from uuid import uuid4

from rabbitmq_pika_flask import RabbitMQ
from werkzeug.exceptions import BadRequest, NotFound, Unauthorized

from src.classes.DeliveryStatus import DeliveryStatus
from src.classes.ProblemType import ProblemType
from src.models.BaseModel import BaseModel
from src.models.DelivererModel import DelivererModel
from src.models.DeliveryModel import DeliveryModel
from src.models.DeliveryRouteModel import DeliveryRouteModel
from src.models.OrderModel import OrderModel
from src.services.DeliveryRouteService import DeliveryRouteService
from src.services.DeliveryService import DeliveryService
from src.services.OrderProblemService import OrderProblemService
from src.services.OrderService import OrderService
from tests.utils.models.BaseTest import BaseTest


class DeliveryServiceTests(BaseTest):

    @patch.object(DeliveryModel, 'get_one_filtered')
    def test_GetAvailableOneByCode_when_Default(self, mock_get_one_filtered: MagicMock):
        """Test get_one_by_code when default behavior"""

        # when
        code = 'access-code'
        found_delivery = DeliveryModel({})

        # mock
        mock_get_one_filtered.return_value = found_delivery

        # then
        response = DeliveryService.get_available_one_by_code(code)

        # assert
        self.assertEqual(response, found_delivery)
        self.assertTrue(
            mock_get_one_filtered.call_args_list[0][0][0][0].compare(
                DeliveryModel.access_code == code
            ),
            'assert filter has access_code == code'
        )
        self.assertTrue(
            mock_get_one_filtered.call_args_list[0][0][0][1].compare(
                DeliveryModel.status == DeliveryStatus.created
            ),
            'assert filter has status == created'
        )

    @patch.object(DeliveryModel, 'get_one_filtered')
    def test_GetOneByOfferId_when_Default(self, mock_get_one_filtered: MagicMock):
        """Test get_one_by_offer_id when default behavior"""

        # when
        offer_id = uuid4()
        found_delivery = DeliveryModel({})

        # mock
        mock_get_one_filtered.return_value = found_delivery

        # then
        response = DeliveryService.get_one_by_offer_id(offer_id)

        # assert
        self.assertEqual(response, found_delivery)
        self.assertTrue(
            mock_get_one_filtered.call_args_list[0][0][0][0].compare(
                DeliveryModel.offer_id == offer_id
            ),
            'assert filter has offer_id == offer_id'
        )

    @patch.object(DeliveryModel, 'get_all_filtered')
    def test_GetAllBySupplier_when_Default(self, mock_get_all_filtered: MagicMock):
        """Test get_all_by_supplier when default behavior"""

        # when
        supplier_id = 1
        found_deliveries = [DeliveryModel({}), DeliveryModel({})]

        # mock
        mock_get_all_filtered.return_value = found_deliveries

        # then
        response = DeliveryService.get_all_by_supplier(supplier_id)

        # assert
        self.assertEqual(response, found_deliveries)
        self.assertTrue(
            mock_get_all_filtered.call_args_list[0][0][0][0].compare(
                DeliveryModel.supplier_id == supplier_id
            ),
            'assert filter has supplier_id == supplier_id'
        )

    @patch.object(DeliveryRouteService, 'create_from_delivery')
    @patch.object(DeliveryModel, 'save')
    def test_CreateOptimizedDelivery_when_Default(self, mocK_save: MagicMock, mock_create_from_delivery: MagicMock):
        """Test create_optimized_delivery when default behavior"""

        # when
        delivery_data = {
            'offer_id': uuid4()
        }
        route = DeliveryRouteModel({})

        # mock
        mock_create_from_delivery.return_value = route

        # then
        DeliveryService.create_optimized_delivery(delivery_data)

        # assert
        mocK_save.assert_has_calls([
            call(commit=False),
            call()
        ])
        mock_create_from_delivery.assert_called_once()

    @patch.object(DeliveryService, 'get_one_by_id')
    @patch.object(DeliveryModel, 'update')
    def test_StartDelivery_when_NotFound(
        self,
        mock_update: MagicMock,
        mock_get_one_by_id: MagicMock
    ):
        """Test start_delivery when delivery was not found"""

        # when
        delivery = None
        delivery_id = uuid4()
        deliverer_id = 1

        # mock
        mock_get_one_by_id.return_value = delivery

        # then
        with self.assertRaises(NotFound) as err:
            DeliveryService.start_delivery(delivery_id, deliverer_id)

        # assert
        self.assertIn('Delivery not found', str(err.exception))
        mock_get_one_by_id.assert_called_once_with(delivery_id)
        mock_update.assert_not_called()

    @patch.object(DeliveryService, 'get_one_by_id')
    @patch.object(DeliveryModel, 'update')
    def test_StartDelivery_when_DeliveryAlreadyStarted(
        self,
        mock_update: MagicMock,
        mock_get_one_by_id: MagicMock
    ):
        """Test start_delivery when delivery has already started"""

        # when
        delivery_id = uuid4()
        delivery = DeliveryModel({
            'delivery_id': delivery_id,
            'status': DeliveryStatus.in_progress
        })
        deliverer_id = 1

        # mock
        mock_get_one_by_id.return_value = delivery

        # then
        with self.assertRaises(BadRequest) as err:
            DeliveryService.start_delivery(delivery_id, deliverer_id)

        # assert
        self.assertIn('Delivery has already started', str(err.exception))
        mock_get_one_by_id.assert_called_once_with(delivery_id)
        mock_update.assert_not_called()

    @patch.object(DeliveryService, 'get_one_by_id')
    @patch.object(DeliveryModel, 'update')
    def test_StartDelivery_when_DelivererNotDeliveringGivenDelivery(
        self,
        mock_update: MagicMock,
        mock_get_one_by_id: MagicMock
    ):
        """Test start_delivery when deliverer is not delivering given delivery"""

        # when
        delivery_id = uuid4()
        delivery = DeliveryModel({
            'delivery_id': delivery_id,
            'status': DeliveryStatus.created
        })
        delivery.deliverers = [
            DelivererModel({'deliverer_id': index})
            for index in range(2, 4)
        ]
        deliverer_id = 1

        # mock
        mock_get_one_by_id.return_value = delivery

        # then
        with self.assertRaises(Unauthorized) as err:
            DeliveryService.start_delivery(delivery_id, deliverer_id)

        # assert
        self.assertIn(
            'You are not authorized to start this delivery',
            str(err.exception)
        )
        mock_get_one_by_id.assert_called_once_with(delivery_id)
        mock_update.assert_not_called()

    @patch('src.services.DeliveryService.get_current_datetime')
    @patch.object(DeliveryService, 'get_one_by_id')
    @patch.object(DeliveryModel, 'update')
    def test_StartDelivery_when_Default(
        self,
        mock_update: MagicMock,
        mock_get_one_by_id: MagicMock,
        mock_get_current_datetime: MagicMock
    ):
        """Test start_delivery when default behavior"""

        # when
        delivery_id = uuid4()
        delivery = DeliveryModel({
            'delivery_id': delivery_id,
            'status': DeliveryStatus.created
        })
        delivery.deliverers = [
            DelivererModel({'deliverer_id': index})
            for index in range(3)
        ]
        deliverer_id = 1
        now = datetime.utcnow().replace(tzinfo=timezone.utc)

        # mock
        mock_get_one_by_id.return_value = delivery
        mock_get_current_datetime.return_value = now

        # then
        DeliveryService.start_delivery(delivery_id, deliverer_id)

        # assert
        mock_get_one_by_id.assert_called_once_with(delivery_id)
        mock_update.assert_called_once_with({
            'status': DeliveryStatus.in_progress,
            'start_time': now
        })

    @patch('src.services.DeliveryService.get_current_datetime')
    @patch.object(DeliveryService, 'get_one_by_id')
    @patch.object(OrderService, 'deliver_order')
    @patch.object(OrderProblemService, 'create_problem')
    @patch.object(DeliveryModel, 'update')
    @patch.object(BaseModel, 'commit')
    def test_DeliverOrderForDelivery_when_DeliveryNotFound(
        self,
        mock_commit: MagicMock,
        mock_update: MagicMock,
        mock_create_problem: MagicMock,
        mock_deliver_order: MagicMock,
        mock_get_one_by_id: MagicMock,
        mock_get_current_datetime: MagicMock
    ):
        """Test deliver_order_for_delivery when delivery was not found"""

        # when
        delivery_id = uuid4()
        order_id = uuid4()
        problem = {}
        delivery = None

        # mock
        mock_get_one_by_id.return_value = delivery

        # then
        with self.assertRaises(NotFound) as err:
            DeliveryService.deliver_order_for_delivery(
                delivery_id, order_id, problem)

        # assert
        self.assertIn('Delivery not found for given id', str(err.exception))
        mock_get_one_by_id.assert_called_once_with(delivery_id)
        mock_commit.assert_not_called()
        mock_update.assert_not_called()
        mock_create_problem.assert_not_called()
        mock_deliver_order.assert_not_called()
        mock_get_current_datetime.assert_not_called()

    @patch('src.services.DeliveryService.get_current_datetime')
    @patch.object(DeliveryService, 'get_one_by_id')
    @patch.object(OrderService, 'deliver_order')
    @patch.object(OrderProblemService, 'create_problem')
    @patch.object(DeliveryModel, 'update')
    @patch.object(BaseModel, 'commit')
    def test_DeliverOrderForDelivery_when_DeliveryIsNotInProgress(
        self,
        mock_commit: MagicMock,
        mock_update: MagicMock,
        mock_create_problem: MagicMock,
        mock_deliver_order: MagicMock,
        mock_get_one_by_id: MagicMock,
        mock_get_current_datetime: MagicMock
    ):
        """Test deliver_order_for_delivery when delivery is not in progress"""

        # when
        delivery_id = uuid4()
        order_id = uuid4()
        problem = {}
        delivery = DeliveryModel({
            'status': DeliveryStatus.created
        })

        # mock
        mock_get_one_by_id.return_value = delivery

        # then
        with self.assertRaises(BadRequest) as err:
            DeliveryService.deliver_order_for_delivery(
                delivery_id, order_id, problem)

        # assert
        self.assertIn('Delivery is not in progress', str(err.exception))
        mock_get_one_by_id.assert_called_once_with(delivery_id)
        mock_commit.assert_not_called()
        mock_update.assert_not_called()
        mock_create_problem.assert_not_called()
        mock_deliver_order.assert_not_called()
        mock_get_current_datetime.assert_not_called()

    @patch('src.services.DeliveryService.get_current_datetime')
    @patch.object(DeliveryService, 'get_one_by_id')
    @patch.object(OrderService, 'deliver_order')
    @patch.object(OrderProblemService, 'create_problem')
    @patch.object(DeliveryModel, 'update')
    @patch.object(BaseModel, 'commit')
    def test_DeliverOrderForDelivery_when_DeliveryDoesNotHavOrder(
        self,
        mock_commit: MagicMock,
        mock_update: MagicMock,
        mock_create_problem: MagicMock,
        mock_deliver_order: MagicMock,
        mock_get_one_by_id: MagicMock,
        mock_get_current_datetime: MagicMock
    ):
        """Test deliver_order_for_delivery when delivery does not have given order"""

        # when
        delivery_id = uuid4()
        order_id = uuid4()
        problem = {}
        delivery = DeliveryModel({
            'status': DeliveryStatus.in_progress,
        })
        delivery.orders = []

        # mock
        mock_get_one_by_id.return_value = delivery

        # then
        with self.assertRaises(BadRequest) as err:
            DeliveryService.deliver_order_for_delivery(
                delivery_id, order_id, problem)

        # assert
        self.assertIn('Delivery does not have given order', str(err.exception))
        mock_get_one_by_id.assert_called_once_with(delivery_id)
        mock_commit.assert_not_called()
        mock_update.assert_not_called()
        mock_create_problem.assert_not_called()
        mock_deliver_order.assert_not_called()
        mock_get_current_datetime.assert_not_called()

    @patch('src.services.DeliveryService.get_current_datetime')
    @patch.object(DeliveryService, 'get_one_by_id')
    @patch.object(OrderService, 'deliver_order')
    @patch.object(OrderProblemService, 'create_problem')
    @patch.object(DeliveryModel, 'update')
    @patch.object(BaseModel, 'commit')
    def test_DeliverOrderForDelivery_when_HasProblem(
        self,
        mock_commit: MagicMock,
        mock_update: MagicMock,
        mock_create_problem: MagicMock,
        mock_deliver_order: MagicMock,
        mock_get_one_by_id: MagicMock,
        mock_get_current_datetime: MagicMock
    ):
        """Test deliver_order_for_delivery when delivery has problem"""

        # when
        delivery_id = uuid4()
        order_id = uuid4()
        problem = {
            'type': ProblemType.absent_receiver.name,
            'description': 'test'
        }
        delivery = DeliveryModel({
            'status': DeliveryStatus.in_progress,
        })
        delivery.orders = [
            OrderModel({'order_id': order_id, 'delivered': False}),
            OrderModel({'order_id': uuid4(), 'delivered': False}),
        ]

        # mock
        mock_get_one_by_id.return_value = delivery

        # then
        response = DeliveryService.deliver_order_for_delivery(
            delivery_id,
            order_id,
            problem
        )

        # assert
        self.assertFalse(response)
        mock_get_one_by_id.assert_called_once_with(delivery_id)
        mock_deliver_order.assert_called_once_with(order_id, False)
        mock_create_problem.assert_called_once_with(
            order_id=order_id,
            problem_type=ProblemType.absent_receiver,
            description=problem['description'],
            commit=False
        )
        mock_update.assert_not_called()
        mock_get_current_datetime.assert_not_called()
        mock_commit.assert_called_once_with()

    @patch('src.services.DeliveryService.get_current_datetime')
    @patch.object(RabbitMQ, 'send')
    @patch.object(DeliveryService, 'get_one_by_id')
    @patch.object(OrderService, 'deliver_order')
    @patch.object(OrderProblemService, 'create_problem')
    @patch.object(DeliveryModel, 'update')
    @patch.object(BaseModel, 'commit')
    def test_DeliverOrderForDelivery_when_LastOrder(
        self,
        mock_commit: MagicMock,
        mock_update: MagicMock,
        mock_create_problem: MagicMock,
        mock_deliver_order: MagicMock,
        mock_get_one_by_id: MagicMock,
        mock_send: MagicMock,
        mock_get_current_datetime: MagicMock
    ):
        """Test deliver_order_for_delivery when deliveryhas problem"""

        # when
        delivery_id = uuid4()
        order_id = uuid4()
        problem = {
            'type': ProblemType.absent_receiver.name,
            'description': 'test'
        }
        delivery = DeliveryModel({
            'status': DeliveryStatus.in_progress,
        })
        delivery.orders = [
            OrderModel({'order_id': order_id, 'delivered': False}),
            OrderModel({'order_id': uuid4(), 'delivered': True}),
        ]
        now = datetime.now()

        # mock
        mock_get_one_by_id.return_value = delivery
        mock_get_current_datetime.return_value = now

        def mock_deliver(_order_id, _commit):
            delivery.orders[0].delivered = True
        mock_deliver_order.side_effect = mock_deliver

        # then
        response = DeliveryService.deliver_order_for_delivery(
            delivery_id,
            order_id,
            problem
        )

        # assert
        self.assertTrue(response)
        mock_get_one_by_id.assert_called_once_with(delivery_id)
        mock_deliver_order.assert_called_once_with(order_id, False)
        mock_create_problem.assert_called_once_with(
            order_id=order_id,
            problem_type=ProblemType.absent_receiver,
            description=problem['description'],
            commit=False
        )
        mock_update.assert_called_once_with({
            'status': DeliveryStatus.finished,
            'end_time': now
        })
        mock_get_current_datetime.assert_called_once_with()
        mock_commit.assert_not_called()
        mock_send.assert_called_once_with(
            delivery,
            'delivery.delivery.finished'
        )
