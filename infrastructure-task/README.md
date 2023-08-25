# Infrastructure test assignment

We have set up a basic web site using Amazon Web Services - it is a static site deployed in an S3 bucket and served by CloudFront. Your task will be to make some infrastructure-level changes to support experiments.

The site is available on https://drfnh721o4h1t.cloudfront.net.

You can modify the infrastructure for the site through the [AWS admin console](https://619141090667.signin.aws.amazon.com/console). Credentials will be sent separately.

## Your task

- Familiarize yourself with the "application" (https://drfnh721o4h1t.cloudfront.net)
- Notice that the ["home" page](https://drfnh721o4h1t.cloudfront.net/home) has two other variants ([home/variant-1](https://drfnh721o4h1t.cloudfront.net/home/variant-1) and [home/variant-2](https://drfnh721o4h1t.cloudfront.net/home/variant-2)) which are currently unused
- Implement _infrastructure-level_ logic that will randomly distribute traffic to the ["home" page](https://drfnh721o4h1t.cloudfront.net/home) between the different variants (home, home/variant-1, and home/variant-2)
- Depending on how much time you have, there are some possible extensions:
  - Prevent users from accessing the other variants by going directly to the corresponding URL. [/home](https://drfnh721o4h1t.cloudfront.net/home) should lead to the assigned variant, [/home/variant-1](https://drfnh721o4h1t.cloudfront.net/home/variant-1) and [/home/variant-2](https://drfnh721o4h1t.cloudfront.net/home/variant-2) should not work.
  - Add a way for developers (etc.) to access a specific variant (maybe a cookie or other header, or a URL parameter)
  - Make the distribution "sticky" so that a particular user always gets the same variant
  - Add a way to quickly turn the "experiment" on or off without deploying new code. When off, visitors should always get the original version
  - Add a way to quickly (without deploying new code) select a variant that will be used for all traffic

You should not have time to implement everything, but we would like to discuss your ideas during the technical interview even if you do not finish them.

At Telia we manage our infrastructure as code using Terraform, but for this task you can use any tool you like, or make changes manually. Parts of the task could be implemented by changing the (frontend) application rather than the infrastructure, but for the purposes of this assignment, please do not change the application code.

## Tips

- There is already a Lambda@Edge function that handles incoming requests. This could be a good place to start, but you may choose a different solution if you want
- You can see most existing resources by checking https://us-east-1.console.aws.amazon.com/resource-groups/group/Recruitment_Test_Infrastructure?region=us-east-1
- AWS has good developer documentation. The most relevant parts is likely the [CloudFront Developer Guide](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Introduction.html).
- Your account should have all the access it needs, but don't hesitate to get in touch if you see permission-related errors.
- The existing infrastructure was set up using Terraform. You can see the templates in this repository, and if you want to you can continue using Terraform to modify it.

**Good luck!**
