from abc import ABC
from uuid import UUID

from src.models.DelivererModel import DelivererModel


class DelivererService(ABC):

    @staticmethod
    def get_one_by_id(deliverer_id: UUID) -> DelivererModel:
        """Gets deliverer by its id

        Args:
            deliverer_id (UUID): deliverer id

        Returns:
            DelivererModel: found deliverer
        """

        # TODO: test

        return DelivererModel.get_one_filtered([
            DelivererModel.deliverer_id == deliverer_id
        ])

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
