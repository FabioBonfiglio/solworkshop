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

	string constant MSG_TERMINEE = "CAGNOTTE_TERMINEE";

	bytes32 constant contribMin = keccak256("contributionMinimum");
	bytes32 constant tDerniereContrib = kexxak256("timestampDerniereContribution");
	
	event NouveauParticipantConfirme(address indexed participant, uint montant, uint cagnotte);
	event AnnulationParticipant(address indexed participant, uint cagnotte);
	event EtatCagnotte(bool ouverte);

	/// @param minimum Le montant minimum de contribution pour pouvoir participer
	constructor(uint minimum) public {
		if (minimum == 0) {
			minimum = 1 finney;
		}
		_data.setEtatCagnotte(_data.EtatCagnotte.Fermee); // La cagnotte est initialement fermée
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
		if (_data.getEtatCagnotte() == _data.EtatCagnotte.Fermee) {
			revert("CAGNOTTE_FERMEE");
		}
		else if (_data.getEtatCagnotte() == _data.EtatCagnotte.Terminee) {
			revert(MSG_TERMINEE);
		}
		else if (_data.getEtatCagnotte() == _data.EtatCagnotte.Ouverte) {
			_;
		}
		else {
			revert("ERREUR_CAGNOTTE");
		}
	}

	/// @dev Méthode interne de contrôle de status d'un participant
	/// @param adr L'adresse du participant à vérifier
	/// @return VRAI si l'adresse a été annoncée comme participant ou est l'admin
	function estParticipant(address adr) private view returns (bool) {
		return ( _data.getStatus(adr) != _data.StatusParticipant.Inconnu || estAdmin());
	}

	/// @dev Méthode interne de contrôle de status d'un participant
	/// @param adr L'adresse du participant à vérifier
	/// @return VRAI si le participant est confirmé (et n'est pas annulé).
	function estConfirme(address adr) private view returns (bool) {
		return ( _data.getStatus(adr) == _data.StatusParticipant.Confirme );
	}

	function ouvreCagnotte() public seulActif seulAdmin {
		if (_data.getEtatCagnotte() == _data.EtatCagnotte.Terminee) {
			revert(MSG_TERMINEE);
		}
		else {
			_data.setEtatCagnotte(_data.EtatCagnotte.Ouverte);
			emit EtatCagnotte(true);
		}
	}

	function fermeCagnotte() public seulActif seulAdmin {
		if (_data.getEtatCagnotte() == _data.EtatCagnotte.Terminee) {
			revert(MSG_TERMINEE);
		}
		else {
			_data.setEtatCagnotte(_data.EtatCagnotte.Fermee);
			emit EtatCagnotte(false);
		}
	}

	function annonceParticipant(interfaceParticipant adr) external seulActif cagnotteOuverte {
		_data.setStatus(adr, _data.StatusParticipant.Annonce);
	}

	function confirmeParticipant(address payable beneficiaire) external seulActif cagnotteOuverte seulParticipant {
		require(msg.value >= _data.getUint(contribMin) || , "CONTRIBUTION_INSUFFISANTE");
		_data.addParticipation(msg.sender, msg.value, beneficiaire);
		_data.set(tDerniereContrib, now);
		emit NouveauParticipantConfirme(msg.sender, msg.value);
	}

	function annonceAnnulation(interfaceParticipant adr) external seulActif seulConfirme {
		rembourseParticipant(adr);
	}
	
	function rembourseParticipant(interfaceParticipant adr) internal seulActif {
		uint remboursement = _data.getParticipation(adr);
		_data.resetParticipation(adr);
		adr.annuleParticipation.value(remboursement)();
	}

	function montantCagnotte() public view seulActif returns (uint) {
		// TODO : continue !
	}
	
	function termineCagnotte() {
		// TODO : continue !
	}
}
