from abc import ABC
from datetime import time

from src.libs.maps import get_directions
from src.models.DeliveryModel import DeliveryModel
from src.models.DeliveryRouteAddressModel import DeliveryRouteAddressModel
from src.models.DeliveryRouteModel import DeliveryRouteModel
from src.utils.TimeUtils import seconds_to_time


class DeliveryRouteService(ABC):

    @staticmethod
    def create_from_delivery(delivery: DeliveryModel) -> DeliveryRouteModel:
        """Creates new delivery route from a delivery"""

        delivery_route = DeliveryRouteModel({
            'delivery_id': delivery.delivery_id,
        })

        for order in delivery.orders:
            route_address = DeliveryRouteAddressModel({
                'address_id': order.shipping_address.address_id,
            })
            route_address.address = order.shipping_address
            delivery_route.addresses = [
                *delivery_route.addresses,
                route_address
            ]

        delivery_route.estimate_time = DeliveryRouteService.optimize_route(
            delivery_route)

        return delivery_route

    @staticmethod
    def optimize_route(delivery_route: DeliveryRouteModel) -> time:
        """Optimizes given delivery route, returning estimate time"""

        origin = delivery_route.addresses[0].address.get_lat_lng()
        waypoints = [
            route_address.address.get_lat_lng()
            for route_address in delivery_route.addresses[1:]
        ]

        directions = get_directions(origin, origin, waypoints)

        if directions:

            route_order = directions[0].get('waypoint_order')
            delivery_route.addresses[0].position = 0
            for i, item in enumerate(route_order):
                delivery_route.addresses[item + 1].position = i + 1

            total_seconds = sum(
                [item['duration']['value']for item in directions[0]['legs']]
            )

            return seconds_to_time(total_seconds)

        return time(0)
