from project import (
    get_name,
    get_required_points,
    get_required_legs,
    get_throw,
    calculate_score,
    get_final_darts,
)
from unittest.mock import patch


@patch("builtins.input")
def test_get_name(mocked_input):
    mocked_input.side_effect = ["Tim"]
    assert get_name("Player 1") == "Tim"
    mocked_input.side_effect = ["", "Tim"]
    assert get_name("Player 1") == "Tim"


@patch("builtins.input")
def test_get_required_points(mocked_input):
    mocked_input.side_effect = [501]
    assert get_required_points() == 501
    mocked_input.side_effect = ["cat", 501]
    assert get_required_points() == 501
    mocked_input.side_effect = [1, 501]
    assert get_required_points() == 501
    mocked_input.side_effect = [0, 1, 501]
    assert get_required_points() == 501


@patch("builtins.input")
def test_get_required_legs(mocked_input):
    mocked_input.side_effect = [1]
    assert get_required_legs() == 1
    mocked_input.side_effect = [100]
    assert get_required_legs() == 100
    mocked_input.side_effect = [0, 0, 5]
    assert get_required_legs() == 5
    mocked_input.side_effect = ["cat", 3]
    assert get_required_legs() == 3


@patch("builtins.input")
def test_get_throw(mocked_input):
    mocked_input.side_effect = [180]
    assert get_throw() == 180
    mocked_input.side_effect = [0]
    assert get_throw() == 0
    mocked_input.side_effect = [200, 100]
    assert get_throw() == 100
    mocked_input.side_effect = [163, 169, 175, 179, 180]
    assert get_throw() == 180
    mocked_input.side_effect = ["cat", 50]
    assert get_throw() == 50


def test_calculate_score():
    assert calculate_score(501, 50) == 50
    assert calculate_score(100, 100) == 100
    assert calculate_score(100, 180) == 0
    assert calculate_score(159, 159) == 0
    assert calculate_score(180, 180) == 0
    assert calculate_score(159, 158) == 0
    assert calculate_score(40, 39) == 0


@patch("builtins.input")
def test_get_final_darts(mocked_input):
    assert get_final_darts(99, "player") == 3
    assert get_final_darts(130, "player") == 3
    assert get_final_darts(170, "player") == 3
    mocked_input.side_effect = [2]
    assert get_final_darts(20, "player") == 2
    mocked_input.side_effect = [4, 3]
    assert get_final_darts(40, "player") == 3
    mocked_input.side_effect = [0, 1]
    assert get_final_darts(32, "player") == 1
    mocked_input.side_effect = [1, 2]
    assert get_final_darts(60, "player") == 2
