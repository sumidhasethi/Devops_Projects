**Terraform AWS S3 Static Website Hosting**

---

**Project Description**

This project demonstrates a fully automated, serverless static website hosting solution on AWS S3, provisioned using Terraform. It highlights how Infrastructure as Code can streamline cloud deployments by eliminating manual setup, ensuring consistent, repeatable infrastructure for fast and reliable web hosting.

---

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
```

---

**Key Components**

- **Terraform**: Manages the provisioning of AWS resources, ensuring a consistent and repeatable infrastructure setup.
- **AWS S3 Bucket**: Configured for static website hosting, it stores and serves the website's static files (HTML, CSS, JS).
- **Public Internet (User's Browser)**: End-users access the static website via the S3 bucket's website endpoint URL.
<br><br>
---

**Prerequisites**

- A basic understanding of AWS services and core concepts.
- Familiarity with Terraform and the principles of Infrastructure as Code (IaC).
- An active AWS account with sufficient permissions to create and manage S3 resources.
- An IDE of your choice (Visual Studio Code is recommended for ease of use).
- This project is a great starting point for hosting static websites such as personal blogs, portfolio pages, or small business sites.

---

**Steps**
---

**Step 1:** 

**Set Up Your Development Environment**

Begin by installing Terraform and the AWS Command Line Interface (CLI) on your local machine. Next, configure your AWS credentials by running the command aws configure, and input your AWS access key and secret key when prompted.

**Step 2:**

**Prepare Your Website Content**

Create your static website files (HTML) and place them in the directory where your Terraform configuration files are stored. Ensure the main HTML file is named index.html. Optionally, you can also include an error.html file. 

**Step 3:**

**Define the Terraform Configuration**

To create the necessary Terraform configuration file, use the .tf extension (e.g., main.tf). This file will define your infrastructure as code, which Terraform will use to provision the resources.


**Step 4:** 
Configure Your Files in the IDE
In your IDE, start by defining the AWS provider and the necessary resources such as S3 buckets, IAM roles, and policies.

Create a provider.tf file and add the following code:

provider "aws" {
    region = "ap-south-1"
}

Next, open the terminal in your Integrated Development Environment (IDE) and navigate to the directory where your Terraform configuration files are stored. Once in the correct directory, run the following command to initialize Terraform and configure it for use with AWS:

terraform init

The terraform init command will download and install the required plugins and modules to establish a connection with AWS and manage your infrastructure.

