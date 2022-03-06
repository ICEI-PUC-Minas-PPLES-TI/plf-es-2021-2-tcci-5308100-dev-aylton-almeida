from enum import Enum, auto


class Role(Enum):
    deliverer = auto()
    supplier = auto()
    admin = auto()

    def __str__(self) -> str:
        return str(self.name)

    def get_authorized_roles(self):
        """Returns authorized roles for the current role"""

        # TODO: test

        if self == Role.admin:
            return [Role.deliverer]

        return [self]
