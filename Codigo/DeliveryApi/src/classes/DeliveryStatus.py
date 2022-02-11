from enum import Enum, auto


class DeliveryStatus(Enum):
    created = auto()
    in_progress = auto()
    finished = auto()

    def __str__(self):
        return str(self.name)
