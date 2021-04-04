# scp-chroot-efs-example

chrootなsftp環境をEFS上で作成するサンプルのTerraform

## Usage

### tfstate用S3バケットの作成

tfstate用S3バケットを作成しておく。バケット名は適宜変更。

```
aws s3 mb s3://scp-chroot-example-tfstate --region ap-northeast-1
aws s3api put-bucket-versioning --bucket scp-chroot-example-tfstate --versioning-configuration Status=Enabled
aws s3api get-bucket-versioning --bucket scp-chroot-example-tfstate
```

terraform実行

```
cd envs/development
terraform init
terraform apply
```

## ToDo

- chrootなsftpが設定されたec2インスタンスの作成
- 上記のAMI
- auto scaling
- NLB