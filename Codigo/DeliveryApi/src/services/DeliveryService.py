from abc import ABC
from uuid import UUID

from werkzeug.exceptions import BadRequest, NotFound, Unauthorized

from src.classes.DeliveryStatus import DeliveryStatus
from src.classes.ProblemType import ProblemType
from src.models.BaseModel import BaseModel
from src.models.DeliveryModel import DeliveryModel
from src.services.DeliveryRouteService import DeliveryRouteService
from src.services.OrderProblemService import OrderProblemService
from src.services.OrderService import OrderService
from src.utils.DateUtils import get_current_datetime


class DeliveryService(ABC):

    @staticmethod
    def get_available_one_by_code(code: str) -> DeliveryModel:
        """Gets one available delivery given its access code"""

        return DeliveryModel.get_one_filtered([
            DeliveryModel.access_code == code,
            DeliveryModel.status == DeliveryStatus.created
        ])

    @staticmethod
    def get_one_by_offer_id(offer_id: UUID) -> DeliveryModel:
        """Gets one delivery given its offer id"""

        return DeliveryModel.get_one_filtered([
            DeliveryModel.offer_id == offer_id,
        ])

    @staticmethod
    def get_one_by_id(delivery_id: UUID) -> DeliveryModel:
        """Gets one delivery given its id"""

        return DeliveryModel.query.get(delivery_id)

    @staticmethod
    def get_all_by_supplier(supplier_id: int) -> list[DeliveryModel]:
        """Gets all deliveries found for a given supplier"""

        return DeliveryModel.get_all_filtered([
            DeliveryModel.supplier_id == supplier_id
        ])

    @staticmethod
    def create_optimized_delivery(delivery_data: dict):
        """Creates a new delivery and also an optimized route for its orders"""

        # Create delivery
        delivery = DeliveryModel(delivery_data)
        delivery.save(commit=False)

        # calculate delivery route
        delivery.route = DeliveryRouteService.create_from_delivery(delivery)

        # Commit transaction
        delivery.save()

    @staticmethod
    def start_delivery(delivery_id: UUID, deliverer_id: int):
        """Starts a delivery

            Args:
                delivery_id (UUID): id of the delivery to start
                deliverer_id (int): id of the deliverer who starts the delivery
        """

        delivery = DeliveryService.get_one_by_id(delivery_id)

        if not delivery:
            raise NotFound('Delivery not found')

        if delivery.status != DeliveryStatus.created:
            raise BadRequest('Delivery has already started')

        if not any(deliverer.deliverer_id == deliverer_id for deliverer in delivery.deliverers):
            raise Unauthorized('You are not authorized to start this delivery')

        delivery.update({
            'status': DeliveryStatus.in_progress,
            'start_time': get_current_datetime()
        })

    @staticmethod
    def deliver_order_for_delivery(
        delivery_id: UUID,
        order_id: UUID,
        problem: dict = None
    ):
        """Sets order as delivered with given data

            Args:
                delivery_id (UUID): id of the delivery containing order
                order_id (UUID): id of the order to update
                delivered (bool): whether the order was delivered or not
                problem (dict): problem data to create a problem for the order. Defaults to None

            Returns:
                bool: whether the delivery has finished or not
        """

        # check if delivery is in progress and has given order
        delivery = DeliveryService.get_one_by_id(delivery_id)

        if not delivery:
            raise NotFound('Delivery not found for given id')

        if delivery.status != DeliveryStatus.in_progress:
            raise BadRequest('Delivery is not in progress')

        if not any(order.order_id == order_id for order in delivery.orders):
            raise BadRequest('Delivery does not have given order')

        # update order
        OrderService.deliver_order(order_id, False)

        # create problem if any
        if problem:
            OrderProblemService.create_problem(
                order_id=order_id,
                problem_type=ProblemType[problem.get('type')],
                description=problem.get('description'),
                commit=False
            )

        # update delivery if all orders are delivered
        if not any(not order.delivered for order in delivery.orders):
            delivery.update({
                'status': DeliveryStatus.finished,
                'end_time': get_current_datetime()
            })

            return True

        BaseModel.commit()

        return False
