from abc import ABC
from uuid import UUID

from src.apis.AuthApi import Role
from src.models.BaseModel import BaseModel
from src.models.DelivererModel import DelivererModel
from src.services.DelivererService import DelivererService
from src.utils.JwtUtils import create_jwt_token


class AuthService(ABC):

    @staticmethod
    def authorize_deliverer(deliverer_id: UUID) -> DelivererModel:
        """Returns current deliverer for given deliverer id

        Args:
            deliverer_id (UUID): deliverer id to be found

        Returns:
            DelivererModel: found deliverer
        """

        # TODO: test

        return DelivererService.get_one_by_id(deliverer_id)

    @staticmethod
    def authenticate_deliverer(phone: str, delivery_id: str) -> tuple[str, DelivererModel]:
        """Authenticates deliverer

        Args:
            phone (str): Deliverer phone
            delivery_id (str): Delivery id from delivery

        Returns:
            str, DelivererModel: JWT token and deliverer data
        """

        # TODO: test

        deliverer = DelivererService.create(
            {
                'phone': phone,
                'delivery_id': delivery_id
            },
            False
        )

        token = create_jwt_token(deliverer.deliverer_id, Role.deliverer)

        BaseModel.commit()

        return token, deliverer
