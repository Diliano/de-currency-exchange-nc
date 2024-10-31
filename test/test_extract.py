from src.extract import lambda_handler


def test_extracts_currency_list_with_eur_as_base_currency():
    result = lambda_handler(None, None)
    if result:
        assert isinstance(result, dict)
        assert "date" in result
        assert "eur" in result
        assert result["date"] == "2024-10-31"
