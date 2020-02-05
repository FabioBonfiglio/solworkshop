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

	mapping (bytes32 => bool) private _bool;
	mapping (bytes32 => uint) private _uint;
	mapping (bytes32 => string) private _string;

	bool private lock;

	constructor() public {
		lock = false;
	}

	/// @dev Empêche la modification des données en cas de verrouillage
	modifier unlocked() {
		require(!lock, ERR_LOCK);
		_;
	}

	/// @dev Lit une variable booléenne
	/// @param id L'identifiant de la variable à lire
	/// @return La valeur booléenne actuelle de la variable spécifiée
	function getBool(bytes32 id) seulProprietaire view public returns (bool) {
		return _bool[id];
	} 

	/// @dev Lit une variable numérique entière
	/// @param id L'identifiant de la variable à lire
	/// @return La valeur numérique entière (uint) de la variable spécifiée
	function getUint(bytes32 id) seulProprietaire view public returns (uint) {
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
		lock = state;
	}
}
