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

```sh
aws ec2 describe-instances \
    --filter Name=instance-state-name,Values=running \
    --output text \
    --query 'Reservations[].Instances[].{ID: InstanceId,Hostname: PublicDnsName,Name: Tags[?Key==`Name`].Value | [0],Type: InstanceType, Platform: Platform || `Linux`}'
```

Zwiększenie wolumina [1]:

```sh
aws stop-instance --instance-id $INSTANCE_ID # może nie potrzebne
aws ec2 modify-volume --volume-id $VOL_ID --size 123 # w domyśle GiB
aws start-instance --instance-id $instance-id
```

Wtedy na hoście:

```sh
# nie wybieraj bezpośrednio urządzenie partycji - $part_num zwykle 1
sudo growpart /dev/nvme0n1 $part_num 
# dopiero teraz /dev/nvme0n1p1
sudo resize2fs /dev/nvme0n1p1
```

# Route53

Nie wiedzieć czemu, ale żeby móc przekierować rekord `A` na dystrybucję Cloudfront, musi być w us-east-1. Wpisujemy domenę dystrybucji.

# S3

# Referencje

[Text][id]

[id]:https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/recognize-expanded-volume-linux.html "https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/recognize-expanded-volume-linux.html"


