# mds test terraform

### STEP 1 : Pré-requis

```
Packer
Tuto : https://www.packer.io/intro/getting-started/install.html

Terraform
Tuto : https://learn.hashicorp.com/terraform/azure/install_az

Un compte aws, un bucket s3 ainsi que un accès AMI.
Tuto : Voir le détail du fichier readme-aws.md
```

### STEP 2 : Configuration des variables d'environnement

```
# Création du fichier
cp .env.example .env

Configuration des variables d'accès ami. Ces valeurs se trouvent dans le fichier téléchargé au préable à l'étape 5 du "Création d'un accès IAM"

# Set des variables d'environnement
source .env
```

### Création du AMI

```
# Création de notre image :
packer build packer/ubuntu-ursho.json


# A la fin de la génération, mettre de côté le ami id (ami-xxx)

==> Builds finished. The artifacts of successful builds are:
--> amazon-ebs: AMIs were created:
eu-central-1: ami-xxxxxx
```

### Déploiement avec Terraform

* Accéder au dossier `terraform`
* Exécuter la commande suivante `cp main.tf.example main.tf`
* Configuration des variables du fichier `main.tf`

| Nom variable | Contenu attendu |
| --- | --- |
| db_password | Un mot de passe pour la base de données |
| ami_id | Le AMI id généré plutôt |
| public_key_path | Le chemin vers votre clé ssh publique |
| private_key_path | Le chemin vers votre clé ssh privée |

```
# Installation de l'infrastructure ursho :
terraform init
terraform plan
terraform apply

# Affichage des informations serveurs :
tf output -module=default

bastion_public_ip = random_ip
ursho_private_ip = random_ip
ursho_public_ip = random_ip
```

### Test de fonctionnement

```
# Remplacez {{ursho_public_ip}} par le contenu de la variable ursho_public_ip
curl -H "Content-Type: application/json" -X POST -d '{"url":"www.google.com"}' http://{{ursho_public_ip}}:8080/encode/

# Réponse attendue :
{"success":true,"response":"Generated url : /1"}

# Accès au ursho
{{ursho_public_ip}}:8080/1
```
