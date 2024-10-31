from src.extract import lambda_handler as extract_lambda_handler
from src.transform import lambda_handler as transform_lambda_handler


def test_isolates_eur_to_usd_rate():
    extract_result = extract_lambda_handler(None, None)
    if extract_result:
        transform_result = transform_lambda_handler(extract_result, None)

        base_currency = list(transform_result.keys())[0]
        assert base_currency == "eur"

        rates = list(transform_result[base_currency].keys())
        assert rates[0] == "rate"
        assert rates[1] == "reverse_rate"

        base_to_usd_rate = extract_result[base_currency]["usd"]
        assert transform_result["eur"]["rate"] == base_to_usd_rate

        reverse_rate = round((1 / base_to_usd_rate), 6)
        assert transform_result["eur"]["reverse_rate"] == reverse_rate
