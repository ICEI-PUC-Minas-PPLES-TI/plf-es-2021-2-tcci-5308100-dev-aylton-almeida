from abc import ABC

from src.models.DelivererModel import DelivererModel


class DelivererService(ABC):

    @staticmethod
    def create(deliverer: dict):
        """Creates a new deliverer

        Args:
            deliverer (dict): deliverer base data
        """

        # TODO: test

        deliverer = DelivererModel(deliverer)
        deliverer.save()

        return deliverer
