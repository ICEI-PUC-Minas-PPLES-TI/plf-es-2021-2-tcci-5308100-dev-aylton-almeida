import string
from secrets import choice


def generate_secret_code(n: int) -> str:
    """Generates a random secret code of size n."""

    return ''.join([choice(string.ascii_uppercase + string.digits) for _ in range(n)])
