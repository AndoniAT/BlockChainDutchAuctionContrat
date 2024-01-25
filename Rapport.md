# UNIVERSITE NORMANDIE LE HAVRE

## Andoni ALONSO TORT
## MASTER 2 IWOCS
22/12/2022


## INSTRUCTIONS

Le projet consiste à créer un Smart Contract (SC) permettant de réaliser une enchère ascendante Hollandaise.
Une enchère ascendante hollandaise est un document électronique (RFx) [2] qui contient une liste d'articles que des acheteurs veulent vendre. Lors de cette enchère, le prix des articles diminue après des intervalles fixés jusqu'à ce que le prix réservé soit atteint. Avant que le prix réservé soit atteint, si le fournisseur fait une offre pour l'article, celui-ci est attribué à ce fournisseur et l'enchère est clôturée pour l'article.

Dans cette enchère, l'acheteur indique un prix de départ, une valeur de modification de prix, un intervalle de temps entre les modifications de prix et le prix réservé.

L'enchère s'ouvre avec le premier article avec le prix de départ spécifié et diminue selon la valeur de modification de prix (montant ou pourcentage) après un intervalle fixé. Le prix de départ diminue jusqu'à ce qu'un fournisseur fasse une offre ou que le prix de départ atteigne le prix réservé. Une fois l'enchère close pour l'article, l'enchère passe à un autre article de manière séquentielle.
L'enchère est clôturée lorsque la soumission d'offres pour tous les articles est terminée.


## ETAPES

1. Premierement  on va faire un fork du projet « dutch-auction » sur girlab :


![](./ImagesProject/1_fork_project.png)

2. Faire les installations requises

	2.2.NodeJs

	Si vous avez pas node installé, vous pouvez aller sur le site nodejs.org

    ![](./ImagesProject/2_nodejs.png)

    2.2 Installer GANACHE

	Ganache est une blockchain personnelle pour le développement rapide 	d'applications distribuées Ethereum et Filecoin. Vous pouvez utiliser Ganache tout au long 	du cycle de développement ; vous permettant de développer, déployer et tester vos dApps 	dans un environnement sûr et déterministe.
    <br/>
	Ganache est disponible en deux versions : une interface utilisateur et une CLI. 	Ganache UI est une application de bureau prenant en charge la technologie Ethereum et 	Filecoin. Notre outil de ligne de commande plus robuste, ganache, est disponible pour le 	développement d'Ethereum.
    <br/>
	
	- Telercharger
    https://trufflesuite.com/docs/ganache/quickstart/#1-install-ganache
    

	Une fois le fichier telecharger faire click droit dans le fichier et activer l’option de « Allow 	executing  file as program »
    <br/>
	Puis on peut écxecuter, on verra l‘écran suivant:
    <br/>

    ![](./ImagesProject/3_Run_Ganache.png)

    <br/>
    Ici on sélectionnera NEW WORKSPACE avec ETHEREUM, puis on aure cet écran :
    <br/><br/>

    ![](./ImagesProject/4_Workspace_ganache.png)

    - Donner un nom au projet.
	- Appuyer sur « start ». 

    ![](./ImagesProject/5_Start_Ganache.png)

    <br/>
    2.2 TRUFFLE

    <br/>
	Truffle est un environnement de développement de classe mondiale, un cadre de test et un pipeline d'actifs pour les blockchains utilisant la machine virtuelle Ethereum (EVM), visant à faciliter la vie des développeurs.

    https://trufflesuite.com/docs/truffle/quickstart/

    ![](./ImagesProject/6_Install_Truffle.png)
    ![](./ImagesProject/7_Install_Truffle_terminal.png)

    <br/><br/>
    Avant de continuer avec la création du projet, faire la dernière installation

    2.3 MetaMask
    <br>

    Un portefeuille Ethereum dans votre navigateur

    MetaMask est une extension permettant d'accéder aux applications distribuées compatibles Ethereum, ou « Dapps » dans votre navigateur !
    <br/>
    L'extension injecte l'API Ethereum web3 dans le contexte javascript de chaque site Web, afin que les dapps puissent lire à partir de la blockchain.

    Chercher dans les extensions de notre navigateur 
    ![Alt text](./ImagesProject/8_MetaMask_Add.png)

    ![Alt text](./ImagesProject/9_CreateWallet_MetaMask.png)

    Puis suivre les instructions :
        - Créer un mot de passe
        - Cliquer sur "Remind me later(not recommended)"

    ![Alt text](./ImagesProject/10_Creation_Reussit.png)

    Vous devriez avoir cette page :

    ![Alt text](./ImagesProject/11_Menu_MetaMask.png)

3. Création du projet

Un fois tout installé on peut revenir sur https://trufflesuite.com/docs/truffle/quickstart/ à la partie "Create a projet" pour commencer notre projet

Vous pouvez créer un projet simple sans contrats intelligents à l'aide de truffle init, mais pour ceux qui débutent, vous pouvez utiliser des Truffle Boxes, qui sont des exemples d'applications et de modèles de projet. Nous utiliserons la boîte MetaCoin, qui crée un jeton pouvant être transféré entre comptes. Notez que ce n'est pas compatible ERC-20.
-  Telecharger ("unbox") la boîte MetaCoin :

```
truffle unbox metacoin [PATH/TO/DIRECTORY]
```

Une fois cette opération terminée, vous disposerez désormais d'une structure de projet avec les éléments suivants :

contrats/ : Annuaire des contrats Solidité
migrations/ : répertoire pour les fichiers de déploiement scriptables
test/ : Répertoire des fichiers de test pour tester votre application et vos contrats
truffle.js : fichier de configuration de truffe

Si vous utilisez VSCode vous pouvez installer l'extention solidity
![](./ImagesProject/12_Solidity_extension.png)

Pour executer tous les tests dans test/metacoin.js vous pouvez utiliser la commande :

```
    truffle test
```
![](./ImagesProject/13_Tests_passed.png)


Pour compiler le projet
```
    truffle compile
```

4. Ajouter Ganache à Truffle
    4.1 truffle-config.js
    Aller vers ce fichier et enlever les commentaires pour development
    ![](./ImagesProject/14_truffle_config.png)

    4.2 Ajouter truffle config dans ganache
    ![](./ImagesProject/15_Ajout_truffle_config_a_ganache.png)

    NOTE : Penser à mettre le même port sur votre truffle_config que RPC server sur Ganache

    Cliquer sur "Save and restart"

5. MetaMask networks
    Ajouter un nouveau réseau dans MetaMask

    ![](./ImagesProject/16_Add_network.png)


    ![](./ImagesProject/17_Netword_created.png)

    Cliquer sur click to local

    ![](./ImagesProject/18_Add_account_or_wallet.png)

    Cliquer sur add account or hardwallet
    et puis cliquer sur "Import account"

    Aller ver ganache et copier une clé privé
    ![](./ImagesProject/19_Private_key_copy.png)

    Vous devriez la voir apparaître ici

    ![](./ImagesProject/20_Metamask_imported.png)


    5. Migration
        Pour tester la migration on peut utiliser la commande 
        ```
            truffle migrate
        ```
        ![](./ImagesProject/21_truffle_migrate_test.png)

        Après on peut aller vers le site MetaMask et on peuit voir que la valeur a diminué

        ![](./ImagesProject/22_Decreased_value_metamask.png)

## ENCHERE HOLLANDAISE

Pour notre enchere hollandaise on a crée un contrat appelé DutchAuction, on a etabli un prix initial de 1 ether et la duration de l'enchere d'une heure.
Le prix d'un article diminue chaque 60 secondes, après on passe à l'article suivant

Pour executer notre contrat veuillez de faire les commandes suivantes 
```js
    truffle compile
    truffle migrate
```
Vous devriez voir votre contrat deployé sur Ganache
![](./ImagesProject/23_Migrate_Contract.png)

### Test
    Une fois le contrat deployé on vous pouvez executer les test :

```js
    truffle test
```
![](./ImagesProject/24_Test.png)


=== CLIENT ====

Pour voir la partie du projet coté client web, veuillez aller vers

https://www-apps.univ-lehavre.fr/forge/aa204303/dutch-auction-dapp.git


