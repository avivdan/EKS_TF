create s3 bucket
```
aws s3 mb s3://terraform-state-eks-cluster-1 --region eu-north-1
```

``` 
terraform init
terraform plan
terraform validate
terraform apply -auto-approve
```

upload image to ecr
### Authenticate docker to ECR
```
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.<region>.amazonaws.com"

aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin $ECR_REGISTRY
```

### Optional : Pull from dockerhub
```
sudo docker pull <username>/<repository>:<tag>
```

### Tag and push to ecr
```
docker tag <CONTAINER_ID> $ECR_REGISTRY/<my-repository:tag>

aws ecr get-login-password --region <region>| sudo docker login --username AWS --password-stdin $ECR_REGISTRY

docker push $ECR_REGISTRY/<my-repository:tag>
```

### Check if they are in ECR
```
aws ecr describe-images --repository-name <repository> --region <region>
```

</br>

### update context kubectl
```
aws eks --region eu-north-1 update-kubeconfig --name eks-cluster

kubectl apply -f flask-deployment.yaml

```

#### get the address
```
kubectl get service flask-service | awk 'NR==2 {print $4}' 