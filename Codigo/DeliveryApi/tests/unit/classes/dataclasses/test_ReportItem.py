from datetime import datetime
from uuid import uuid4

from src.classes.dataclasses.Address import Address
from src.classes.dataclasses.ReportItem import ReportItem
from src.classes.ProblemType import ProblemType
from tests.utils.models.BaseTest import BaseTest


class ReportItemTests(BaseTest):

    def test_ToXlSXRow_when_Default(self):
        """Test to_xlsx_row when default behavior"""

        # when
        report_item = ReportItem(
            'phone123',
            uuid4(),
            1,
            Address(
                city_name='City X',
                street_name='Street X',
                street_number='1',
                unit_number='123',
                neighborhood_name='Neighborhood X',
                country_state='State',
                postal_code='12345-678',
            ),
            datetime.now().time(),
            ProblemType.absent_receiver,
            'Não achei o dono da casa'
        )

        # then
        response = report_item.to_xlsx_row()

        # assert
        self.assertDictEqual(response, {
            'Entregador': report_item.deliverer_phone,
            'Oferta': report_item.offer_id,
            'Produto': report_item.product_id,
            'Endereço': report_item.address,
            'Hora': report_item.hour,
            'Tipo Problema': report_item.problem_type,
            'Obs': report_item.obs,
        })
