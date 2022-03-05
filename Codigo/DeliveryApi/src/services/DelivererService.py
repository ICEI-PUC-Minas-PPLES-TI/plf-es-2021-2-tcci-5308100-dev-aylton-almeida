from abc import ABC

from src.models.DelivererModel import DelivererModel


class DelivererService(ABC):

    @staticmethod
    def create(deliverer: dict, commit=True):
        """Creates a new deliverer

        Args:
            deliverer (dict): deliverer base data
            commit (bool): commit changes to db. Defaults to True.
        """

        # TODO: test

        deliverer = DelivererModel(deliverer)
        deliverer.save(commit)

        return deliverer
