# Solidity workshop

## TODO
- [ ]  Synchroniser la branche `master` avec https://github.com/FabioBonfiglio/solworkshop.git
- [ ]  Implémenter Cagnotte
- [ ]  Implémenter interface Participant
- [ ]  Implémenter Donateur (solution) sur branche `develop` à protéger pour qu'elle soit également publiées sur gitub

## À propos
Cet atelier d'initiation à Solidity et au développement de _smart contracts_ a été créé par [Fabio Bonfiglio](https://www.linkedin.com/in/fabiobonfiglio/).  
Il est en license GNU GPLv3 et donc peut être copié et adapté librement.  
> :warning: **Ne pas utiliser en production (sur _Main Net_) avec de vrais fonds !!** Ces contrats n'ont pas été audités en matière de sécurité et vulnérabilités. Ils ont une **vocation éducative** uniquement.

## Contenu
Ce dépôt git contient les fichiers nécessaires pour les exercices, et tests, ainsi que front-ends de base des contrats.  
Également ci-après, un recueil de liens utiles.

## Pré-requis et tests
Pour pouvoir tester les contrats, `truffle` est requis. Si vous ne l'avez pas encore, vous pouvez l'installer depuis un terminal :
```sh
npm install truffle -g
```

Vous pouvez ensuite lancer les tests avec la commande :
```sh
truffle test
```

## Installation front-ends
Pour lancer le front-end sur un serveur web local, après avoir cloné le dépôt, installer les dépendances, depuis un terminal :
```sh
cd solworkshop/frontend
npm install
```
puis lancer avec
```sh
npm start
```

## Adaptation à votre contrat
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
