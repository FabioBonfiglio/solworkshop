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
Administre.sol - for own(able/ed) contracts (french-documented)
Copyright (C) 2019  FBO Developments <fabio.bonfiglio@fbo.network>

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

pragma solidity ^0.5.12;

/// @title Administré
/// @dev À hériter pour donner des propriétés et restrictions d'administration.
/// @dev Permet également un système de (255) niveaux d'autorisation d'accès.
contract Administre {

	string constant internal ERR_NON_ADMIN = "ADMIN:NON_ADMINISTRATEUR";
	string constant internal ERR_NON_PROPRIERAIRE = "ADMIN:NON_PROPRIETAIRE";
	string constant internal ERR_NON_AUTORISE = "ADMIN:NON_AUTORISE";
	string constant internal ERR_MAUVAISE_ADRESSE = "ADMIN:MAUVAISE_ADRESSE";

	address private admin;
	mapping (address => uint8) private autorisations;

	event NouvelAdministrateur(address indexed adminPrecedent, address indexed nouvelAdmin);
	event NouvelleAutorisation(address indexed nouvelAutorise, uint8 niveau);

	/// @dev Le "déployeur" est l'administrateur de départ
	constructor() internal {
		address msgSender = msg.sender;
		admin = msgSender;
		emit NouvelAdministrateur(address(0), msgSender);
	}

	/// @dev Exception si l'apellant n'est pas l'admin
	modifier seulAdmin() {
		require(estAdmin(), ERR_NON_ADMIN);
		_;
	}

	/// @dev Exception si l'apellant n'a pas d'autorisation
	/// @param niveau Le niveau d'autorisation requis
	modifier seulAutorise(uint8 niveau) {
		require(estAutorise(niveau), ERR_NON_AUTORISE);
		_;
	}

	/// @dev Exception si l'apellant n'est pas propriétaire des données (Data.sol)
	modifier seulProprietaire() {
		require(estAdmin(), ERR_NON_PROPRIERAIRE);
		_;
	}

	/// @dev Pour connaître l'administrateur courant
	/// @return L'adresse de l'administrateur courant
	function administrateur() public view returns (address) {
		return admin;
	}

	/// @dev Contrôle si l'apellant est l'administrateur ou un délégué (aut. >=128)
	/// @return Vrai si l'apellant est l'administrateur
	function estAdmin() public view returns (bool) {
		return (msg.sender == admin) || (estAutorise(0xF0));
	}

	/// @dev Contrôle si l'apellant a le niveau d'autorisation requis
	/// @param niveau Le niveau d'autorisation minimal requis
	/// @return Vrai si l'apellant est autorisé au niveau spécifié
	function estAutorise(uint8 niveau) public view returns (bool) {
		return autorisations[msg.sender] >= niveau;
	}
	
	/// @dev Modifie le niveau d'autorisation d'une adresse-identité
	/// @param id L'adresse-identité à qui conférer le niveau d'autorisation
	/// @param niveau Le nouveau niveau d'autorisation (0 pour révoquer)
	function autorise(address id, uint8 niveau) public seulAdmin() {
		autorisations[id] = niveau;
		emit NouvelleAutorisation(id, niveau);
	}

	/// @dev Abandon de l'administration :warning:
	function abandonneAdministration() public seulAdmin() {
		admin = address(0);
		emit NouvelAdministrateur(admin, address(0));
	}

	/// @dev Transfère les droits d'administration à un autre compte.
	/// @param nouvelAdmin L'adresse du nouvel administrateur
	function transfereAdministration(address nouvelAdmin) public seulAdmin() {
		_transfAdmin(nouvelAdmin);
	}

	/// @dev Fonction interne de transfert d'administration.
	/// @param nouvelAdmin L'adresse du nouvel administrateur
	function _transfAdmin(address nouvelAdmin) internal {
		require(nouvelAdmin != address(0), ERR_MAUVAISE_ADRESSE);
		address ancienAdmin = admin;
		admin = nouvelAdmin;
		emit NouvelAdministrateur(ancienAdmin, nouvelAdmin);
	}
}
