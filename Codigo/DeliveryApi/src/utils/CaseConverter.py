from functools import reduce
from typing import Callable, Union


def to_snake_case(word: str):
    """Converts word to snake case

    Args:
        word (str): Word in camel case

    Returns:
        str: Word in snake case
    """

    return reduce(
        lambda x, y: x + ('_' if y.isupper() else '') + y,
        word,
        ''
    ).lower()


def to_camel_case(word):
    """Converts word to camel case

    Args:
        word (str): Word in snake case

    Returns:
        str: Word in camel case
    """

    components = word.split('_')
    return components[0] + ''.join(x.title() for x in components[1:])


def convert_to_case(data: Union[dict, list], case_callback: Callable):
    """Converts complex dict or list to the given case converter

    Args:
        data (list or dict or str): Data to be converted
        case_callback (Callable): Conversor function

    Returns:
        list or dict or str: The given data converted
    """

    if isinstance(data, list):
        return [convert_to_case(item, case_callback) for item in data]

    if isinstance(data, dict):
        return {case_callback(key): convert_to_case(value, case_callback)
                for (key, value) in data.items()}

    return data
