// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 < 0.9.0;
contract StudentsManager{

    address owner;
    struct Grade{
        uint grade;
        string subject;
    }

    struct Student{
        string firstName;
        string lastName;
        uint numberOfGrade;
        mapping(uint => Grade) grades;
    }
    mapping(address => Student) students;
    
    constructor(){
        // On a attribue à owner le premier de la première transaction
        // C'est à dire , celui qui déploie le smart contract
        owner = msg.sender; 
    }

    modifier isOwner(){
        require(owner == msg.sender, unicode"Vous n'êtes pas autorisé à effectuer cette action");
        _;
    }
    //Vérfier l'existance d'un etudiant
    modifier studentExist(address _add){
        require(bytes(students[_add].firstName).length !=0, unicode"L'étudiant n'est pas inscrit. Veuillez d'abord l'ajouter");
        _;
    }
    //Seul le propriétaire du smart contract doit exécuter cette fonction. On rajouter donc le modifier isOwner
    function addStudent(address _address, string memory _firstName, string memory _lastName) public isOwner{
        //Vérifier si l'étudiant existe déjà
        require(bytes(students[_address].firstName).length == 0 && bytes(students[_address].lastName).length == 0, unicode"Cet étudiant existe déjà");

        students[_address].firstName = _firstName;
        students[_address].lastName = _lastName;

    }

    //Ajouter une note à l'étudiant 
    function addGrade(address _address, string memory _subject, uint _grade) public isOwner studentExist(_address){
        students[_address].grades[students[_address].numberOfGrade].subject = _subject;
        students[_address].grades[students[_address].numberOfGrade].grade = _grade;
        /*
            //On incrémente le nombre de notes de l'étudiant
            Par défaut, c'est de 0. 
            Cette variable sert d'index au mapping grades. Plus il
        */
        students[_address].numberOfGrade++;  

    }

    function getGrades(address _address) public isOwner view returns(uint[] memory) {
        uint length = students[_address].numberOfGrade;
        uint[] memory _grades = new uint[](length);

        for(uint i = 0; i < length; i++){
            _grades[i] = students[_address].grades[i].grade;
        }

        return _grades;
    }
}