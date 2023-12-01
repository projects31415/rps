alias tf=terraform

# Prereqs

## yc cli https://cloud.yandex.com/en-ru/docs/cli/quickstart
## aws cli https://cloud.yandex.ru/docs/storage/tools/aws-cli
## terraform https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

## list existing yandex folders
```console
yc resource-manager folder list
```
## save folder id to env var
```console
export _YANDEX_FOLDER_ID=<folder-id>
```
## terraform service account

### create terraform service acc for managing s3 bucket, dynamo db table and other resources
```console
yc iam service-account create --name terraform --folder-id ${_YANDEX_FOLDER_ID}
```

## save terraform service acc id to env var
```console
export _TERRAFORM_SERVICE_ACC_ID=<terraform-acc-id>
```

### assign admin role to terraform service acc
```console
yc resource-manager folder add-access-binding ${_YANDEX_FOLDER_ID} --role admin --subject serviceAccount:${_TERRAFORM_SERVICE_ACC_ID}
```
### create authorization key for terraform service account:
```console
yc iam key create \
  --service-account-id ${_TERRAFORM_SERVICE_ACC_ID} \
  --folder-id ${_YANDEX_FOLDER_ID} \
  --description 'for terraform cli' \
  --output terraform/credentials.json
```


## terraform-tfstate service account


### create terraform-tfstate service for access to tfstate and tfstate locks
```console
yc iam service-account create --name terraform-tfstate --folder-id ${_YANDEX_FOLDER_ID}
```

## save terraform-tfstate service acc id to env var
```console
export _TERRAFORM_TFSTATE_SERVICE_ACC_ID=<terraform-state-acc-id>
```

## assign storage.editor and ydb.editor role to terraform-tfstate service acc
```console
yc resource-manager folder add-access-binding ${_YANDEX_FOLDER_ID} --role storage.editor --subject serviceAccount:${_TERRAFORM_TFSTATE_SERVICE_ACC_ID}
yc resource-manager folder add-access-binding ${_YANDEX_FOLDER_ID} --role ydb.editor --subject serviceAccount:${_TERRAFORM_TFSTATE_SERVICE_ACC_ID}
```
## create static access key for terraform-tfstate acc to access tfstate files in s3 storage
```console
yc iam access-key create --service-account-id ${_TERRAFORM_TFSTATE_SERVICE_ACC_ID} --description 'access to tfstate in s3 storage and tfstate locks in yandex db'
```
Example output
```
access_key:
  id: aj…5f
  service_account_id: aj…ar
  created_at: "2099-01-01T00:00:00.000000001Z"
  description: access to s3 storage
  key_id: YC…_7C
secret: YC…v9
```
## create credentials file
```console
cp -n $(git rev-parse --show-toplevel)/terraform/credentials.example $(git rev-parse --show-toplevel)/terraform/credentials
```
add values of «key_id» and «secret» to credentials (./terraform/credentials) and to aws credentials (~/.aws/credentials)


Example credentials file content:
```
[yandex]
aws_access_key_id=YC…_7C
aws_secret_access_key=YC…v9
```

## temporary change tf backend to local
```console
cd $(git rev-parse --show-toplevel)/terraform/s3_backend
sed -i 's/backend "s3" {/backend "local" {/g' main.tf
```

## create s3 backend and yandex db
```console
tf init
tf plan -out=tfplan
tf apply tfplan
rm tfplan
```

## get yandex db endpoint (document_api_endpoint)
```console
yc ydb database get <yandex-db-name>
```

## save yandex db endpoint(dynamodb_endpoint=https://docapi.serverless.yandexcloud.net/…) to  ./terraform/s3_backend_common.tfbackend


## set env_var with a location of creds file for aws cli tool
```console
export AWS_SHARED_CREDENTIALS_FILE=$(pwd)/../credentials
```

## create yandex db «tf_locks» table
```console
aws dynamodb create-table \
  --table-name tf_locks \
  --attribute-definitions \
    AttributeName=LockID,AttributeType=S \
  --key-schema \
    AttributeName=LockID,KeyType=HASH \
  --endpoint $(tf output -raw tf_state_lock_endpoint) \
  --profile tf-state-acc \
  --region ru-central1
```

## move local tf state to s3 bucket
```console
sed -i 's/backend "local" {/backend "s3" {/g' main.tf
tf init -backend-config=$(git rev-parse --show-toplevel)/terraform/s3_backend_common.tfbackend -backend-config=s3_backend.tfbackend -migrate-state
rm terraform.tfstate
```
