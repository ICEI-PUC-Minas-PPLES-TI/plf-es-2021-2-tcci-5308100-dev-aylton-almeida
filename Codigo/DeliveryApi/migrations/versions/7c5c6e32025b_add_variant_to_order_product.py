"""add variant to order product

Revision ID: 7c5c6e32025b
Revises: 9725f4897aeb
Create Date: 2022-03-24 21:12:11.420859

"""
import sqlalchemy as sa
from alembic import op

# revision identifiers, used by Alembic.
revision = '7c5c6e32025b'
down_revision = '9725f4897aeb'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('delivery_order_products', sa.Column(
        'variant', sa.String(length=500), nullable=True))
    op.execute("UPDATE delivery_order_products SET variant = ''")
    op.alter_column('delivery_order_products', 'variant', nullable=False)
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_column('delivery_order_products', 'variant')
    # ### end Alembic commands ###
