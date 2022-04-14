from abc import ABC
from uuid import UUID

from werkzeug.exceptions import BadRequest, NotFound

from src.models.OrderModel import OrderModel


class OrderService(ABC):

    @staticmethod
    def get_one_by_id(order_id: UUID) -> OrderModel:
        """Gets one order given its id"""

        return OrderModel.get_one_filtered([OrderModel.order_id == order_id])

    @staticmethod
    def deliver_order(order_id: UUID, commit: bool) -> OrderModel:
        """Delivers an order"""

        order = OrderService.get_one_by_id(order_id)

        if not order:
            raise NotFound('Order not found for given id')

        if order.delivered:
            raise BadRequest('Order was already delivered')

        order.update({'delivered': True}, commit)

        return order
