from abc import ABC
from uuid import UUID

from src.models.DeliveryModel import DeliveryModel


class DeliveryService(ABC):

    @staticmethod
    def get_one_by_offer_id(offer_id: UUID):
        """Gets one delivery given its offer id"""

        # TODO: test

        return DeliveryModel.get_one_filtered([
            DeliveryModel.offer_id == offer_id,
        ])

    @staticmethod
    def create_delivery(delivery: dict, commit=True):
        """Creates delivery"""

        # TODO: test

        delivery = DeliveryModel(delivery)
        delivery.save(commit)
