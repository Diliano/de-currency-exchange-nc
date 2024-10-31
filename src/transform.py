import logging


logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    """Transforms the data to give the required rates against USD.

    The output should include the reverse rate to 6 decimal places.

    Args:
        event: a dictionary in the form output by the extract function.
        context: supplied by AWS

    Returns:
        dictionary e.g. {
            "eur": {
                "rate": 1.08167213,
                "reverse_rate": 0.924495
            }
        }

    """

    if event:
        base_currency = list(event.keys())[1]

        base_to_usd_rate = event[base_currency]["usd"]
        reverse_rate = round((1 / base_to_usd_rate), 6)

        logger.info(f"Success: {base_currency} to usd rate and reverse_rate calculated")

        return {base_currency: {"rate": base_to_usd_rate, "reverse_rate": reverse_rate}}
