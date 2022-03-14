from abc import ABC
from uuid import UUID

from src.models.DeliveryModel import DeliveryModel
from src.services.DeliveryRouteService import DeliveryRouteService


class DeliveryService(ABC):

    @staticmethod
    def get_one_by_code(code: str) -> DeliveryModel:
        """Gets one delivery given its access code"""

        return DeliveryModel.get_one_filtered([
            DeliveryModel.access_code == code
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
