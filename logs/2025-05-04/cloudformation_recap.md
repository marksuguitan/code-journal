
# CloudFormation & SAM Learning Recap

## 1. What is a CloudFormation Stack?
- A **stack** is a collection of AWS resources that you manage as a single unit.
- You define the desired infrastructure in a template (`.yaml` or `.json`) and deploy it with CloudFormation or SAM.
- Benefits include consistency, version control, rollback capability, and resource dependency management.

## 2. Stacks vs Stages
- **Stack**: Group of resources deployed together (e.g., a Lambda + API Gateway + DynamoDB).
- **Stage**: A versioned deployment environment for an API (e.g., `dev`, `prod`).

## 3. Infrastructure as Code (IaC)
- CloudFormation lets you define AWS infrastructure declaratively.
- This improves repeatability, auditing, and collaboration.
- All resources are provisioned in a consistent and automated way.

## 4. Why Use CloudFormation for Single Resources?
- Even for a single S3 bucket, IaC offers version control, consistency, and scalability.
- You can add more resources later while preserving history.

## 5. SAM (Serverless Application Model)
- SAM is a superset of CloudFormation optimized for serverless applications.
- Uses simplified syntax (`AWS::Serverless::Function`, `AWS::Serverless::HttpApi`).
- Supports local testing using `sam local invoke` and `sam local start-api`.

## 6. Deploying Templates
- You can deploy a template via:
  ```
  aws cloudformation deploy --template-file template.yaml --stack-name mystack
  ```
- Or for SAM:
  ```
  sam build
  sam deploy --guided
  ```

## 7. Using One Template for Multiple Environments
- Reuse the same `template.yaml` and change parameters per environment.
- Use `samconfig.toml` to manage per-env config.

## 8. Resource Import and Management
- You can import existing resources into CloudFormation using `create-change-set --change-set-type IMPORT`.
- Imported resources require a `DeletionPolicy: Retain`.

## 9. ApiMapping and Stage Setup
- For custom domains and API Gateway stages:
  - Define your API with `AWS::Serverless::HttpApi`.
  - Explicitly define the `AWS::ApiGatewayV2::Stage`.
  - Use `AWS::ApiGatewayV2::ApiMapping` to link domain → stage.

## 10. Outputs and Cross-Stack References
- Outputs expose values (like domain names or ARNs).
- Use `Fn::ImportValue` in another stack to consume exported values.

---

This recap covers the essential CloudFormation and SAM concepts and best practices you’ve learned. Continue using IaC for scalable, repeatable infrastructure!
