<div style="background:#dddddd">
<h1 style="text-align: center"> UNIVERSITE NORMANDIE LE HAVRE</h1>

<h3 style="text-align: center">MASTER 2 IWOCS<br>22/12/2022</h3>

</div>

# Enchère Hollandaise
|   Nom           | Prénom   |
|-----------------|----------|
|   Alonso Tort   |  Andoni  |

## Présentation

Le projet consiste à créer un Smart Contract (SC) permettant de réaliser une enchère ascendante Hollandaise.

Une enchère ascendante hollandaise est un document électronique (RFx) [2] qui contient une liste d'articles que des acheteurs veulent vendre. Lors de cette enchère, le prix des articles diminue après des intervalles fixés jusqu'à ce que le prix réservé soit atteint. Avant que le prix réservé soit atteint, si le fournisseur fait une offre pour l'article, celui-ci est attribué à ce fournisseur et l'enchère est clôturée pour l'article.

Dans cette enchère, l'acheteur indique un prix de départ, une valeur de modification de prix, un intervalle de temps entre les modifications de prix et le prix réservé.

L'enchère s'ouvre avec le premier article avec le prix de départ spécifié et diminue selon la valeur de modification de prix (montant ou pourcentage) après un intervalle fixé. Le prix de départ diminue jusqu'à ce qu'un fournisseur fasse une offre ou que le prix de départ atteigne le prix réservé. Une fois l'enchère close pour l'article, l'enchère passe à un autre article de manière séquentielle.

L'enchère est clôturée lorsque la soumission d'offres pour tous les articles est terminée.

[1] : IBM. Enchère ascendante Hollandaise. [en ligne] Disponible sur *https://www.ibm.com/docs/fr/emptoris-sourcing/10.1.0?topic=rt-dutch-forward-auction* (Consulté le 12/2023).

[2] : IBM. Types de RFx. [en ligne] Disponible sur *https://www.ibm.com/docs/fr/emptoris-sourcing/10.1.0?topic=rfx-types* (Consulté le 12/2023).

## Installation

Installez [NodeJS LTS](https://nodejs.org) (via `nvm` ou `asdf`), [Ganache](https://trufflesuite.com/docs/ganache/), [Truffle](https://trufflesuite.com/docs/truffle/) ainsi que MetaMask. N'oubliez pas de rédiger votre rapport en même temps.

NOTE : Pour suivre toutes les intallations et les étapes à faire veuillez regarder le fichier Rapport.md

## INSTRUCTIONS

Le projet consiste à créer un Smart Contract (SC) permettant de réaliser une enchère ascendante Hollandaise.
Une enchère ascendante hollandaise est un document électronique (RFx) [2] qui contient une liste d'articles que des acheteurs veulent vendre. Lors de cette enchère, le prix des articles diminue après des intervalles fixés jusqu'à ce que le prix réservé soit atteint. Avant que le prix réservé soit atteint, si le fournisseur fait une offre pour l'article, celui-ci est attribué à ce fournisseur et l'enchère est clôturée pour l'article.

Dans cette enchère, l'acheteur indique un prix de départ, une valeur de modification de prix, un intervalle de temps entre les modifications de prix et le prix réservé.

L'enchère s'ouvre avec le premier article avec le prix de départ spécifié et diminue selon la valeur de modification de prix (montant ou pourcentage) après un intervalle fixé. Le prix de départ diminue jusqu'à ce qu'un fournisseur fasse une offre ou que le prix de départ atteigne le prix réservé. Une fois l'enchère close pour l'article, l'enchère passe à un autre article de manière séquentielle.
L'enchère est clôturée lorsque la soumission d'offres pour tous les articles est terminée.

Pour plus des informations sur comment se connecter sur ganache et metamask, voir le fichier Rapport.md

Pour executer notre contrat veuillez de faire les commandes suivantes 
```js
    truffle compile
    truffle migrate
```