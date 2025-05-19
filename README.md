**EKS Cluster Setup in AWS & App Deployment using Helm**

---

**Project Description**

This project demonstrates the complete lifecycle of provisioning an Amazon EKS (Elastic Kubernetes Service) cluster on AWS using Infrastructure as Code (Terraform) and deploying a containerized application using Helm charts. It follows industry best practices to build a scalable, modular, and production-ready Kubernetes environment.

---

**Architecture Overview**
```text

                                +----------------------+
                                |      Developer       |
                                |  (kubectl, Helm)     |
                                +----------+-----------+
                                           |
                                           v
                                +----------+-----------+
                                |     AWS EKS Cluster   |
                                +----------+-----------+
                                           |
                                +----------v-----------+
                                |     Worker Nodes      |
                                |   (EC2 Instances)      |
                                +----------+-----------+
                                           |
                                +----------v-----------+
                                |   Helm Deployment     |
                                |  (App Pods + Service) |
                                +----------+-----------+
                                           |
                                +----------v-----------+
                                | LoadBalancer Service |
                                +----------+-----------+
                                           |
                                     +-----v-----+
                                     |  Users     |
                                     | (Internet) |
                                     +-----------+


```

---

**Key Components**



---
