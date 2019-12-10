#export ID=411B2ED2-8B75-4A73-9EB0-68F8ECE92771
export CLUSTER=cluster
export BUCKET=routecloud.com.br
export ZONE=us-east-1a
export ID=$(uuidgen)

aws s3api create-bucket --bucket $BUCKET
aws s3api put-bucket-versioning --bucket $BUCKET --versioning-configuration Status=Enabled
#aws route53 create-hosted-zone --name $BUCKET --caller-reference $ID

kops create cluster --name $BUCKET --zones $ZONE --state s3://$BUCKET

kops update cluster --name $BUCKET --state s3://$BUCKET --yes

# Update Cluster Node Counte
# kops edit instancegroup nodes --state s3://routecloud.com.br
# kops rolling-update cluster --state s3://routecloud.com.br

#kops create cluster --name $BUCKET --zones $ZONE --state s3://$BUCKET --node-count=0 --yes

#aws iam create-service-linked-role --aws-service-name "elasticloadbalancing.amazonaws.com"
