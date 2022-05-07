from unittest.mock import MagicMock, patch

from src.models.AddressModel import AddressModel
from tests.utils.models.BaseTest import BaseTest


class AddressModelTests(BaseTest):

    @patch.object(AddressModel, 'set_lat_lng')
    def test_Constructor_when_LatAndLngPresent(self, mock_set_lat_lng: MagicMock):
        """Test constructor when lat and lng are present in payload"""

        # when
        data = {
            'street_name': 'Street X',
            'lat': 1.0,
            'lng': 2.0
        }

        # then
        address_model = AddressModel(data)

        # assert
        self.assertEqual(address_model.street_name, data.get('street_name'))
        mock_set_lat_lng.assert_not_called()

    @patch.object(AddressModel, 'set_lat_lng')
    def test_Constructor_when_LatAndLngNotPresent(self, mock_set_lat_lng: MagicMock):
        """Test constructor when lat and lng are not present in payload"""

        # when
        data = {
            'street_name': 'Street X'
        }

        # then
        address_model = AddressModel(data)

        # assert
        self.assertEqual(address_model.street_name, data.get('street_name'))
        mock_set_lat_lng.assert_called_once_with()

    @patch('src.models.AddressModel.get_lat_lng_from_address')
    def test_SetLatLngFromAddress_when_Default(self, mock_get_lat_lng_from_address: MagicMock):
        """Test set_lat_lng_from_address when default behavior"""

        # when
        address = AddressModel({'street_name': 'Street X'})
        # Resets first call because of constructor
        mock_get_lat_lng_from_address.reset_mock()
        lat_lng = {
            'lat': 1.0,
            'lng': 2.0
        }

        # mock
        mock_get_lat_lng_from_address.return_value = lat_lng

        # then
        address.set_lat_lng()

        # assert
        self.assertEqual(address.lat, lat_lng.get('lat'))
        self.assertEqual(address.lng, lat_lng.get('lng'))
        mock_get_lat_lng_from_address.assert_called_once_with(address)

    def test_GetLatLng_when_Default(self):
        """Teste get_lat_lng when default behavior"""

        # when
        address = AddressModel({
            'lat': 1.0,
            'lng': 2.0
        })

        # then
        lat, lng = address.get_lat_lng()

        # assert
        self.assertEqual(lat, address.lat)
        self.assertEqual(lng, address.lng)

    def test_ToAddress_when_Default(self):
        """Test to_address when default behavior"""

        # when
        data = {
            'city_name': 'City X',
            'street_name': 'Street X',
            'street_number': '1',
            'unit_number': '123',
            'neighborhood_name': 'Neighborhood X',
            'country_state': 'State',
            'postal_code': '12345-678',

        }
        address = AddressModel(
            data | {
                'lat': 1.0,
                'lng': 2.0
            }
        )

        # then
        response = address.to_address()

        # assert
        for key, value in data.items():
            self.assertEqual(getattr(response, key), value)
