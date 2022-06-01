# Mini projet : Déployez une infra complète AWS

# Consignes

◦[x] Ecrivez un module pour **créer une instance ec2** utilisant la dernière version de ubuntu bionic (qui s’attachera à l’ ebs et l’ip publique) dont la **taille** et le **tag** seront variabilisés.

◦[x] Ecrivez un module pour **créer un volume ebs** dont la **taille** sera variabilisée.

◦[x] Ecrivez un module pour **créer une ip publique** (qui s’attachera la security group).

◦[x] Ecrivez un module pour **créer un Security Group** qui ouvrira le 80 et 443. **En ajout, ouvrira aussi le 22**.

◦[x] Créez un **dossier app** qui va utiliser les 4 modules pour déployer une ec2, bien sûr vous allez surcharger les variables afin de rendre votre application plus dynamique.

◦[x] A la fin du déploiement, installez nginx et enregistrez l’ip publique dans un fichier nommé ip_ec2.txt (ces éléments sont à intégrer dans le rôle ec2).

◦[] A la fin de votre travail, poussez votre rôle sur github et envoyez nous le lien de votre repo à eazytrainingfr@gmail.com et nous vous dirons si votre solution respecte les bonnes pratiques.

# REALISATION DU MINI PROJET

## Prérequis 

◦ Créez un compte AWS gratuit.

◦ Protégez votre compte root avec un mot de passe fort.

◦ Créez un compte nominatif avec les droits full admin et qui vous permettra de déployez les ressources.

◦ Installez un IDE, par exempleVisual Studio Code, ATOM, etc et installer un plugin terraform pour vous facilitez la correction
syntaxique.

◦ On sera prêt à installer terraform !

Pour installez Terraform en recupérant le binaire via le lien suivant: [Download terraform](https://www.terraform.io/downloads.html). Et faites le choix selon votre OS.

◦ Si vous êtes sous windows, copiez le binaire dans un dossier de votre disque dur system par exemple
C: terraform.

◦ Ensuite il vous faudra rajouter le repertoire précédent dans le PATH de votre système d’exploitation.

![Image PATH](/images/path.PNG "Image path terraform")

Puis valider sur **ok**.

◦ Si vous êtes sous linux , vous pouvez le déplacer dans / usr /bin/ après l’avoir rendu executable.

◦ Pour verifies l’installation , veuillez juste entrez la commande:
```
terraform
```
Puis

```
terraform version
```

## Illustration schématique de la solution

![Image Solution](/images/SchemaProjet1.PNG "Image solution proposée")

## Création des ressources

Dans ce mini projet, il nous est demandé d'utiliser les **modules**.
Nous avons:
- Un ec2
- Un ebs
- Un eip qui est notre propre ip publique
- Un security group donc le but est d'être notre Firewall

Ce que terraform est sensé faire c'est d'utiliser nos fichiers **.tf** pour provisionner notre infrastructure sur AWS

La première difficulté sera le *firewall** (Security Group).
Pour le mini projet, le firewall n'autorise que le **https** et **http** uniquement en entrée.

Sauf que terraform aura besoin de se connecter en **ssh** à notre instance **ec2** afin d'installer notre application (serveur) **Nginx**.

Cela veut dire qu'on devra modifier notre firewall (Security Group) pour ajouter le **ssh** comme troisième entrée (Première chose à modifier). Donc nous aurons trois **ingress: http, https, ssh**.

Il est à noter que pour installer **Nginx**, notre instance aura besoin de sortir pour aller sur internet.

Donc il faudra autoriser ce traffic sortant (deuxième chose à modifier) donc, l'**egress**.

```
resource "aws_security_group" "allow_ssh_http_https" {
  name        = "daniel-SG-tp3"
  description = "allow http and https inbound traffic"
  # J'ajoute les règles entrantes (http, https, ssh)
  ingress {
    description = "https from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Jajoute l'ingress pour le ssh
  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # J'ajoute une règle sortante 
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
```

## attention à la version de nginx sur amazon linux

Etant donné que nous exécutons *Nginx* sur Linux, nous devons obligatoirement préciser la version.

Par contre sur Debian ou CentOS, si on ne précise pas la version, la dernière sera prise en compte.

## attention à l’ip de l’ec2 et l’eip

Il est important de noter que:
 - Si nous créons dans notre infra une **eip**, cela veut dire que nous avons créé notre propre **ip publique** que nous attachons à notre **ec2**.
- Dans ce cas, nous allons mettre notre **provisioner "local-exec" {}** dans **resource "aws_eip" "my_eip" {}** pour attacher notre **ec2** à notre **eip**.

## Rappel

- Lorsque nous ne créons pas nous même une **eip**, amazon nous en donne une quand nous créons notre instance.
- Mais si nous arrêtons l'instance, nous perdons notre ip publique qu'il nous a donné lors de la création de l'instance.

Raison pour laquelle on créé nous même une **eip** et on l'attache à notre instance **ec2**.

## Illustration schématique simplifiée

![schema](/images/Illustration.PNG "solution simplifiée")

## Commandes de base pour déployer les ressources

Nous avons les commandes:
**Init**, **Plan**, **Apply**, **Destroy**

1. La commande **Init**

```
terraform init
```
Elle permet de récupérer l'ensembe des **modules** et également des **plugins** notamment le *provider*

![Init](/images/terra_init.PNG "init ok")

2. La commande Terraform **Plan**

```
terraform plan
```
Permet de définir quelles sont les actions qui seront effectivement réalisées si on décide de les faire vraiment.

3. La commande Terraform **Apply**

```
terraform apply
```

Permet d'enterriner et de réaliser ce qui a été planifié

![Apply](/images/terra_apply.PNG "Apply ok")

4. La commande Terraform **Destroy**

```
terraform destroy
```
Permet de supprimer l'ensembe des ressources déployées

# Structuration de notre projet

Notre projet est structuré de deux dossiers (**app** et **modules**)

## app
Dans le dossier **app**, nous avons un fichier terraform nommé **main.tf**

## modules
Dans le dossier **modules**, nous avons quatre autre dossiers des différents modules:

### ec2
Dans ce dossier, nous avons trois fichiers nommés:

- **main.tf**
  Ici je vais utiliser la notion de **data source**
- **output.tf**
- **variable.tf**

### ebs
Dans ce dossier, nous avons trois fichiers nommés:

- **main.tf**
- **output.tf**
- **variable.tf**

### eip
Dans ce dossier, nous avons deux fichiers nommés:
- **main.tf**
- **output.tf**

### sg
Dans ce dossier, nous avons trois fichiers nommés:

- **main.tf**
- **output.tf**
- **variable.tf**


# ELEMENT ADDITIONNEL A MON TRAVAIL

## Remote Management (Bucket S3)

Je souhaite partager mon travail avec d'autres collaborateur voire d'autres équipe.

Pour ce faire, je vais utiliser le **remote management**. 

**Comment est-ce qu'on fait si quelqu'un d'autre essaie également de déployer la ressource?**

Cela veut dire qu'à un moment donné, notre **terraform.tfstate** doit être partagé.

Une solution est proposée. C'est de centraliser et partager par tout le monde notre fichier **terraform.tfstate** et stocké dans **S3 State Bucket**.
Alors tous indiquerons à notre script de se baser du terraform.tfstate qui se trouve dans **S3 State Bucket** pour créer les ressources.

### Comment est-ce qu'on déclare le **Remote Backend?**

```
provider "aws" {
  region     = "us-east-1"
  access_key = "HERE"
  secret_key = "HERE"
}

resource "aws_instance" "myec2" {
  ami           = "ami-0022f774911c1d690"
  instance_type = "t2.micro"
}

resource "aws_iam_user" "ib" {
  name = "loadbalancer"
  path = "/system/"
}

terraform {
  backend "s3" {
    bucket     = "bucket_name"
    key        = "name.tfstate_of_s3"
    region     = "us-east-1"
    access_key = "HERE"
    secret_key = "HERE"
  }
}
```
Quant on fera

```
terraform init
```

Terraform va se connecter au **s3** et dire; Attention j'ai besoin de quelques informations, je sais que tu possède le **.tfstate** donc, remets le moi.
C'est ça le but du **Remote Backend**: C'est d'avoir le **.tfstate** qui est stocké remotly.

Pour réaliser notre **Remote Backend**, nous allons créer un **Bucket** sur AWS Management Console en utilisant le service aws S3.

Pour ce faire, je dois créer un compartiment que je nomme par exemple **terraform-backend-daniel** dans la même **région** et même **AZ** que les autres resources.

Une fois le **Bucket** créé, nous allons écrire le code qui permettra de centraliser le fichier **tfstate** afin que tous les
admins puissent le consommer.

1. Création du **bucket S3**
  
  ![Img création S3](/images/bucket.PNG "solution S3")

Une fois que le **Bucket S3** est créé, nous relançons les commandes ci-dessous:

```
terraform init
```
![Img init S3](/images/terra_init_s3.PNG "Ok s3")

```
terraform plan
```
```
terraform apply
```
![Img apply S3](/images/terra_apply_s3.PNG "solution tfstate Ok")

La commande c-dessus nous créée automatiquement le fichier **.tfstate** dans le **bucket**.

2. Création automatique du fichier **.tfstate**
   
  ![Img tfstate](/images/backend.PNG "solution backend")

### Rappel

Il est déconseillé de stocker le *.tfstate* sur un *git*.

# TEST APPLICATION DEPLOYEE

Nous copions l'ip publique de notre fichier **ip_ec2.txt** puis collons sur l'url pour vérifier que notre application tourne avec succes.
![Img test app](/images/testok.PNG "test app")

# SUPPRIMER LES RESOURCES

Pour le faire automatiquement avec terraform, taper juste la commande ci-dessous:

```
terraform destroy
```
![Img destroy](/images/destroy.PNG "destroy ok")

# Recommandations

Je vous recommande aussi les cours de [eazytraining](https://eazytraining.fr/parcours-devops/) en général et particulièrement le **AWS** et **terraform**.

Pour une lecture complémentaire des débutants en **terraform** et **aws**, clique [ICI](https://carlchenet.com/debuter-avec-aws-et-terraform-deployer-une-instance-ec2/)

[Learn HashiCorp Terraform](https://learn.hashicorp.com/tutorials/terraform/infrastructure-as-code?in=terraform/aws-get-started)

# Liens

- Installer [terraform](https://www.terraform.io/downloads)
