from unittest.mock import MagicMock, patch

from werkzeug.exceptions import NotFound

from src.libs.maps import get_directions, get_lat_lng_from_address
from tests.utils.models.BaseTest import BaseTest


class MapsTests(BaseTest):

    @patch('src.libs.maps.Client')
    def test_GetLatLngFromAddress_when_LocationFound(self, mock_client: MagicMock):
        """Test get_lat_lng_from_address when location was found"""

        # when
        address = 'rua xyz 123'
        geolocation_response = [{
            'geometry': {'location': {
                'lat': 1,
                'lng': 2,
            }}
        }]

        # mock
        mock_client.return_value.geocode.return_value = geolocation_response

        # then
        response = get_lat_lng_from_address(address)

        # assert
        self.assertEqual(response.get('lat'), 1)
        self.assertEqual(response.get('lng'), 2)
        mock_client.return_value.geocode.assert_called_once_with(address)

    @patch('src.libs.maps.Client')
    def test_GetLatLngFromAddress_when_LocationNotFound(self, mock_client: MagicMock):
        """Test get_lat_lng_from_address when location was not found"""

        # when
        address = 'rua xyz 123'
        geolocation_response = []

        # mock
        mock_client.return_value.geocode.return_value = geolocation_response

        # then
        with self.assertRaises(NotFound) as err:
            get_lat_lng_from_address(address)

        # assert
        self.assertEqual(str(err.exception),
                         f'404 Not Found: Address not found: {address}')
        mock_client.return_value.geocode.assert_called_once_with(address)

    @patch('src.libs.maps.Client')
    def test_GetDirections_when_Default(self, mock_client: MagicMock):
        """Test get_directions when default behavior"""

        # when
        origin = 'rua xyz 123'
        destination = 'rua xyz 456'
        waypoints = [
            'rua xyz 789',
            'rua xyz 101112',
        ]
        expected_response = 'valid response'

        # mock
        mock_client.return_value.directions.return_value = expected_response

        # then
        response = get_directions(origin, destination, waypoints)

        # assert
        self.assertEqual(response, expected_response)
        mock_client.return_value.directions.assert_called_once_with(
            origin,
            destination,
            waypoints=waypoints,
            mode='driving',
            alternatives=False,
            optimize_waypoints=True
        )
