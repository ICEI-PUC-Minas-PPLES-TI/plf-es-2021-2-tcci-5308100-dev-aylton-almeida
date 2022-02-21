from abc import ABC

from src.schemas.DeliveryBaseSchema import DeliveryBaseSchema
from src.services.DeliveryService import DeliveryService


class OfferService(ABC):

    @staticmethod
    def handle_offer_complete_event(offer: dict):
        """Creates new delivery based on received offer if it's not already created"""

        parsed_delivery = DeliveryBaseSchema.from_offer(offer)

        if not DeliveryService.get_one_by_offer_id(parsed_delivery.get('offer_id')):
            DeliveryService.create_optimized_delivery(parsed_delivery)
