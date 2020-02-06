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
InterfaceExercice.sol - Contrat description d'interface du premier exercice.
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

/// @dev Le contrat qui implémentera cette interface devra traiter les messages et émettre l'event incluant l'index qui permettra de retrouver le message enregistré.
interface InterfaceExercice {
	event MessageEnregistre(address indexed auteur, uint index);
	function message(string calldata str) external;
	function interroge(uint index) external view returns (string memory);
}
