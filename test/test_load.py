from src.load import lambda_handler


def test_builds_folder_file_structure():
    result = lambda_handler(
        {"eur": {"rate": 1.08241001, "reverse_rate": 0.923864}}, None
    )
    assert result == {"result": "Success"}
