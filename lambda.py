""""
 A sample implementation of a Lambda function that is expected to be invoked
 by creation of an *.csv file in a specific S3 bucket. The function compresses
 it and writes the compressed data into another file in the S3 bucket. The
 function usess SNAPPY compression https://github.com/google/snappy and
 https://github.com/andrix/python-snappy.

 The intent is to demonstrate how to build dependencies and the function
 into a zip file targeting the AWS Lambda runtime, and deploy it to AWS
 using Terraform.

"""
import json
import urllib
import csv
import boto3
import zlib


def lambda_handler(event, context):
    """
    Lambda event handler.

    This function will be invoked by AWS when an object is created in the
    configured S3 bucket.

    Parameters
    ----------
    See AWS Lambda documentation for meaning of these parameters.

    """
    # Get the object from the event and show its content type
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.unquote_plus(event['Records'][0]['s3']['object']['key'].encode('utf8'))

    # read the content, compress it and write it to another file
    s3_compress(bucket, key)


def s3_compress(bucket, object):
    """
    Sample function that retrieves content of a file in an S3 bucket,
    compresses it with the snappy compression algorithm, and saves it
    to another file in the same S3 bucket.

    Parameters
    ----------
    bucket : str
        Name of the bucket where the file is located

    object : str
        Name of the file to be compressed

    """
    s3 = boto3.resource('s3')
    fileobj = s3.Object(bucket, object).get()['Body']
    archive = ''

    while True:
        buffer = fileobj.read(1024)
        if not buffer:
            break

        # TODO add chunking/framing in so that larger files can be compressed
        archive = archive + buffer

    archive = zlib.compress(archive)
    new_name = "%s.zlib" % object
    client = boto3.client('s3')
    client.put_object(Bucket=bucket, Key=new_name, ContentType='application/zlib', Body=archive)


if __name__ == '__main__':
    # For local testing and development
    # It assumes that you have AWS key/secret configured locally
    s3_compress('my-lambda-test-123', 'mlb-stats.csv')
