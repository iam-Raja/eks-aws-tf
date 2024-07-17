**EKS-ARCH**
![Screenshot 2024-07-17 104904](https://github.com/user-attachments/assets/3c6ec19c-0503-4fc2-85d9-32aed0da5d71)


**Expense-EKS-Arch**

![Screenshot 2024-07-17 104948](https://github.com/user-attachments/assets/422a1599-3f42-4718-bef4-0bc0976dab8c)

## To Push to ECR ##
```
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 315069654700.dkr.ecr.us-east-1.amazonaws.com
```

```
docker build -t 315069654700.dkr.ecr.us-east-1.amazonaws.com/expense-backend:latest .
```

```
docker push 315069654700.dkr.ecr.us-east-1.amazonaws.com/expense-backend:latest
```