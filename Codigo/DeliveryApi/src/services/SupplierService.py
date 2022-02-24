from abc import ABC

from src.models.SupplierModel import SupplierModel


class SupplierService(ABC):

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
