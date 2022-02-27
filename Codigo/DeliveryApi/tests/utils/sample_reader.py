import json
from pathlib import Path


def get_sample(name: str):
    """Get JSON data from samples file

    Args:
        name (str): file name

    Returns:
        any: JSON file content
    """

    data = None
    path = Path(__file__).parent / "samples/{}.json".format(name)
    with open(path, encoding='utf-8') as f:
        data = json.load(f)

    return data
