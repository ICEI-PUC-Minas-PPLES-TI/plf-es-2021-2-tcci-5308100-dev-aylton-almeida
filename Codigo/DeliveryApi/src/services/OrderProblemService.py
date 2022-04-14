from abc import ABC
from typing import Optional
from uuid import UUID

from src.classes.ProblemType import ProblemType
from src.models.OrderProblemModel import OrderProblemModel


class OrderProblemService(ABC):

    @staticmethod
    def create_problem(
        order_id: UUID,
        problem_type: ProblemType,
        description: Optional[str] = None,
        commit=True,
    ) -> OrderProblemModel:
        """Gets one order given its id"""

        order_problem = OrderProblemModel({
            'order_id': order_id,
            'type': problem_type.name,
            'description': description
        })

        order_problem.save(commit)

        return order_problem
