
# Deploying a Static Next.js Site to S3 + CloudFront (Cheat Sheet)

## 📝 Key Takeaways

| Topic | What you learned |
|-------|------------------|
| **Next.js static export** | `output: 'export'` (Next 13.5+) or `next export` after `next build` turns the site into plain HTML/JS in `./out`. |
| **Upload strategy** | Sync **the *contents*** of `./out` (not the folder itself) to the S3 bucket root: `aws s3 sync ./out s3://bucket --delete`. |
| **S3 hardening** | • ACLs **disabled (Bucket‑owner enforced)**  • **SSE‑S3** encryption  • **Block all public access** when using CloudFront + OAC. |
| **Bucket policy for OAC** | Grant `s3:GetObject` to the CloudFront service principal with an `AWS:SourceArn` condition for your distribution ID. |
| **CloudFront origin** | Use the bucket’s **REST endpoint** (`bucket.s3.amazonaws.com`), not the `s3‑website‑…` endpoint. |
| **Origin Access Control (OAC)** | Attach an OAC, set “Restrict bucket access = Yes”; this keeps the bucket private and signs every request. |
| **Default root object** | Set **`index.html`** or you’ll see XML “Access Denied” when requesting `/`. |
| **Custom domain flow** | ACM cert (us‑east‑1) ➜ add CNAME in CloudFront ➜ Route 53 **Alias A/AAAA** pointing to the distribution. |
| **Typical 403 causes** | Missing Default Root Object, wrong origin endpoint, or bucket policy/OAC mismatch. |
| **CORS** | Not required when everything is served from the same CloudFront/custom domain; add only if you fetch from another origin. |

---

## 🚀 Repeatable Checklist: Static Next.js on AWS

> Use this playbook for future projects.

1. **Static‑export build**

   ```bash
   # next.config.ts
   export const nextConfig = { output: 'export' };

   npm run build && npm run export   # ⇒ ./out
   ```

2. **Create S3 bucket**

   - Unique name (e.g. `my-app-frontend`)
   - **ACLs disabled (Bucket‑owner enforced)**
   - **Block all public access** = ON
   - **SSE‑S3** encryption
   - *Don’t* enable static‑website hosting (CloudFront is the entry point).

3. **Upload**

   ```bash
   aws s3 sync ./out s3://my-app-frontend --delete
   ```

4. **Bucket policy for CloudFront**

   ```json
   {
     "Version":"2012-10-17",
     "Statement":[{
       "Effect":"Allow",
       "Principal":{"Service":"cloudfront.amazonaws.com"},
       "Action":"s3:GetObject",
       "Resource":"arn:aws:s3:::my-app-frontend/*",
       "Condition":{"StringEquals":{
         "AWS:SourceArn":"arn:aws:cloudfront::<ACCOUNT_ID>:distribution/<DIST_ID>"
       }}
     }]
   }
   ```

5. **Origin Access Control**

   - Create OAC (type =S3, sign =sigv4)
   - CloudFront › Origins › Edit:
     - Origin domain: `my-app-frontend.s3.amazonaws.com`
     - **Restrict bucket access** = Yes
     - Choose the OAC

6. **CloudFront distribution**

   | Setting | Value |
   |---------|-------|
   | Default root object | `index.html` |
   | Alternate domain names | `www.example.com` (optional) |
   | SSL certificate | ACM cert (us‑east‑1) |
   | WAF (optional) | AWS Managed Rules |

7. **ACM certificate (us‑east‑1)**

   - SANs: `example.com`, `www.example.com` or `*.example.com`
   - DNS‑validate ➜ Status **Issued**

8. **Route 53**

   - **Alias A** (`rp` or root) → CloudFront distribution
   - (Optional) **AAAA** for IPv6

9. **Invalidate cache**

   ```bash
   aws cloudfront create-invalidation      --distribution-id <DIST_ID> --paths "/*"
   ```

10. **Smoke‑test**

    - `https://dXXXX.cloudfront.net/`
    - `https://www.example.com/`

---

## ⚡️ Troubleshooting

| Symptom | Fix |
|---------|-----|
| XML **AccessDenied** at `/` | Add **Default root object = index.html** |
| 403 via CloudFront | Check OAC attachment & bucket policy |
| Works via CF URL, fails custom domain | Add CNAME & cert, update Route 53 alias |
| HTML loads, assets 404 | Ensure you uploaded files inside `./out`, not the folder |

---

### End of Cheat Sheet
