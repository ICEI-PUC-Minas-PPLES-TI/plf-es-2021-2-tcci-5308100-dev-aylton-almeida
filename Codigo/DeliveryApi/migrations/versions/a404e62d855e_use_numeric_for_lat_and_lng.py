"""use numeric for lat and lng

Revision ID: a404e62d855e
Revises: 820944d58261
Create Date: 2022-02-23 20:52:42.508152

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'a404e62d855e'
down_revision = '820944d58261'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.alter_column('delivery_addresses', 'lat',
               existing_type=sa.REAL(),
               type_=sa.Numeric(),
               existing_nullable=True)
    op.alter_column('delivery_addresses', 'lng',
               existing_type=sa.REAL(),
               type_=sa.Numeric(),
               existing_nullable=True)
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.alter_column('delivery_addresses', 'lng',
               existing_type=sa.Numeric(),
               type_=sa.REAL(),
               existing_nullable=True)
    op.alter_column('delivery_addresses', 'lat',
               existing_type=sa.Numeric(),
               type_=sa.REAL(),
               existing_nullable=True)
    # ### end Alembic commands ###
