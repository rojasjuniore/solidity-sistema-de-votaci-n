// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

// -----------------------------------
//  CANDIDATO   |   EDAD   |      ID
// -----------------------------------
//  Toni        |    20    |    12345X
//  Alberto     |    23    |    54321T
//  Joan        |    21    |    98765P
//  Javier      |    19    |    56789W

contract Votacion {
    // Direccion del propretario del contrato
    address public owner;

    // Construtor
    constructor() public {
        owner = msg.sender;
    }

    // Relacion entre el nombre del candidto y el hash de sus datos persoanles
    mapping(string => bytes32) public id_candidatos;

    // Relacion entre el hash de los datos personales de un candidato y el numero de votos
    mapping(bytes32 => uint256) public votos_candidatos;

    // Lista para almacenar los nombres de los candidatos
    string[] public candidatos;

    // Lista para almacenar los hash de los votantes
    bytes32[] public votantes;

    // Funcion para registrar un candidato, para las eleciones
    function Representar(
        string memory _nombrePersona,
        uint256 _edadDePersona,
        string memory _idPersonas
    ) public {
        // calcular el hash de los datos del candidato
        bytes32 _hash_candidato = keccak256(
            abi.encodePacked(_nombrePersona, _edadDePersona, _idPersonas)
        );

        // almacenar el hash de los datos del candidato
        id_candidatos[_nombrePersona] = _hash_candidato;

        // almacenar el nombre del candidato
        candidatos.push(_nombrePersona);
    }
}
