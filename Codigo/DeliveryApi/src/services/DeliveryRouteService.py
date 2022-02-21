from abc import ABC

from src.models.DeliveryModel import DeliveryModel
from src.models.DeliveryRouteModel import DeliveryRouteModel


class DeliveryRouteService(ABC):

    @staticmethod
    def create_from_delivery(delivery: DeliveryModel) -> DeliveryRouteModel:
        """Creates new delivery route from a delivery"""

        delivery_route = DeliveryRouteModel({
            'delivery_id': delivery.delivery_id,
        })

        delivery_route.addresses = [
            order.shipping_address
            for order in delivery.orders
        ]

        DeliveryRouteService.optimize_route(delivery_route)

        return delivery_route

    @staticmethod
    def optimize_route(delivery_route: DeliveryRouteModel):
        """Optimizes given delivery route"""

        # ? I still need to figure out how to to this
