---
title_pl: "Notatki o Chmurze AWS"
title: "AWS Cloud Notes"
subtitle: ""
description: "Notatki o Chmurze AWS"
date: 2024-02-20
image: ""
tags: ["pl", "aws", "cloud"]
categories: ["Notes"]
---

# EC2

Opisz uruchomione instancje

```
aws ec2 describe-instances \
    --filter Name=instance-state-name,Values=running \
    --output text \
    --query 'Reservations[].Instances[].{ID: InstanceId,Hostname: PublicDnsName,Name: Tags[?Key==`Name`].Value | [0],Type: InstanceType, Platform: Platform || `Linux`}'
```

# Route53

Nie wiedzieć czemu, ale żeby móc przekierować rekord `A` na dystrybucję Cloudfront, musi być w us-east-1. Wpisujemy domenę dystrybucji.

# S3
