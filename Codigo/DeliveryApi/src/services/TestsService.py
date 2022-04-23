import json
from abc import ABC

from src.models.DeliveryModel import DeliveryModel
from src.services.DeliveryService import DeliveryService
from src.services.OfferService import OfferService


class TestsService(ABC):

    @staticmethod
    def setup_test_delivery() -> DeliveryModel:
        """Sets up a test delivery for integration tests"""

        with open("samples/integrationTestOffer.json", encoding='utf-8') as sample_file:
            sample_offer = json.load(sample_file)

        # delete current delivery if found
        delivery = DeliveryService.get_one_by_offer_id(
            sample_offer.get('offer_id'))
        if delivery:
            delivery.delete()

        # create new one using the offer queue flow
        delivery = OfferService.handle_offer_complete_event(sample_offer)

        return delivery
