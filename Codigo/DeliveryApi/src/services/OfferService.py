from abc import ABC

from src.schemas.DeliveryBaseSchema import DeliveryBaseSchema
from src.services.DeliveryService import DeliveryService


class OfferService(ABC):

    @staticmethod
    def handle_offer_complete_event(offer: dict):
        """Creates new delivery based on received offer"""

        parsed_delivery = DeliveryBaseSchema.from_offer(offer)

        DeliveryService.create_delivery(parsed_delivery)
