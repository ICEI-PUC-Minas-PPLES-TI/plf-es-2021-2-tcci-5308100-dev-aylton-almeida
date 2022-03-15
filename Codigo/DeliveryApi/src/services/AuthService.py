from abc import ABC

from werkzeug.exceptions import NotFound, Unauthorized

from src.apis.AuthApi import Role
from src.apis.gateway import gateway
from src.models.BaseModel import BaseModel
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
    def authenticate_deliverer(phone: str, delivery_id: str):
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

    @staticmethod
    def authenticate_supplier(phone: str):
        """Authenticates supplier, returning it if found

        Args:
            phone (str): Phone to authenticate supplier with

        Returns:
            SupplierModel: Found supplier if any
        """

        supplier = SupplierService.get_one_by_phone(phone)

        if not supplier:
            raise NotFound(f'Supplier not found with phone {phone}')

        gateway.service['auth'].authenticate_supplier(supplier.supplier_id)

        return supplier

    @staticmethod
    def verify_supplier_code(supplier_id: int, code: str):
        """Verifies supplier code and return supplier if code is correct

        Args:
            supplier_id (int): Supplier id to verify code with
            code (str): Code to be verified

        Returns:
            tuple[SupplierModel, str]: Authenticated supplier and JWT token
        """

        supplier = SupplierService.get_one_by_id(supplier_id)

        if not supplier:
            raise NotFound(f'Supplier not found with id {supplier_id}')

        if gateway.service['auth'].verify_auth_code(code):
            raise Unauthorized('Invalid code received')

        token = create_jwt_token(supplier_id, Role.supplier)

        return token, supplier
