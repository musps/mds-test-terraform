# mds test terraform

### Configuration des variables d'environnement

```
# Création du fichier
cp .env-example .env

# Set des variables d'environnement
source .env
```

### Récupération de la configuration

```
# /live/region/eu-central-1/database/

terraform init
```

### Déploiement de la configuration

```
# /live/region/eu-central-1/database/

terraform plan
terraform apply
```



tf plan --var-file dev.tfvars
tf apply --var-file dev.tfvars
tf destroy --var-file dev.tfvars
