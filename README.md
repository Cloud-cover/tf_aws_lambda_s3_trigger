# Terraform module: S3 Triggered Lambda

## Overview

Someone recently asked me to create an AWS Lambda function that will execute
when new CSV files are dumped into an S3 bucket. After putting together the python
code of the Lambda and getting it working locally, I proceeded to deploy it.
Since this is a non-trivial process, I decided to write a Terraform module that
I could use across different AWS environments.

## Content

* module - Terraform module to setup S3 bucket, Lambda function and various
IAM roles and policies for the trigger to work and have access to the bucket
* terrafrom.tf - a sample Terraform configuration that shows how to use this
module.
* lambda.py, lambda.py.zip - a sample Python 2.7 implementation of a lambda
function that reads/writes from/to the S3 bucket
* requirements.txt - Python libraries needed for this to work

## Local Development

The actual provided code of the Lambda function is not intended to be production
ready implementation. I made up the functionality so that I have some code to
deploy in order to demonstrate the Terraform module functionality!

If you want to run the code locally, you will need to make sure that you have
AWS CLI configuration setup in your local environment so that the Boto3 library
can authenticate to your AWS account.

You will also need to setup your virtualenv:

```
$ cd my_project_folder
$ virtualenv my_project
```

After that you need to activate the virtualenv:

`$ source my_project/bin/activate`

Once activated you will need to install the required libraries:

`$ pip install -r requirements.txt`

See this for more details: http://docs.python-guide.org/en/latest/dev/virtualenvs/

Note that the following code in the lambda.py assumes that you have read/write
access to the `my-lambda-test-123` bucket and a test `mlb-stats.csv` file in
your local directory:

```python
if __name__ == '__main__':
    s3_compress('my-lambda-test-123', 'mlb-stats.csv')
```

You may adjust the above code to fit your specific needs should you decide to
use it. After activating your virtualenv you can run the code from a command
prompt with this command:

`$ python lambda.py`

## Deployment

Before deployment, you will need to create a zip file of the Lambda function
implementation and all the required libraries. In this particular case the only
required library is Boto3 (and its dependencies). Since the AWS Python 2.7 runtime
already includes this library, the provided zip file contains only the `lambda.py`
file.

Should your implementation of the lambda function rely on other libraries, you
will need to package them up into the zip file. This could be accomplished by
creating a temporary directory, copying the `lambda.py` file to it, and installing
the dependencies into the directory using the following command, and then zipping
it all up to `lambda.py.zip`:

`$ pip install -r requirements.txt -t temp_dir`  
`$ zip -r lambda.py.zip ./temp_dir/*`

Note however that 3rd party libraries may also contain extension modules written
in C or C++. Chances are that you are developing your lambda function on a Mac
or Windows, and so the extension modules installed into the directory will not
be compiled specifically for `Amazon Linux x86_64` platform. The following is
a nice post on how to work around this:
https://markn.ca/2018/02/python-extension-modules-in-aws-lambda/

In order to deploy this sample, you first need to initialize the working
directory:

`$ terrafrom init`

Once initialize, you create and review the execution plan:

`$ terrafrom plan`

If everything checks out, you can proceed with your deployment:

`$ terraform apply`

## Future Enhancements

The sample `terraform.tf` configuration file could reference the module by git
URL and its version.

The current implementation uses local Terraform state files. Storing the state
files in S3 is more appropriate in almost all circumstances.

Make the lambda runtime configurable via a variable.
