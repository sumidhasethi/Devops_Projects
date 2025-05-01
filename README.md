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

**Define your Configuration Files in your IDE**

In the configuration files, define the AWS provider and required resources like S3 bucket, IAM roles and policies. 

1. Define the provider.tf file using below code :

             provider "aws" {
              region = "ap-south-1"
          }


2. In your IDE, open the terminal and navigate to the directory where these configurations files are created.

3. After navigating to the directory where configuration files are present, run the command to initialise Terraform and prepare it for use with AWS. 

             terraform init

Init command will install all the necessary plugins and modules required for connecting to AWS and managing the infrastructure. 


4. When initialisation is completed, in the resource.tf file, start by creating the s3 bucket.

             resource "aws_s3_bucket" "bucket1" {
              bucket = "web-bucket-sumidha"
          }

5. Run the below command to create the bucket :

             terraform apply -auto-approve


6. Once bucket gets created, add the below code in resource.tf file :

#In this project, we are creating a static webiste, so we need to disable all the restrictions that AWS enforces by default to prevent public access to S3 buckets. This is necessary for a public website so the contents can be accessed anonymously.

          resource "aws_s3_bucket_public_access_block" "bucket1" {
            bucket = aws_s3_bucket.bucket1.id
          
            block_public_acls       = false
            block_public_policy     = false
            ignore_public_acls      = false
            restrict_public_buckets = false
          }


#For the website, the index block will upload objects(which are html files in case of our project) to the s3 bucket. 

          resource "aws_s3_object" "index" {
            bucket = "web-bucket-sumidha"
            key    = "index.html"
            source = "index.html"
            content_type = "text/html"
          }
          
          resource "aws_s3_object" "error" {
            bucket = "web-bucket-sumidha"
            key    = "error.html"
            source = "error.html"
            content_type = "text/html"
          }



#Next we need to enable the static website hosting on our S3 bucket. This block will set up index.html as the default landing page and error.html as the error page.


          resource "aws_s3_bucket_website_configuration" "bucket1" {
            bucket = aws_s3_bucket.bucket1.id
          
            index_document {
              suffix = "index.html"
            }
          
            error_document {
              key = "error.html"
            }
          
          }



#Below code adds a bucket policy that allows anyone on the internet ("Principal": "*") to read objects from this bucket using HTTP. This is critical for enabling anonymous web access.


          resource "aws_s3_bucket_policy" "public_read_access" {
            bucket = aws_s3_bucket.bucket1.id
            policy = <<EOF
          {
            "Version": "2012-10-17",
            "Statement": [
              {
                "Effect": "Allow",
          	  "Principal": "*",
                "Action": [ "s3:GetObject" ],
                "Resource": [
                  "${aws_s3_bucket.bucket1.arn}",
                  "${aws_s3_bucket.bucket1.arn}/*"
                ]
              }
            ]
          }
          EOF
          }


7. Once the resource.tf file is written completely, run the plan command as it helps to identify the missing variables, provider issues, or misconfigured resources early. And also, to understand exactly what Terraform is going to create, change, or destroy.

          terraform plan


8. Carefully review the output of the terraform plan command. This will display all the resources that will be created, modified, or destroyed. Ensure that the changes are as expected.
   

10. If everything looks good and you’re ready to apply the changes, run the terraform apply command to apply the plan and provision the resources.

          terraform apply  -auto-approve


11. The code above will apply the necessary configurations for features such as static website hosting, bucket policies, and blocking public access to your bucket.
    


**Step 5:** 

**Define the Output File**

1. We use an output file to obtain the website link in the IDE, thus eliminating the need to access link through the AWS console.


2. Defile the Output.tf file and add the below code :

          output "websiteendpoint" {
          value = aws_s3_bucket.bucket1.website_endpoint
         }


3. Run the apply command : 

          terraform apply  -auto-approve


4. Once done, it will create and give the website link in the terminal as output.
<img width="627" alt="Screenshot 2025-05-01 at 1 09 02 PM" src="https://github.com/user-attachments/assets/2e282591-665c-4378-ab62-e37426e98231" />


**Step 6:** 

**Verify the Output**

Copy & paste the link in any browser and check the results.
<img width="1438" alt="Screenshot 2025-05-01 at 1 14 18 PM" src="https://github.com/user-attachments/assets/9779b380-f3bd-4d2a-86ee-9398024b819d" />

 



