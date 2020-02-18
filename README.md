# AWS Lambda
*What It Is and Why It's Terrible*

A presentation & live demo highlighting the the dark underbelly of "Serverless" solutions,
picking on AWS Lambda because it is the most prevelant. We build an old-school HitCounter
in Lambda + DynamoDB and compare this approach to CGI + SQLite.

### Outline
* High Latency when spinning up new instances.
  * New "provisioned concurrency" model is AWS billing double-speak, why not buy a VM?
* Debugging is a nightmare:
  * Logs don't come through CloudWatch immediately
  * No ptrace or bpftrace for production debugging
  * No atop for understanding resource utilization.
* Weird packaging & deployment pattern that isn't used anywhere else.
  * In practice you must use a framework like Serverless or Zappa
  * They handle some but not all infra for you -- where should the line be drawn?
* Is "patching servers" really that hard? Yumcron, anyone?
* Providing secrets means using + paying for AWS Secrets manager
  * No secrets manager means keeping secrets in plaintext somewhere
  * Avoid secrets means Fully Relying on IAM, which can be easy to screw up
* Network performance is proportional to memory allocation
  * This makes you pay for way more than you need in order to get a responsive app
  * Speculation: this comes from oversubscribing RAM via KSM, can't do same with network
* Lambda saves money when apps are mostly off, but the developer time will never pay off.

### Acknowledgements
* Abe Simpson image © 20th Century Fox
* Modern Problems meme © Dave Chappelle / Comedy Central
* Critical Feedback from [@myoung34](https://github.com/myoung34)
