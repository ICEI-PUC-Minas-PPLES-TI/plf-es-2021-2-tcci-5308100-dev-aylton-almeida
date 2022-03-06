from enum import Enum, auto


class Role(Enum):
    any = auto()
    deliverer = auto()
    supplier = auto()

    def __str__(self) -> str:
        return str(self.name)

    def get_authorized_roles(self):
        """Returns authorized roles for the current role"""

        return [self, Role.any]
