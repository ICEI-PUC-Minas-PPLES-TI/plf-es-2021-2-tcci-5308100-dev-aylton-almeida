from enum import Enum, auto


class DeliveryStatus(Enum):
    created = auto()
    in_progress = auto()
    finished = auto()
