from src.classes.Role import Role
from tests.utils.models.BaseTest import BaseTest


class RoleTests(BaseTest):

    def test_GetAuthorizedRoles_when_Admin(self):
        """Test get authorized roles when user is admin.
            It should return both deliverer and supplier roles
        """

        # when
        current_role = Role.admin

        # then
        response = current_role.get_authorized_roles()

        # assert
        self.assertIn(Role.deliverer, response)
        self.assertIn(Role.supplier, response)
