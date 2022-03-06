from src.classes.Role import Role
from tests.utils.models.BaseTest import BaseTest


class RoleTests(BaseTest):

    def test_GetAuthorizedRoles_when_Deliverer(self):
        """Test get authorized roles when user is deliverer.
            It should return only deliverer role
        """

        # when
        current_role = Role.deliverer

        # then
        response = current_role.get_authorized_roles()

        # assert
        self.assertIn(Role.deliverer, response)
        self.assertIn(Role.any, response)

    def test_GetAuthorizedRoles_when_Supplier(self):
        """Test get authorized roles when user is supplier.
            It should return only supplier role
        """

        # when
        current_role = Role.supplier

        # then
        response = current_role.get_authorized_roles()

        # assert
        self.assertIn(Role.supplier, response)
        self.assertIn(Role.any, response)
