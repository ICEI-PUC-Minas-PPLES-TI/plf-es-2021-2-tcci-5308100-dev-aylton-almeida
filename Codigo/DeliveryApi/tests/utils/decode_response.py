import json


def decode_response(data: bytes):
    return json.loads(data.decode('utf-8'))
