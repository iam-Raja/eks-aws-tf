**EKS-ARCH**
![Screenshot 2024-07-17 104904](https://github.com/user-attachments/assets/3c6ec19c-0503-4fc2-85d9-32aed0da5d71)


**Expense-EKS-Arch**

![Screenshot 2024-07-17 104948](https://github.com/user-attachments/assets/422a1599-3f42-4718-bef4-0bc0976dab8c)

## To Push to ECR ##
```
aws ecr get-login-password --region <regin-name> | docker login --username AWS --password-stdin <Account-id>.dkr.ecr.<regin-name>.amazonaws.com
```

```
docker build -t <Account-id>.dkr.ecr.<regin-name>.amazonaws.com/expense-backend:latest .
```

```
docker push <Account-id>.dkr.ecr.<regin-name>.amazonaws.com/expense-backend:latest
```