export NAME=kubeznn.k8s.local
export KOPS_STATE_STORE=kubeznn-k8s
export MASTER_SIZE=m3.medium

kops delete cluster $NAME --state s3://$KOPS_STATE_STORE --yes 

aws s3api delete-bucket --bucket $KOPS_STATE_STORE