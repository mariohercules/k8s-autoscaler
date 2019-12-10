export NAME=appznn.k8s.local
export KOPS_STATE_STORE=appznn-k8s

kops delete ig monitoring --name $NAME --state s3://$KOPS_STATE_STORE --yes 
kops delete ig web --name $NAME --state s3://$KOPS_STATE_STORE --yes 
kops delete ig db --name $NAME --state s3://$KOPS_STATE_STORE --yes 
kops delete ig kubow --name $NAME --state s3://$KOPS_STATE_STORE --yes 
kops delete ig locust --name $NAME --state s3://$KOPS_STATE_STORE --yes
kops delete ig nodes --name $NAME --state s3://$KOPS_STATE_STORE --yes 

kops delete cluster $NAME --state s3://$KOPS_STATE_STORE --yes 

aws s3api delete-bucket --bucket $KOPS_STATE_STORE

#Suggestions:
# * validate cluster: kops validate cluster
# * list nodes: kubectl get nodes --show-labels
# * ssh to the master: ssh -i ~/.ssh/id_rsa admin@api.kubeznn.k8s.local
# * the admin user is specific to Debian. If not using Debian please use the appropriate user based on your OS.
# * read about installing addons at: https://github.com/kubernetes/kops/blob/master/docs/addons.md.
# kops get secrets admin --type secret -oplaintext

# kops edit ig nodes --state s3://kubeznn-k8s
# kops update cluster kubeznn.k8s.local --state s3://kubeznn-k8s --yes
# kops rolling-update cluster --state s3://kubeznn-k8s

#aws s3 rm --recursive $KOPS_STATE_STORE
#kubectl config delete-cluster $NAME
#kubectl config delete-context $NAME
#kops delete ig nodes --name $NAME
#kops update cluster --name $NAME --yes