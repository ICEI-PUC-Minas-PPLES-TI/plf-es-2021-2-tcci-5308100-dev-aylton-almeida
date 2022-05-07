from dataclasses import dataclass
from time import time
from uuid import UUID

from src.classes.dataclasses.Address import Address
from src.classes.ProblemType import ProblemType


@dataclass(frozen=True)
class ReportItem:

    deliverer_phone: str
    offer_id: UUID
    product_id: str
    address: Address
    hour: time
    problem_type: ProblemType
    obs: str

    def to_xlsx_row(self):
        """Converts to xlsx row"""

        return {
            'Entregador': self.deliverer_phone,
            'Oferta': self.offer_id,
            'Produto': self.product_id,
            'Endereço': self.address,
            'Hora': self.hour,
            'Tipo Problema': self.problem_type,
            'Obs': self.obs,
        }

    @staticmethod
    def get_xlsx_headers():
        """Returns xlsx headers"""

        return [
            'Entregador',
            'Oferta',
            'Produto',
            'Endereço',
            'Hora',
            'Tipo Problema',
            'Obs'
        ]
