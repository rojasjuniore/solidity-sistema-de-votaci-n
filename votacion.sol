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
    mapping(string => uint256) public votos_candidato;

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

    // funcion para ver candidatos registrados
    function VerCandidatos() public view returns (string[] memory) {
        // retornar la lista de candidatos
        return candidatos;
    }

    // funcion para registrar los votos
    function Votar(string memory _candidato) public {
        // calcular el hash del votante
        bytes32 _hash_votante = keccak256(abi.encodePacked(msg.sender));

        // verificar que el votante no haya votado ya
        for (uint256 index = 0; index < votantes.length; index++) {
            require(votantes[index] != _hash_votante, "Ya has votado");
        }

        // almacenar el hash del votante
        votantes.push(_hash_votante);

        // Añadiendo un voto al candidato
        votos_candidato[_candidato]++;
    }

    // se puede ver el numero de votos de un candidato
    function VerVotos(string memory _candidato) public view returns (uint256) {
        // se devuelve el numero de votos del candidato
        return votos_candidato[_candidato];
    }

    //Funcion auxiliar que transforma un uint a un string
    function uint2str(uint256 _i)
        internal
        pure
        returns (string memory _uintAsString)
    {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len - 1;
        while (_i != 0) {
            bstr[k--] = bytes1(uint8(48 + (_i % 10)));
            _i /= 10;
        }
        return string(bstr);
    }

    // Ver Resultafos de las elecciones
    function VerResultados() public view returns (string memory) {
        // guardamos en una variables strinf sus candidatos y sus votos
        string memory resultados = "";

        for (uint256 index = 0; index < candidatos.length; index++) {
            resultados = string(
                abi.encodePacked(
                    resultados,
                    " ( ",
                    candidatos[index],
                    " , ",
                    uint2str(VerVotos(candidatos[index])),
                    " ) ---- "
                )
            );
        }

        // Devolvemos resultados
        return resultados;
    }

    //Proporcionar el nombre del candidato ganador
    function Ganador() public view returns (string memory) {
        //La variable ganador va a contener el nombre del candidato ganador
        string memory ganador = candidatos[0];
        //La variable flag nos sirve para la situacion de empate
        bool flag;

        //Recorremos el array de candidatos para determinar el candidato con un numero mayor de votos
        for (uint256 i = 1; i < candidatos.length; i++) {
            //Comparamos si nuestro ganador ha sido superado por otro candidato
            if (votos_candidato[ganador] < votos_candidato[candidatos[i]]) {
                ganador = candidatos[i];
                flag = false;
            } else {
                //Miramos si hay empate entre los candidatos
                if (
                    votos_candidato[ganador] == votos_candidato[candidatos[i]]
                ) {
                    flag = true;
                }
            }
        }

        //comprobamos si ha habido un empate entre los candidatos
        if (flag == true) {
            //Informamos del empate
            ganador = "¡Hay un empate entre los candidatos!";
        }

        //Devolvemos el ganador
        return ganador;
    }
}
