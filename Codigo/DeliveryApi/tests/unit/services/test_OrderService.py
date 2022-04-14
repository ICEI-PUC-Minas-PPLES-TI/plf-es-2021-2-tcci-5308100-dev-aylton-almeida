from unittest.mock import MagicMock, patch
from uuid import uuid4

from werkzeug.exceptions import BadRequest, NotFound

from src.models.OrderModel import OrderModel
from src.services.OrderService import OrderService
from tests.utils.models.BaseTest import BaseTest


class OrderServiceTests(BaseTest):

    @patch.object(OrderModel, 'get_one_filtered')
    def test_GetOneById_when_Default(self, mock_get_one_filtered: MagicMock):
        """Test get_one_by_id when default behavior"""

        # when
        order_id = uuid4()
        order = OrderModel({'order_id': order_id})

        # mock
        mock_get_one_filtered.return_value = order

        # then
        response = OrderService.get_one_by_id(order_id)

        # assert
        self.assertEqual(response, order)
        self.assertTrue(
            mock_get_one_filtered.call_args_list[0][0][0][0].compare(
                OrderModel.order_id == order_id
            )
        )

    @patch.object(OrderModel, 'update')
    @patch.object(OrderService, 'get_one_by_id')
    def test_DeliverOrder_when_OrderNotFound(self, mock_get_one_by_id: MagicMock, mock_update: MagicMock):
        """Test deliver order when order not found"""

        # when
        order_id = uuid4()
        commit = False
        order = None

        # mock
        mock_get_one_by_id.return_value = order

        # then
        with self.assertRaises(NotFound) as err:
            OrderService.deliver_order(order_id, commit)

        # assert
        self.assertIn('Order not found for given id', str(err.exception))
        mock_get_one_by_id.assert_called_once_with(order_id)
        mock_update.assert_not_called()

    @patch.object(OrderModel, 'update')
    @patch.object(OrderService, 'get_one_by_id')
    def test_DeliverOrder_when_OrderAlreadyDelivered(self, mock_get_one_by_id: MagicMock, mock_update: MagicMock):
        """Test deliver order when order already delivered"""

        # when
        order_id = uuid4()
        commit = False
        order = OrderModel({
            'order_id': order_id,
            'delivered': True
        })

        # mock
        mock_get_one_by_id.return_value = order

        # then
        with self.assertRaises(BadRequest) as err:
            OrderService.deliver_order(order_id, commit)

        # assert
        self.assertIn('Order was already delivered', str(err.exception))
        mock_get_one_by_id.assert_called_once_with(order_id)
        mock_update.assert_not_called()

    @patch.object(OrderModel, 'update')
    @patch.object(OrderService, 'get_one_by_id')
    def test_DeliverOrder_when_ShouldCommit(self, mock_get_one_by_id: MagicMock, mock_update: MagicMock):
        """Test deliver order when should commit"""

        # when
        order_id = uuid4()
        commit = True
        order = OrderModel({
            'order_id': order_id,
            'delivered': False
        })

        # mock
        mock_get_one_by_id.return_value = order

        # then
        response = OrderService.deliver_order(order_id, commit)

        # assert
        self.assertEqual(response, order)
        mock_get_one_by_id.assert_called_once_with(order_id)
        mock_update.assert_called_once_with({'delivered': True}, commit)

    @patch.object(OrderModel, 'update')
    @patch.object(OrderService, 'get_one_by_id')
    def test_DeliverOrder_when_ShouldNotCommit(self, mock_get_one_by_id: MagicMock, mock_update: MagicMock):
        """Test deliver order when should not commit"""

        # when
        order_id = uuid4()
        commit = False
        order = OrderModel({
            'order_id': order_id,
            'delivered': False
        })

        # mock
        mock_get_one_by_id.return_value = order

        # then
        response = OrderService.deliver_order(order_id, commit)

        # assert
        self.assertEqual(response, order)
        mock_get_one_by_id.assert_called_once_with(order_id)
        mock_update.assert_called_once_with({'delivered': True}, commit)
