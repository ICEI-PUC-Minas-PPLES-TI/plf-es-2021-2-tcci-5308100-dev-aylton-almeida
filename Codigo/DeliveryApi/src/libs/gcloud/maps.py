import os

from googlemaps import Client
from werkzeug.exceptions import NotFound

g_cloud_api_key = os.getenv('G_CLOUD_API_KEY')


def get_lat_lng_from_address(address: str):
    """Gets lat/lng from address"""

    gmaps = Client(key=g_cloud_api_key)

    geocode_result = gmaps.geocode(address)

    if not geocode_result:
        raise NotFound(f'Address not found: {address}')

    return geocode_result[0]['geometry']['location']
