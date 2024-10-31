import logging
import boto3
from datetime import datetime
import json

logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3 = boto3.client("s3")
bucket = "nc-de-currency-data-20241031102858327800000004"


def lambda_handler(event, context):
    """Writes the data to a date-encoded S3 folder.

    The folder structure should make it easy to locate rates from a given date and time.

    Args:
        event: dictionary in the same format as the output from the transform function
        context: supplied by AWS

    Returns:
        dictionary, either {'result': 'Success'} if successful or {'result': 'Failure'} otherwise
    """

    if event:
        base_currency = list(event.keys())[0]

        folder = datetime.now().strftime("%Y-%m-%d")
        timestamp = datetime.now().strftime("%H-%M-%S")
        file = f"{base_currency}_to_usd_{timestamp}.json"

        key = f"{folder}/{file}"

        s3.put_object(
            Bucket=bucket,
            Key=key,
            Body=json.dumps(event),
            ContentType="application/json",
        )

        logger.info(f"Currency rates saved to the data bucket filepath: {key}")
        return {"result": "Success"}
    else:
        logger.info("Unable to save currency rates")
        return {"result": "Failure"}
