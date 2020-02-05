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
Cagnotte.sol - Contrat de gestion de cagnotte.
Copyright © 2020  FBO Developments <fabio.bonfiglio@fbo.network>

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

pragma solidity ^0.5.14;

import "libs/Administre.sol";
import "libs/SimpleUpgradeable.sol";
import "libs/InterfaceCagnotte.sol";

/// @title Cagnotte
/// @author Fabio Bonfiglio <fabio.bonfiglio@protonmail.ch>
/// @dev Contrat cagnotte publique, décentralisée, sécurisée et démocratique :)
contract Cagnotte is InterfaceCagnotte, Administre, SimpleUpgradeable  {

	bytes32 constant contribMin = keccak256("contributionMinimum");

	// TODO : remplacer accès direct par getters pour les variables membres de _data !!

	/// @param minimum Le montant minimum de contribution pour pouvoir participer
	constructor(uint minimum) public {
		if (minimum == 0) {
			minimum = 1 finney;
		}
		_data.etat = _data.EtatCagnotte.Fermee; // La cagnotte est initialement fermée
		_data.set(contribMin, minimum);
	}

	modifier seulParticipant() {
		require(estParticipant(msg.sender), "NON_PARTICIPANT");
		_;
	}

	modifier seulConfirme() {
		require(estConfirme(msg.sender), "PARTICIPANT_NON_CONFIRME");
		_;
	}

	modifier cagnotteOuverte() {
		if (_data.etat == _data.EtatCagnotte.Fermee) {
			revert("CAGNOTTE_FERMEE");
		}
		else if (_data.etat == _data.EtatCagnotte.Terminee) {
			revert("CAGNOTTE_TERMINEE");
		}
		else if (_data.etat == _data.EtatCagnotte.Ouverte) {
			_;
		}
		else {
			revert("ERREUR_CAGNOTTE");
		}
	}

	/// @dev Méthode interne de contrôle de status d'un participant
	/// @param adr L'adresse du participant à vérifier
	/// @return VRAI si l'adresse a été annoncée comme participant
	function estParticipant(address adr) private view returns (bool) {
		return ( _data.status[adr] != StatusParticipant.Inconnu );
	}

	/// @dev Méthode interne de contrôle de status d'un participant
	/// @param adr L'adresse du participant à vérifier
	/// @return VRAI si le participant est confirmé (et n'est pas annulé).
	function estConfirme(address adr) private view returns (bool) {
		return ( _data.status[adr] == StatusParticipant.Confirme );
	}

	function ouvreCagnotte() public seulActif seulAdmin {
		// TODO : continue !
	}

	function annonceParticipant(Participant adr) external seulActif cagnotteOuverte {
		_data.status[adr] = StatusParticipant.Annonce;
		// TODO : continue !
	}

	function confirmeParticipant() external seulActif cagnotteOuverte seulParticipant {
		_data.status[adr] = StatusParticipant.Confirme;
		// TODO : continue !
	}

	// TODO : continue !
}
