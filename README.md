**Terraform AWS S3 Static Website Hosting**

**Project Description:**
This project demonstrates a fully automated, serverless static website hosting solution on AWS S3, provisioned using Terraform. It highlights how Infrastructure as Code can streamline cloud deployments by eliminating manual setup, ensuring consistent, repeatable infrastructure for fast and reliable web hosting.

**Architecture Overview**
```text
+---------------------+
|     Terraform       |
| (Infrastructure as  |
|      Code Tool)     |
+---------+-----------+
          |
          v
+---------------------+
|     AWS S3 Bucket   |
| (Static Website     |
|     Hosting)        |
+---------+-----------+
          |
          v
+---------------------+
|   Public Internet   |
|  (User's Browser)   |
+---------------------+



**Key Components**
Terraform: Manages the provisioning of AWS resources, ensuring a consistent and repeatable infrastructure setup.​

AWS S3 Bucket: Configured for static website hosting, it stores and serves the website's static files (HTML, CSS, JS).​

Public Internet (User's Browser): End-users access the static website via the S3 bucket's website endpoint URL.​



