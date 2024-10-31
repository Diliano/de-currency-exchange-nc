import requests
import logging


logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    """Extracts the latest currency data from the API.

    In the first instance, the function only needs to extract the EUR/USD rate.

    Args:
        event: an empty dictionary
        context: context object provided by AWS

    Returns:
        dictionary e.g.
        {
                "date": "2024-07-30",
                "eur": {
                        "gbp": 0.84175906,
                        "jpy": 166.80563884,
                        "usd": 1.08167213,
            ...
                        }
        }
    """

    url = "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/eur.json"
    response = requests.get(url)

    if response.status_code == 200:
        data = response.json()
        base_currency = list(data.keys())[1]

        logger.info(f"HTTP Status: {response.status_code}")
        logger.info(
            f"""Currency list extracted for date: {data["date"]} and currency: {base_currency}"""
        )
        return data
    else:
        logger.info(f"HTTP Status: {response.status_code}")
