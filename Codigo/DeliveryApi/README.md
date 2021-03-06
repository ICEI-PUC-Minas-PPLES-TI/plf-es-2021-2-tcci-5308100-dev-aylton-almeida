# Delivery API

Api used to manage deliveries for the mobile app

## Structure

- _apis:_ Communication with other internal apis should go here
- _classes:_ Generic classes such as enums go here
- _controllers:_ All route controllers go here
- _events:_ Divided between listen and send, for using with RabbitMQ
- _guards:_ All route guards go here (AuthGuard with cognito is already there)
- _jobs:_ Scheduling jobs
- _libs:_ All your external connections go here, like aws or other libs
- _schemas:_ All your schemas should go here
- _models:_ All your models go here
- _services:_ All your models business logics should go here
- _utils:_ All your utils files go here

## Running

- Install `Python` and `pip` and run the following commands

```bash
  pip install -r requirements.txt && python run.py
```

- On VScode you can simply press `F5` after installing the python extension

## Migrations

```bash
  # Run migrations
  python manage.py db migrate
```

```bash
  # Commit migrations
  python manage.py db upgrade
```

## Testing

```bash
  # Run tests
  python -m unittest discover -s tests -p 'test_*.py'
```
