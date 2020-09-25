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
SimpleUpgradeable.sol - Démonstration du modèle de ségrégation de données
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
import "./SimpleData.sol";

/// @title SimpleUpgradeable
/// @author Fabio Bonfiglio <fabio.bonfiglio@protonmail.ch>
/// @dev Contrat de démonstration du modèle d'upgradabilité à ségrégation des données
contract SimpleUpgradeable is Administre {

	SimpleData _data;

	address payable nouveauContrat;
	bool private _upgraded;

	event Upgrade(address nouvelleVersion);

	constructor (SimpleData adr) internal {
		if (address(adr) == address(0)) {
			_data = new SimpleData();
		}
		else {
			_data = adr;
		}
		_upgraded = false;
		nouveauContrat = address(0);
	}

	/// @dev Seul un contrat actif peut apeller
	modifier seulActif() {
		require(!_upgraded, "CONTRACT INACTIF/UPGRADED");
		_;
	}

	/// @dev Teste si un contrat est actif
	/// @return TRUE si le contrat est actif
	function estActif() public view returns (bool) {
		return !_upgraded;
	}

	/// @dev Méthode d'upgrade d'un contrat et transfert de données
	/// @param _new Adresse du nouveau contrat
	function upgrade(address payable _new) seulAdmin seulActif external {
		_upgraded = true;
		_data.transfereAdministration(_new);
		nouveauContrat = _new;
		emit Upgrade(_new);
	}
}
