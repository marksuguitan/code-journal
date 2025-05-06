# Recap: CloudFormation S3 Bucket Deletion & Replacement

## 1. DeletionPolicy
- **Delete**: Resource is removed when the stack is deleted. For S3 buckets, the deletion call will fail if the bucket is not empty.
- **Retain**: Resource remains in your account; CloudFormation removes it from the stack but does not delete the physical resource.
- **Snapshot**: (For snapshot-capable resources like RDS/EBS) CloudFormation takes a point-in-time snapshot before deleting.

## 2. UpdateReplacePolicy
- Controls what happens to the **old** resource when it must be replaced (e.g., renaming an immutable property like `BucketName`).
- Commonly set to the same value as `DeletionPolicy` to avoid accidental data loss.
- Valid options: `Delete`, `Retain`, `Snapshot`.

## 3. What Happens When Deleting a Stack
1. CloudFormation processes resources in reverse-dependency order.
2. Applies each resource’s **DeletionPolicy**:
   - **Delete**: Calls the service delete API.
   - **Retain**: Leaves the resource intact.
   - **Snapshot**: Takes a snapshot, then deletes (for databases/volumes).

## 4. What Happens When Renaming a Stack or Bucket Name
- **Stack rename**: Not supported in-place. You must create a new stack and delete the old one.
- **BucketName change** (immutable):
  1. CloudFormation creates a **new** bucket with the updated name.
  2. Applies the **UpdateReplacePolicy** on the **old** bucket:
     - **Delete** → Deletes the old (empty) bucket.
     - **Retain** → Keeps the old bucket and its contents.
     - **Snapshot** → Not applicable to S3.

## 5. Fully Deleting an S3 Bucket and Its Contents
### A) Manual Empty & Delete
```bash
aws s3 rm s3://my-stack-static-site-s3 --recursive
aws cloudformation delete-stack --stack-name my-stack
```

### B) Automated via Custom Resource
1. **Lambda function** that lists and deletes all objects and versions in the bucket.
2. **Custom Resource** in your template invokes this Lambda on stack **Delete** or **Update** events:
   ```yaml
   Resources:
     EmptyBucketFunction:
       Type: AWS::Lambda::Function
       Properties:
         Handler: index.handler
         Runtime: python3.12
         Role: !GetAtt EmptyBucketRole.Arn
         Code:
           ZipFile: |
             import boto3, cfnresponse
             def handler(event, context):
               if event['RequestType'] in ('Delete', 'Update'):
                 s3 = boto3.resource('s3')
                 bucket = s3.Bucket(event['ResourceProperties']['BucketName'])
                 bucket.object_versions.delete()
               cfnresponse.send(event, context, cfnresponse.SUCCESS, {})
     EmptyBucketRole:
       Type: AWS::IAM::Role
       Properties:
         AssumeRolePolicyDocument:
           Statement:
             - Effect: Allow
               Principal:
                 Service: lambda.amazonaws.com
               Action: sts:AssumeRole
         Policies:
           - PolicyName: EmptyBucketPolicy
             PolicyDocument:
               Statement:
                 - Effect: Allow
                   Action:
                     - s3:ListBucket
                     - s3:DeleteObject
                     - s3:DeleteObjectVersion
                   Resource: !Sub arn:aws:s3:::${SiteBucket}
     EmptyBucketCR:
       Type: Custom::EmptyS3Bucket
       Properties:
         ServiceToken: !GetAtt EmptyBucketFunction.Arn
         BucketName: !Ref SiteBucket
   ```
