# Solidity workshop
> :warning: Ce dépôt github est synchronisé automatiquement depuis un serveur Gitlab privé. C'est ce dernier qui est utilisé pour le développement. Pour toute contribution ou merge request, veuillez contacter le maintainer.

> :warning: L'exercice 2 est encore en développement.

## À propos
Cet atelier d'initiation à Solidity et au développement de _smart contracts_ a été créé par [Fabio Bonfiglio](https://fabio_bonfiglio.keybase.pub/).  
Il est en license GNU GPLv3 et donc peut être copié et adapté librement.  
> :warning: **Ne pas utiliser en production (sur _Main Net_) avec de vrais fonds !!** Ces contrats n'ont pas été audités en matière de sécurité et vulnérabilités. Ils ont une **vocation éducative** uniquement.

## Contenu
Ce dépôt git contient les fichiers nécessaires pour les exercices, et tests, ainsi que front-ends de base des contrats.  
Également ci-après, un recueil de liens utiles.

## Exercice 1
1. Implémenter un contrat qui utilise l'interface `exemples/InterfaceExercice.sol`.
2. Modifier ce contrat pour que seul l'auteur d'un message puisse le récupérer.

## Exercice 2 - Cagnotte démocratique
Développement d’un système de cagnotte décentralisée, sécurisée et démocratique.
- Un contrat `Cagnotte.sol` est déployé
	- La cagnotte tient le compte des participants et du montant des participations
	- Ce contrat tient également le compte des nominations au titre de bénéficiaire final
	- La cagnotte distribuera la totalité de son contenu à chaque nominé proportionnellement aux votes reçus
- Chaque « donateur » peut alors déployer son propre contrat, répondant à l’interface `libs/Participant.sol`.
	- Le constructeur du contrat doit designer à quelle cagnotte il doit participer, en utilisant l'interface `libs/InterfaceCagnotte.sol`
	- Chaque « donateur » peut nominer un bénéficiaire final pour lequel il donne son vote
	-	Chaque « donateur » peut se retirer à tout moment tant que l’attribution finale n’a pas été exécutée

### Pré-requis et tests
Pour pouvoir tester les contrats, `truffle` est requis. Si vous ne l'avez pas encore, vous pouvez l'installer depuis un terminal :
```sh
npm install truffle -g
```

Vous pouvez ensuite lancer les tests avec la commande :
```sh
truffle test
```

### Interaction et tests du contrat
Pour tester et interagir avec le contrat sur une chaîne de test locale, utiliser la [console truffle](https://www.trufflesuite.com/docs/truffle/getting-started/using-truffle-develop-and-the-console):
```sh
truffle develop
```
On pourra alors se connecter à l'instance du contrat via les commandes d'[abstraction](https://www.trufflesuite.com/docs/truffle/reference/contract-abstractions).

### Adaptation à votre contrat
Pour modifier le front end afin qu'il soit adapté à votre propre contrat, merci de travailler sur votre branche :
```sh
git checkout -b nomDeMaBranche
```
> Veuillez [signer vos commits](https://help.github.com/en/github/authenticating-to-github/signing-commits) si vous voulez que votre (excellent!) travail soit mergé.

Créez ensuite votre contrat à la racine du répertoire `/contracts` (au même niveau que `Cagnotte.sol`)

## Liens utiles
### Ethereum Virtual Machine
- Ethereum [Yellow Paper](https://ethereum.github.io/yellowpaper/paper.pdf)
- Ethereum [White Paper](https://github.com/ethereum/wiki/wiki/White-Paper)
- Ethereum [Wiki](https://github.com/ethereum/wiki/wiki)

#### Articles
> :warning: Attention ces articles sont anciens et certaines choses peuvent avoir évolué. Mais ils présentent de bonnes explications de base qui restent globalement valables.
- "_An [overview for confused developers](https://medium.com/@olxc/ethereum-and-smart-contracts-basics-e5c84838b19)_"
- [_How does Ethereum work, anyway?_](https://www.preethikasireddy.com/post/how-does-ethereum-work-anyway)

### Solidity
- Référence officielle: https://solidity.readthedocs.io  
:point_right: Ne pas oublier de sélectionner la version en bas à gauche de l'écran (clic sur `latest`).  
- [X=Solidity](https://learnxinyminutes.com/docs/solidity/) sur _Learn X in Y minues_
- [Solidity Cheatsheet](https://topmonks.github.io/solidity_quick_ref/) (pour versions `>=0.4.25 <0.5.0`)
- [Solidity by Example](https://solidity-by-example.org)

> :warning: Attention aux _cheat sheets_ que l'on peut trouver sur internet. Il y a plusieurs _breaking changes_ entre les versions `^0.4.0`, [`^0.5.0`](https://solidity.readthedocs.io/en/v0.5.0/050-breaking-changes.html) et [`^0.6.0`](https://solidity.readthedocs.io/en/v0.6.0/060-breaking-changes.html). Le [site officiel](https://solidity.readthedocs.io) reste la meilleure source en cas de doute.

#### Compilateurs
- [solc](https://github.com/ethereum/solidity)
- [solcjs](https://github.com/ethereum/solc-js)

### Outils de développement
#### Éditeurs
##### Standalone
- [Atom](https://atom.io/) avec les plugins suivants :
	- [language-ethereum](https://atom.io/packages/language-ethereum)
	- [etheratom](https://atom.io/packages/etheratom) (avec compilateurs intégrés et interface de contrats)
	- [autocomplete-solidity](https://atom.io/packages/autocomplete-solidity)
	- [linter-solidity](https://atom.io/packages/linter-solidity)
- [VS Code](https://code.visualstudio.com/) avec le plugin suivant :
	- [vscode-solidity](https://github.com/juanfranblanco/vscode-solidity) (avec compilateurs multi-versions intégrés et support [EIP82](https://github.com/ethereum/EIPs/issues/82))
- [Sublime Text](https://www.sublimetext.com/) avec le plugin suivant:
	- [SublimeEthereum](https://github.com/davidhq/SublimeEthereum)

##### Online
- [Remix Ethereum IDE](https://remix.ethereum.org) pour les projets de contrats simples
- [Ethereum Studio](https://superblocks.com/ethereum-studio/) Incluant développement de front-ends HTML5 avec support [EIP82](https://github.com/ethereum/EIPs/issues/82)

#### Noeuds Ethereum
Si vous voulez mettre en place un noeud Ethereum, sur votre machine ou sur un serveur privé (recommandé au moins 8 GB RAM et 4 coeurs + 1TB **SSD**):
- Pour un noeud _Main net_ : [Parity Ethereum](https://github.com/paritytech/parity-ethereum/releases) (implémentation en Rust)
- Pour un noeud _Main net_ ou réseau de test (_Rinkeby_ par exemple) : [Geth](https://geth.ethereum.org/docs/install-and-build/installing-geth) (implémentation en Go)

#### Frameworks
- [Truffle](https://www.trufflesuite.com/truffle)
- [Embark](https://framework.embarklabs.io/docs/)
- [Waffle](https://getwaffle.io/)

#### Outils divers
- [Ganache](https://www.trufflesuite.com/ganache) Blockchain de développement, avec GUI ou en ligne de commande.
- [Infura](https://infura.io/) Comptes de développement gratuits pour l'accès direct de _dapps_ depuis internet aux blockchains _Main net_ ou de test (Rinkeby, etc.) et IPFS, sans passer par un provider (peut être utile pour des PWA sur mobile par exemple).
- [EthFiddle](https://ethfiddle.com/) pour tester des snippets
- [solhint](https://github.com/protofire/solhint) linter
- [solgraph](https://github.com/raineorshine/solgraph) aide à l'analyse
