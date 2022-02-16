# SERVERLESS APP USING TERRAFORM TO AWS

## Requirements

### Install aws cli
Follow this [guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) to install aws cli based on your operative system
### Install terraform cli
Follow this [guide](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started) to install terraform based on your operative system

### Check if everything is installed
```console
  $> terraform -v
  $> aws --version
```

## Usage
### Initialize the project and prepare your working directory for other commands
```console
  $> terraform init
```
### Show changes required by the current configuration
```console
  $> terraform plan
```
### Create or update infrastructure
```console
  $> terraform apply
```

### Get tasks
After the infrastructure was created or updated to aws console and select Lambda service.
Click on `get-tasks` function and the dashboard of function will be shown.
Now select the api gateway and get your `Api Endpoint`.
Once you have the API Endpoint run:
```console
  $> curl <api_endpoint>
```

### Post task
After the infrastructure was created or updated to aws console and select Lambda service.
Click on `post-task` function and the dashboard of function will be shown.
Now select the api gateway and get your `Api Endpoint`.
Go to API Gateway server and select `post-task-api-gateway`, once you are in the `post-task-api-gateway` page go to `API Keys` and click `gw_api_key`. 
Show your API key.

Now with postmap or another tool create your request:

```console
  $> curl --location --request POST '<api_endpoint>' \
  --header 'x-api-key: <api_key>' \
  --header 'Content-Type: application/json' \
  --data-raw '{
      "id": "1",
      "name": "Mohamed",
      "views": "1"
  }'
```

### Destroy previously-created infrastructure
```console
  $> terraform destroy
```
### In case you modify the source code of lambda functions
In case you modify the source code of lambda functions remember to zip the new source code.
```console
  $> zip -vr -j lambda-get.zip lambda-get/* -x "*.DS_Store"
  $> zip -vr -j lambda-post.zip lambda-post/* -x "*.DS_Store"
```
And then update the infrastructure

## Architecture

![Serverless architecture](/images/serveless.drawio.png)