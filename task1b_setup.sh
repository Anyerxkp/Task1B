# Create cluster
kind create cluster --name kind-1 --config k8s/kind/cluster-config.yaml

# Verify cluster
docker ps
kubectl get nodes

# Create the Deployment in the cluster
kubectl apply -f k8s/manifests/k8s/backend-deployment.yaml

# verify that the Pods/containers are running
kubectl get pods
kubectl get deployment/backend

# Create the Service
kubectl apply -f k8s/manifests/k8s/backend-service.yaml

# verify that it works as expected
kubectl get service

# Create the ingress-controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

# Wait for the ingress-nginx-controller to be ready
while [[ $(kubectl -n ingress-nginx get deploy ingress-nginx-controller -o jsonpath='{.status.readyReplicas}') != "1" ]]; do
  echo "Waiting for ingress-nginx-controller to be ready..."
  sleep 5
done

# verify it works
kubectl -n ingress-nginx get deploy

# Create the Ingress
kubectl apply -f k8s/manifests/k8s/backend-ingress.yaml

# Verify the Ingress
kubectl get ingress
