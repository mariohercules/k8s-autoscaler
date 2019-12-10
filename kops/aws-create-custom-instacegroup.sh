export NAME=kubeznn.k8s.local
export KOPS_STATE_STORE=kubeznn-k8s
export MASTER_SIZE=m3.medium

## aws s3api create-bucket --bucket $KOPS_STATE_STORE

## kops create cluster --zones us-east-1a --name $NAME --state s3://$KOPS_STATE_STORE 

#kops create cluster --zones us-east-1a --state s3://$KOPS_STATE_STORE --name $NAME --dry-run --output yaml

# kops create cluster --name teste --dry-run --output yaml

# aws s3api create-bucket --bucket $KOPS_STATE_STORE

#kops create -f master-ig.yaml --state=s3://$KOPS_STATE_STORE 
kops create -f db-ig.yaml --state=s3://$KOPS_STATE_STORE 
kops create -f locust-ig.yaml --state=s3://$KOPS_STATE_STORE 
kops create -f monitoring-ig.yaml --state=s3://$KOPS_STATE_STORE 
kops create -f web-ig.yaml --state=s3://$KOPS_STATE_STORE 

#kops create secret --name $NAME --state=s3://$KOPS_STATE_STORE sshpublickey admin -i ~/.ssh/id_rsa.pub

kops update cluster $NAME --state=s3://$KOPS_STATE_STORE --yes
#kops create cluster --node-count 0 --zones us-east-1a --master-size $MASTER_SIZE --master-zones us-east-1a --name $NAME --state s3://$KOPS_STATE_STORE

#kops create cluster --name=$NAME --state=s3://$KOPS_STATE_STORE --zones=us-east-1a --node-count=0 --master-size=$MASTER_SIZE

###kops create ig monitoring --role node --name $NAME --state s3://$KOPS_STATE_STORE
###kops create ig web --role node --name $NAME --state s3://$KOPS_STATE_STORE
###kops create ig db --role node --name $NAME --state s3://$KOPS_STATE_STORE
###kops create ig kubow --role node --name $NAME --state s3://$KOPS_STATE_STORE
#kops create ig nodes --role node --name $NAME --state s3://$KOPS_STATE_STORE
###kops create ig locust --role node --name $NAME --state s3://$KOPS_STATE_STORE

###kops update cluster --name $NAME --state s3://$KOPS_STATE_STORE --yes

### kops validate cluster --state s3://$KOPS_STATE_STORE
 
## kops update cluster --name kubeznn.k8s.local --state s3://kubeznn-k8s --yes 
## kops validate cluster --state s3://kubeznn-k8s
## kubectl get nodes --show-labels

#Suggestions:
# * validate cluster: kops validate cluster
# * list nodes: kubectl get nodes --show-labels
# * ssh to the master: ssh -i ~/.ssh/id_rsa admin@api.kubeznn.k8s.local
# * the admin user is specific to Debian. If not using Debian please use the appropriate user based on your OS.
# * read about installing addons at: https://github.com/kubernetes/kops/blob/master/docs/addons.md.
# kops get secrets admin --type secret -oplaintext

#aws s3 rm --recursive $KOPS_STATE_STORE
#kubectl config delete-cluster $NAME
#kubectl config delete-context $NAME
#kops delete ig nodes --name $NAME
#kops update cluster --name $NAME --yes