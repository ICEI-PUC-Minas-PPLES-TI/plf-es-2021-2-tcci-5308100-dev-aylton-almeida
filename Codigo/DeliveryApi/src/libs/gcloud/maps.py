import json
import os
from typing import Union

from googlemaps import Client
from werkzeug.exceptions import NotFound

g_cloud_api_key = os.getenv('G_CLOUD_API_KEY')


def get_lat_lng_from_address(address):
    """Gets lat/lng from address"""

    gmaps = Client(key=g_cloud_api_key)

    geocode_result = gmaps.geocode(str(address))

    if not geocode_result:
        raise NotFound(f'Address not found: {address}')

    return geocode_result[0]['geometry']['location']


def get_directions(
    origin: Union[str, tuple[float, float]],
    destination:  Union[str, tuple[float, float]],
    waypoints: list[Union[str, tuple[float, float]]],
):
    """Gets directions to given destination from given origin with given waypoints
        All values should be either strings or tuples of floats being lat and lng
    """

    gmaps = Client(key=g_cloud_api_key)

    directions_result = gmaps.directions(
        origin,
        destination,
        waypoints=waypoints,
        mode='driving',
        alternatives=False,
        optimize_waypoints=True
    )

    return directions_result
