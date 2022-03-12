from abc import ABC

from src.models.SupplierModel import SupplierModel


class SupplierService(ABC):

    @staticmethod
    def get_one_by_id(supplier_id: int) -> SupplierModel:
        """Gets supplier by its id

        Args:
            supplier_id (int): supplier id

        Returns:
            SupplierModel: found supplier
        """

        return SupplierModel.get_one_filtered([
            SupplierModel.supplier_id == supplier_id
        ])

    @staticmethod
    def get_one_by_phone(phone: str) -> SupplierModel:
        """Gets supplier by its phone

        Args:
            phone (str): Supplier phone

        Returns:
            SupplierModel: found supplier
        """

        # TODO: test

        return SupplierModel.get_one_filtered([
            SupplierModel.phone == phone
        ])

    @staticmethod
    def create_if_not_created(supplier_data: dict) -> SupplierModel:
        """Creates new supplier if supplier doesn't exist"""

        if not SupplierModel.get_one_filtered([
            SupplierModel.supplier_id == supplier_data.get('supplier_id'),
        ]):
            supplier = SupplierModel(supplier_data)
            supplier.save()

            return supplier

        return None
