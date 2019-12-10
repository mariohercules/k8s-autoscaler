export CLUSTER=cluster
export BUCKET=routecloud.com.br
export REGION=us-east-1
export ZONE=us-east-1a

## aws ec2 describe-availability-zones --region $REGION

## aws s3api create-bucket --bucket $BUCKET

## kops create cluster --name $BUCKET --zones $ZONE --state s3://$BUCKET --yes

kops create ig monitoring --role node --name $BUCKET --state s3://$BUCKET
kops create ig web --role node --name $BUCKET --state s3://$BUCKET
kops create ig db --role node --name $BUCKET --state s3://$BUCKET
kops create ig kubow --role node --name $BUCKET --state s3://$BUCKET
# kops create ig nodes --role node --name $BUCKET --state s3://$BUCKET

## kops edit ig --name=$BUCKET --state s3://$BUCKET nodes

#kops create cluster --name $CLUSTER.$BUCKET --zones $REGION --state s3://$BUCKET --yes

#export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
#export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)
#export NAME=EKS_Unifor_Cluster
#export KOPS_STATE_STORE=s3://kops-state-unifor 
#export AWS_SDK_LOAD_CONFIG=1
#export AWS_PROFILE=kops

#export NAME=unifor.k8s.local
#export KOPS_STATE_STORE=s3://k8s-unifor-mario

#kops create cluster --zones us-east-1a --name $NAME --node-count=0
#kops create cluster cloud=aws --zones=us-east-1a --name=apsouth1.hipster.com --dns-zones=apsouth1b.hipster --dns private

#kops create ig monitoring --role node --name $NAME
#kops create ig web --role node --name $NAME
#kops create ig db --role node --name $NAME
#kops create ig kubow --role node --name $NAME
#kops delete ig nodes --name $NAME

#kops update cluster --name $NAME --yes

#routecloud.com.br


# -----------------------------------------------------------------------------

#export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
#export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)
#export NAME=unifor.cluster.k8s.locaL
#export KOPS_STATE_STORE=s3://kops-state-unifor
#export AWS_SDK_LOAD_CONFIG=1
#export AWS_PROFILE=kops

# aws s3api create-bucket --bucket kops-state-unifor
# aws s3api delete-bucket --bucket kops-state-unifor
# aws s3api put-bucket-versioning --bucket kops-state-unifor --versioning-configuration Status=Enabled

#export NAME=unifor.k8s.local
#export KOPS_STATE_STORE=s3://k8s-unifor-mario


#export KOPS_STATE_STORE=s3://kops-state-unifor

#kops create cluster --zones us-east-1a --name $NAME --node-count=0
#kops create cluster cloud=aws --zones=us-east-1a --name=apsouth1.hipster.com --dns-zones=apsouth1b.hipster --dns private

#kops create ig monitoring --role node --name $NAME
#kops create ig web --role node --name $NAME
#kops create ig db --role node --name $NAME
#kops create ig kubow --role node --name $NAME
#kops delete ig nodes --name $NAME

#kops update cluster --name $NAME --yes

# -----------------------------------------------------------------------------