----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------

# Création du bucket Amazon S3

Accéder à la page "Compartiments S3"
Lien d'accès : https://console.aws.amazon.com/s3/home

- Cliquer sur le bouton bleu "Créer un compartiment"

Une nouvelle popup va s'afficher pour effectuer la création d'un bucket.

[ETAPE 1] - Nom et région

-  Nom du compartiment : saisir un nom avec le prefix mds-mai{{ account number }}
Variable : {{ account number }} -> Un nombre incrémenté.

- Région : Sélectionner la région "UE (Francfort)"

- Cliquer sur le bouton "Suivant"

[ETAPE 2] - Configurer des options
- Cette étape est sautée.
- Cliquer sur le bouton "Suivant"

[ETAPE 3] - Définir des autorisations
- Cocher la case "Bloquer tout l'accès public"
- Cliquer sur le bouton "Suivant"

[ETAPE 4] - Vérification
- Cliquer sur le bouton "Créer un compartiment"

----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------

# Création d'un accès IAM

Accéder à la page "Gestion des identités et des accès (IAM)"
Lien d'accès : https://console.aws.amazon.com/iam/home

- Cliquer sur "Utilisateurs", puis sur le bouton bleu "Ajouter un utilisateur"

Une nouvelle page va s'afficher pour effectuer la création d'un utilisateur.

Etapes de création d'un compte utilisateur :

[ETAPE 1]
- Nom d'utilisateur : saisir un nom avec le prefix mds-user{{ account number }}
Variable : {{ account number }} -> Un nombre incrémenté.

- Type d'accès : cocher la case "Accès par programmation"
- Cliquer sur le bouton "Suivant : Autorisations"

[ETAPE 2]

- Définir des autorisations : 
-- Sélectionner l'option "Attacher directement les stratégies existantes"
-- Cocher la coche : "AdministratorAccess"

- Cliquer sur "Suivant : Balises"

[ETAPE 3]
- Cette étape est sautée.
- Cliquer sur le bouton "Suivant : Vérification"


[ETAPE 4]
- Cliquer sur le bouton "Créer un utilisateur"

[ETAPE 5]
- Le compte a été crée !.
- Cliquer sur le bouton "Téléchargez .csv" pour obtenir la configuration du compte.
-- Un fichier a été téléchargé, garder le dans un endroit pour l'utiliser ultérieurement.

----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
