from abc import ABC

from src.apis.AuthApi import Role
from src.models.BaseModel import BaseModel
from src.models.DelivererModel import DelivererModel
from src.services.DelivererService import DelivererService
from src.services.SupplierService import SupplierService
from src.utils.JwtUtils import create_jwt_token


class AuthService(ABC):

    @staticmethod
    def authorize(user_id: int, roles: list[Role]) -> dict:
        """Authorizes current user

        Args:
            user_id (int): user id
            role (Role): list of allowed roles for user

        Returns:
            dict: found deliverer and/or supplier
        """

        response = {}

        if Role.deliverer in roles:
            response['deliverer'] = DelivererService.get_one_by_id(user_id)

        if Role.supplier in roles:
            response['supplier'] = SupplierService.get_one_by_id(user_id)

        return response

    @staticmethod
    def authenticate_deliverer(phone: str, delivery_id: str) -> tuple[str, DelivererModel]:
        """Authenticates deliverer

        Args:
            phone (str): Deliverer phone
            delivery_id (str): Delivery id from delivery

        Returns:
            str, DelivererModel: JWT token and deliverer data
        """

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
