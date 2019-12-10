export CLUSTER=cluster
export BUCKET=routecloud.com.br
export ZONE=us-east-1a
export ID=$(uuidgen)

# aws s3api create-bucket --bucket $BUCKET

kops create cluster --name $BUCKET --zones $ZONE --state s3://$BUCKET --node-count=0

kops create ig nodes --name $BUCKET --state s3://$BUCKET
kops create ig monitoring --name $BUCKET --state s3://$BUCKET
kops create ig web --name $BUCKET --state s3://$BUCKET
kops create ig db --name $BUCKET --state s3://$BUCKET
kops create ig kubow --name $BUCKET --state s3://$BUCKET

#aws iam create-service-linked-role --aws-service-name "elasticloadbalancing.amazonaws.com"