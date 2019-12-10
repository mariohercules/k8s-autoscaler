export CLUSTER=cluster
export BUCKET=routecloud.com.br
export REGION=us-east-1
export ZONE=us-east-1a

kops delete ig monitoring --name $BUCKET --state s3://$BUCKET --yes 
kops delete ig web --name $BUCKET --state s3://$BUCKET --yes
kops delete ig db --name $BUCKET --state s3://$BUCKET --yes
kops delete ig kubow --name $BUCKET --state s3://$BUCKET --yes
kops delete ig nodes --name $BUCKET --state s3://$BUCKET --yes

kops delete cluster $BUCKET --state=s3://$BUCKET --yes

aws s3api delete-bucket --bucket $BUCKET

#aws iam delete-service-linked-role  --role-name "elasticloadbalancing.amazonaws.com"
# aws route53 delete-hosted-zone $BUCKET



