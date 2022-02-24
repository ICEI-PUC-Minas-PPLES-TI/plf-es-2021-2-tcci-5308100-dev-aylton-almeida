from abc import ABC
from uuid import UUID

from src.models.DeliveryModel import DeliveryModel
from src.services.DeliveryRouteService import DeliveryRouteService


class DeliveryService(ABC):

    @staticmethod
    def get_one_by_offer_id(offer_id: UUID):
        """Gets one delivery given its offer id"""

        return DeliveryModel.get_one_filtered([
            DeliveryModel.offer_id == offer_id,
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
