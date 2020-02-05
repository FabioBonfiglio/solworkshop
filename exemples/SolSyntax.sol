/*******************************************************************************

	8888888888 888888b.    .d88888b.           888
	888        888  "88b  d88P" "Y88b          888
	888        888  .88P  888     888          888 
	8888888    8888888K.  888     888      .d88888  .d88b.  888  888
	888        888  "Y88b 888     888     d88" 888 d8P  Y8b 888  888
	888        888    888 888     888     888  888 88888888 Y88  88P
	888        888   d88P Y88b. .d88P d8b Y88b 888 Y8b.      Y8bd8P
	888        8888888P"   "Y88888P"  Y8P  "Y88888  "Y8888    Y88P

********************************************************************************
SolSyntax.sol - Pseudo code source de démonstration de syntaxe Solidity
Copyright © 2020  FBO Developments <fabio.bonfiglio@fbo.network>

-> Mise en page prévue pour affichage dans les slides de la présentation
-> NE COMPILE PAS en l'état. Mettre les dépendances fictives en commentaire pour
	pouvoir compiler.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*******************************************************************************/

pragma solidity ^0.5.0; // Syntaxe de version range identique à npm : https://docs.npmjs.com/misc/semver#ranges

import "Dependance.sol"; // Imports similaires à JavaScript ES6 avec quelques variantes
import "Lib01.sol" as maLibrairie; // Variante possible
import {get as recup, set} from "Dep02.sol"; // Import comme alias pour éviter les conflits de nom.
import {get, set as regle} from "../Dep03.sol";

/// @title Administré
/// @dev À hériter pour implémenter le modifier de restriction d'administration
contract Administre {
	string constant internal NON_ADMIN = "NON_ADMINISTRATEUR";
	string constant internal BAD_ADDRESS = "MAUVAISE_ADRESSE";
	address private admin;

	event NouvelAdministrateur(address indexed adminPrecedent, address indexed nouvelAdmin);

	constructor() internal {
		address msgSender = msg.sender;
		admin = msgSender;
		emit NouvelAdministrateur(address(0), msgSender);
	}

	modifier seulAdmin() {
		require(estAdmin(msg.sender), NON_ADMIN);
		_;
	}

	/// @notice Contrôle si l'apellant est l'administrateur du contrat
	/// @param adr L'adresse à tester
	/// @return Vrai si l'adresse spécifiée est l'administrateur du contrat
	function estAdmin(address adr) public view returns (bool) {
		return (adr == admin); 
	}
	
	/// @dev Méthode abstraite à implémenter dans le contrat héritant
	function transfereAdmin(address nouvAdmin) external seulAdmin;
	
	/// @dev Méthode interne de transfert d'administration
	function _transfAdmin(address nouvAdmin) internal { // private rendrait obligatoire l'implémentation locale de transfereAdmin
		if (nouvAdmin == address(0)) {
			revert(BAD_ADDRESS);
		}
		else {
			admin = nouvAdmin;
			emit NouvelAdministrateur(adminPrecedent, nouvelAdmin);
		}
	}
}

/// @title MesDonnees
/// @author Fabio Bonfiglio <fabio.bonfiglio@fbo.network>
/// @dev Contrat de démonstration de syntaxe Solidity - NE PAS UTILISER !
/// @notice Contrat de stockage de données privées sur la blockchain Ethereum.
/// @dev J'espère que vous avez compris pourquoi il ne faut PAS L'UTILISER !
contract MesDonnees is Administre {
	string private monNom;
	bool public original = true;

	event ChangementDeNom(address indexed auteur, string nouveauNom);

	constructor(string calldata nom) public {
		monNom = nom;
	}

	/// @notice Permet de changer le nom
	/// @dev Une valeur d'émolument >= 0.001 ether doit être passée avec la transaction
	/// @param nom Le nouveau nom à enregistrer
	function changeNom(string calldata nom) public seulAdmin {
		require(msg.value >= 1 finney, "Émolument pas assez élevé!"); // 1 finney = 0.001 ether = 1e15 (wei)
		string storage pNom = monNom;	// Allocation storage -> passation par référence
		string memory _nom = nom;			// Allocation memory -> passation par copie
		require(keccak256(abi.encodePacked(_nom)) != keccak256(abi.encodePacked(pNom)), "Aucun changement de nom!");
		while (original) {
			original = false;
		}
		pNom = _nom;
		emit ChangementDeNom(msg.sender, _nom);
	}

	function quelEstMonNom() public view seulAdmin returns (string, bool) {
		return (monNom, original);
	}

	function transfereAdmin(address nouvAdmin) external seulAdmin {
		original = false;
		_transfAdmin(nouvAdmin);
	}
}
