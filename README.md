### GitHub Actions workflow to handle deployment

### CI/CD Deployment Flow (GitHub Actions → AWS ECS via CodeDeploy)

#### This project uses GitHub Actions to build, push, and deploy a Dockerized application to AWS ECS using AWS CodeDeploy for blue/green deployments.

2️⃣ Configure GitHub Secrets

Add the following secrets in GitHub → Settings → Secrets → Actions:

3️⃣ GitHub Actions Workflow Trigger

Workflow runs automatically on:

Push to main branch

Example:

on:
  push:
    branches: [ "main" ]

4️⃣ Build Docker Image

Checkout source code

Build Docker image locally in GitHub Actions

Tag the image using GitHub commit SHA

IMAGE_TAG = <git_commit_sha>

5️⃣ Authenticate to Amazon ECR

Login to Amazon ECR using AWS credentials

Authenticate Docker client

6️⃣ Push Docker Image to ECR

Push the image to Amazon ECR

7️⃣ Update ECS Task Definition Dynamically

Fetch existing ECS task definition

Replace the container image with the new ECR image URI

Register a new task definition revision

Capture the new Task Definition ARN

8️⃣ Prepare CodeDeploy AppSpec File

Generate appspec.yaml dynamically

Reference:

New task definition ARN

ECS service name

Load balancer container name & port


9️⃣ Trigger AWS CodeDeploy Deployment

Create a new deployment using:

CodeDeploy application

Deployment group

AppSpec content

CodeDeploy performs:

Blue/Green traffic shifting

Health checks

Automatic rollback on failure (if enabled)

🔟 Monitor Deployment Status (Optional)

Poll CodeDeploy deployment status:

InProgress

Succeeded

Failed

Fail the GitHub Actions job if deployment fails

🔁 Automatic Rollback (Optional)

If deployment fails:

CodeDeploy automatically rolls back to the last healthy task definition

GitHub Actions marks the workflow as failed

✅ Deployment Success

On successful deployment:

New Docker image is live on ECS

Traffic is fully shifted to the new task revision

Old task revision is terminated safely

📌 Summary Flow
Git Push
  ↓
GitHub Actions
  ↓
Build Docker Image
  ↓
Push to ECR (commit SHA tag)
  ↓
Register ECS Task Definition
  ↓
Create CodeDeploy Deployment
  ↓
Blue/Green Release
