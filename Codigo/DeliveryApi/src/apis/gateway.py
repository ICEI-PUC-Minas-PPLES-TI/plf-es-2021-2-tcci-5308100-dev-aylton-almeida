from multi_key_dict import multi_key_dict

from .AuthApi import AuthApi


class Gateway:

    service: multi_key_dict

    def __init__(self):
        self.service = multi_key_dict()
        self.service['auth'] = AuthApi()


gateway = Gateway()
