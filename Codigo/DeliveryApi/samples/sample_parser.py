import json
import random

import names


def main():
    """Main function"""

    sample_file = input(
        'Which offer sample file would you like to parse?(Type only the number) ')

    sample = None
    with open(f'offerSample{sample_file}.json', 'r', encoding='utf-8') as f:
        sample = json.load(f)

    parse_data(sample)

    with open(f'offerSample{sample_file}.json', 'w', encoding='utf-8') as f:
        json.dump(sample, f, ensure_ascii=False, indent=2)


def generate_phone():
    """Generates random phone number"""

    # printing the number
    return f'+55119{"".join([str(random.randint(0, 9)) for _ in range(8)])}'


def generate_cnpj():
    """Generates a random CNPJ"""
    n = [random.randrange(10) for i in range(8)] + [0, 0, 0, 1]
    v = [2, 3, 4, 5, 6, 7, 8, 9, 2, 3, 4, 5, 6]
    # calcula dígito 1 e acrescenta ao total
    s = sum(x * y for x, y in zip(reversed(n), v))
    d1 = 11 - s % 11
    if d1 >= 10:
        d1 = 0
    n.append(d1)
    # idem para o dígito 2
    s = sum(x * y for x, y in zip(reversed(n), v))
    d2 = 11 - s % 11
    if d2 >= 10:
        d2 = 0
    n.append(d2)
    return "%d%d%d%d%d%d%d%d%d%d%d%d%d%d" % tuple(n)


def parse_secret_fields(key: str, value: any):
    """Parses secret fields"""

    if key == 'legalId':
        return generate_cnpj()
    if key == 'name':
        return names.get_full_name()
    if key == 'phone':
        return generate_phone()

    return value


def parse_order(order: dict):
    """Parse order data"""

    # Parse order buyer
    order['buyer'] = {
        key: parse_secret_fields(key, value)
        for key, value in order['buyer'].items()
        if key in ('name')
    }

    # Parse transaction
    order['transaction'] = {
        'status': order['transaction']['status'],
    }

    return order


def parse_data(sample: dict):
    """Parses sample data"""

    # Parse supplier data
    sample['supplier'] = {
        key: parse_secret_fields(key, value)
        for key, value in sample['supplier'].items()
        if key in ('legalId', 'name', 'phone', 'supplierId')
    }

    # Rename offer
    sample['name'] = f"Compra em grupo {sample['supplier']['name']}"

    # Parse orders
    sample['orders'] = [parse_order(order) for order in sample['orders']]


if __name__ == '__main__':
    main()
