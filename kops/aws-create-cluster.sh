export NAME=appznn.k8s.local
export KOPS_STATE_STORE=appznn-k8s
export MASTER_SIZE=m3.medium

aws s3api create-bucket --bucket $KOPS_STATE_STORE

kops create cluster --zones us-east-1a --name $NAME --state s3://$KOPS_STATE_STORE 
#kops create cluster --node-count 0 --zones us-east-1a --master-size $MASTER_SIZE --master-zones us-east-1a --name $NAME --state s3://$KOPS_STATE_STORE

#kops create cluster --name=$NAME --state=s3://$KOPS_STATE_STORE --zones=us-east-1a --node-count=0 --master-size=$MASTER_SIZE

kops create ig monitoring --role node --name $NAME --state s3://$KOPS_STATE_STORE
kops create ig web --role node --name $NAME --state s3://$KOPS_STATE_STORE
kops create ig db --role node --name $NAME --state s3://$KOPS_STATE_STORE
kops create ig kubow --role node --name $NAME --state s3://$KOPS_STATE_STORE
kops create ig nodes --role node --name $NAME --state s3://$KOPS_STATE_STORE
kops create ig locust --role node --name $NAME --state s3://$KOPS_STATE_STORE

kops update cluster --name $NAME --state s3://$KOPS_STATE_STORE --yes

kops validate cluster --state s3://$KOPS_STATE_STORE
 
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