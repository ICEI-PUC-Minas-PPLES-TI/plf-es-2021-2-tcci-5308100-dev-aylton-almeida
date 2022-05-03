from dataclasses import dataclass
from typing import Optional


@dataclass(frozen=True)
class Address:

    city_name: str
    country_state: str
    street_name: str
    street_number: str
    postal_code: str
    neighborhood_name: str
    unit_number: Optional[str] = None
