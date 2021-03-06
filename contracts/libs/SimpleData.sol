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
SimpleData.sol - Contrat démonstration du modèle de ségrégation de données
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

import "./Administre.sol";

/// @title SimpleData
/// @author Fabio Bonfiglio <fabio.bonfiglio@protonmail.ch>
/// @dev Contrat de démonstration du modèle de ségrégation des données
contract SimpleData is Administre {
	string constant internal ERR_LOCK = "DATA:LOCKED";
	string constant internal UNCHANGED = "DATA:UNCHANGED";

	//--- Données spécifiques ---
	enum EtatCagnotte { Inconnu, Ouverte, Fermee, Terminee }
	enum StatusParticipant { Inconnu, Annonce, Confirme, Annule }
	struct Participation {
		StatusParticipant status;
		uint index;
		uint montant;
		address payable nomine;
	}
	EtatCagnotte private _etat;
	address[] private _participants;
	mapping (address => Participation) private _participation;

	//--- Données génériques ---
	mapping (bytes32 => bool) private _bool;
	mapping (bytes32 => uint) private _uint;
	mapping (bytes32 => string) private _string;

	//--- Données de contrôle ---
	bool private lock;

	constructor() public {
		lock = false;
	}

	/// @dev Empêche la modification des données en cas de verrouillage
	modifier unlocked() {
		require(!lock, ERR_LOCK);
		_;
	}

	/// @dev Défini l'état de la cagnotte
	/// @param etat L'état à régler
	function setEtatCagnotte(EtatCagnotte etat) public seulProprietaire unlocked {
		require(etat != _etat, UNCHANGED);
		_etat = etat;
	}

	/// @dev Défini une valeur de status
	/// @param adr L'adresse du participant pour lequel on désire changer de status
	/// @param status Le nouveau status auquel définir le participant
	function setStatus(address adr, StatusParticipant status) public seulProprietaire unlocked {
		require(status != _participation[adr].status, UNCHANGED);
		if (_participation[adr].status == StatusParticipant.Inconnu) {
			_participation[adr].index = _participants.length;
			_participants.push(adr);
		}
		_participation[adr].status = status;
	}

	/// @return La valeur d'état de la cagnotte
	function getEtatCagnotte() public view seulProprietaire returns (EtatCagnotte) {
		return _etat;
	}

	/// @return Un tableau contenant les adresses de chaque participant, à utiliser pour itération des mapping
	function getParticipants() public view seulProprietaire returns (address[] memory) {
		return _participants;
	}

	/// @dev Lit le status d'un participant
	/// @param adr L'adresse du participant désiré
	/// @return Le status actuel du participant indiqué
	function getStatus(address adr) public view seulProprietaire returns (StatusParticipant) {
		return _participation[adr].status;
	}

	/// @dev Ajoute le montant à la cagnotte sur le compte du participant et nomine un bénéficiaire
	/// @param part L'adresse du participant
	/// @param val Le montant à ajouter
	/// @param nom L'adresse du bénéficiaire nominé
	function addParticipation(address part, uint val, address payable nom) public seulProprietaire unlocked {
		_participation[part].montant += val;
		_participation[part].nomine = nom;
		if (_participation[part].status != StatusParticipant.Confirme && _participation[part].montant > 0) {
			_participation[part].status = StatusParticipant.Confirme;
		}
	}

	/// @dev Remet le montant de participation à zéro pour le compte indiqué
	/// @param adr L'adresse du participant
	function resetParticipation(address adr) public seulProprietaire unlocked {
		_participation[adr].montant = 0;
		_participation[adr].status = StatusParticipant.Annule;
	}

	/// @dev Lit la valeur actuelle de participation du compte indiqué
	/// @param adr L'adresse du participant
	/// @return Le montant de la participation
	function getParticipation(address adr) public view seulProprietaire returns (uint) {
		return _participation[adr].montant;
	}

	/// @dev Lit le bénéficiaire nominé par un participant
	/// @param adr L'adresse du participant
	/// @return L'adresse du nominé actuel de ce participant
	function getNomine(address adr) public view seulProprietaire returns (address payable) {
		return _participation[adr].nomine;
	}

	/// @dev Défini une valeur booléenne
	/// @param id L'identifiant de la variable à définir
	/// @param newVal La valeur booléenne désirée
	function set(bytes32 id, bool newVal) public seulProprietaire unlocked {
		require(newVal != _bool[id], UNCHANGED);
		_bool[id] = newVal;
	}

	/// @dev Défini une valeur numérique
	/// @param id L'identifiant de la variable à définir
	/// @param newVal La valeur numérique entière (uint) désirée
	function set(bytes32 id, uint newVal) public seulProprietaire unlocked {
		require(newVal != _uint[id], UNCHANGED);
		_uint[id] = newVal;
	}

	/// @dev Défini une chaîne de caractères
	/// @param id L'identifiant de la variable à définir
	/// @param newStr La chaîne de caractères à assigner
	function set(bytes32 id, string memory newStr) public seulProprietaire unlocked {
		require(keccak256(abi.encode(newStr)) != keccak256(abi.encode(_string[id])), UNCHANGED);
		_string[id] = newStr;
	}

	/// @dev Lit une variable booléenne
	/// @param id L'identifiant de la variable à lire
	/// @return La valeur booléenne actuelle de la variable spécifiée
	function getBool(bytes32 id) public seulProprietaire view returns (bool) {
		return _bool[id];
	} 

	/// @dev Lit une variable numérique entière
	/// @param id L'identifiant de la variable à lire
	/// @return La valeur numérique entière (uint) de la variable spécifiée
	function getUint(bytes32 id) public seulProprietaire view returns (uint) {
		return _uint[id];
	}

	/// @dev Lit une chaîne de caractères
	/// @param id L'identifiant de la variable string à lire
	/// @return La chaîne de caractères (string) contenue dans la variable spécifiée
	function getString(bytes32 id) seulProprietaire view public returns (string memory) {
		return _string[id];
	}

	/// @dev Règle le verrouillage des données
	/// @param state TRUE pour verrouiller les données
	function setLock(bool state) seulProprietaire public {
		require(state != lock, UNCHANGED);
		lock = state;
	}
}
