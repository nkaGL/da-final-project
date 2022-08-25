# The Final Project of DevOps Academy
Global Logic June-August 2022

## Main tasks and assumptions:
The CI/CD pipeline for a todo list web application fully hosted on AWS cloud.<br>
All underlying infrastructure should be provisioned as IaC and its code is kept in the Git repository:
- Cloud Provider: AWS
- The application: Simple CRUD WebApp build from scratch in Node.js with MongoDB-based database <br> <br>
![screenshot](https://user-images.githubusercontent.com/106961767/186554398-0d244347-6491-4107-851e-3f11b84f621e.png) <br> <br>

## Running the project
### Developer tools required to work with code:
- [Node.js](https://nodejs.org/en/)
- [Nodemon](https://www.npmjs.com/package/nodemon): `npm install --global nodemon`
- [MongoDB](https://www.mongodb.com/docs/manual/administration/install-community/)

### Fork the repo.

### Prepare AWS Free Tier account data. You can use KeyVault outside the project or just save environmental variables to login to AWS account:
```bash
export AWS_ACCESS_KEY_ID=[YourKeyIdValue]
export AWS_SECRET_ACCESS_KEY=[YourSecretAccessKeyValue]
export AWS_DEFAULT_REGION=[YourRegionValue]
```
### Go to `.terraform` directory and create needed resources:
```bash
terraform init
terraform plan
terraform apply
```
If you would like to put Terraform backend in remote storage of AWS S3, first uncomment lines in `01-main.tf` file and then once again perform init and apply:
```HCL
  # backend "s3" {   
  #   bucket  = "terraformstate-ninagl2022"
  #   key     = "global/s3/terraform.tfstate"
  #   region  = "eu-west-1"
  #   encrypt = true
  # }
```
If you want to remove ALL created resources, you need to remove or comment lines which are preventing from deletion those phillar resources (s3 terraform backend and jenkins server). You can find those lines in `04-ec2.tf` and `02-s3.tf` files:
```HCL
lifecycle {
  prevent_destroy = true
}
```
Then use:
```bash
terraform destroy
```

### After successfully creation of resources go to AWS console and find public DNS of Jenkins server and run (`Dev-pipeline`) to start CI/CD process of project.
[image of pipelines, screenshoots from AWS and jenkins]

#### All Jenkins configuraitons required to create those Jenkins setup are.......... <br>

### Possible improvemnets:
- VPN security
- Kubernetes Cluster -  to avoid accidentaly inaccessibility of EC2 instance with WebApp
- MongoDB outside the EC2 instance to let data be saved somethere else (propositions: AWS documentDB or MongoDB Alas solution)

### [Project Stack Presentation](https://github.com/nkaGL/da-final-project/wiki/Project-Stack-Presentation)
