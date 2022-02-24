from abc import ABC

from src.schemas.DeliveryBaseSchema import DeliveryBaseSchema
from src.schemas.SupplierBaseSchema import SupplierBaseSchema
from src.services.DeliveryService import DeliveryService
from src.services.SupplierService import SupplierService


class OfferService(ABC):

    @staticmethod
    def handle_offer_complete_event(offer: dict):
        """Creates new delivery based on received offer if it's not already created"""

        parsed_delivery = DeliveryBaseSchema.from_offer(offer)
        parsed_supplier = SupplierBaseSchema.from_offer(offer.get('supplier'))

        SupplierService.create_if_not_created(parsed_supplier)

        if not DeliveryService.get_one_by_offer_id(parsed_delivery.get('offer_id')):
            DeliveryService.create_optimized_delivery(parsed_delivery)
