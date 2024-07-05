// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.1;

/**
 * @title ETHACCRA Hackathon Registration Smart Contract
 * @dev This contract manages student registrations for the ETHACCRA hackathon.
 * It handles both in-person and online participants, collects necessary information,
 * and provides various utility functions for managing registrations.
 * The contract includes safeguards against common edge cases and allows for 
 * registration updates.
 */

contract ETHACCRA {
    // Enums for categorizing student data
    enum Skillset { Developer, Designer, Writer, Presenter }
    enum ParticipationType { InPerson, Online }
    enum DietaryRestriction { None, Vegetarian, Vegan, GlutenFree, NutFree, DairyFree, Other }
    
    // Struct to store comprehensive student information
    struct StudentData {
        string name;
        uint8 age;
        string email;
        Skillset skillset;
        ParticipationType participationType;
        bool needsLodging;
        DietaryRestriction dietaryRestriction;
        bool isRegistered;
    }

    // State variables
    uint8 public minimumAge = 18;
    uint8 public constant ABSOLUTE_MINIMUM_AGE = 13; // Absolute minimum age limit
    address public organizer;
    uint256 public constant MAX_REGISTRATIONS = 1000; // Maximum number of registrations

    // Mappings and arrays for storing student data
    mapping(address => StudentData) public students;
    address[] public registeredAddresses;

    // Events for logging registration attempts and updates
    event RegistrationAttempt(address indexed student, bool success, string message);
    event RegistrationUpdate(address indexed student, bool success, string message);

    /**
     * @dev Constructor sets the contract deployer as the organizer
     */
    constructor() {
        organizer = msg.sender;
    }

    /**
     * @dev Modifier to restrict certain functions to the organizer
     */
    modifier onlyOrganizer() {
        require(msg.sender == organizer, "Only organizer can call this function");
        _;
    }

    /**
     * @dev Modifier to validate the age of registering students
     * @param _age Age to validate
     */
    modifier validAge(uint8 _age) {
        require(_age >= minimumAge && _age < 100, "Invalid age");
        _;
    }

    /**
     * @dev Allows the organizer to change the minimum age requirement
     * @param _newMinimumAge New minimum age to set
     */
    function setMinimumAge(uint8 _newMinimumAge) public onlyOrganizer {
        require(_newMinimumAge >= ABSOLUTE_MINIMUM_AGE, "Minimum age cannot be less than 13");
        minimumAge = _newMinimumAge;
    }

    /**
     * @dev Registers a new student for the hackathon or updates existing registration
     * @param _name Student's name
     * @param _age Student's age
     * @param _email Student's email
     * @param _skillset Student's primary skillset
     * @param _participationType In-person or online participation
     * @param _needsLodging Whether the student needs lodging (for in-person)
     * @param _dietaryRestriction Any dietary restrictions of the student
     */
    function registerOrUpdateStudent(
        string memory _name, 
        uint8 _age, 
        string memory _email,
        Skillset _skillset, 
        ParticipationType _participationType, 
        bool _needsLodging, 
        DietaryRestriction _dietaryRestriction
    ) public validAge(_age) {
        require(registeredAddresses.length < MAX_REGISTRATIONS, "Maximum registrations reached");

        if (!students[msg.sender].isRegistered) {
            registeredAddresses.push(msg.sender);
            emit RegistrationAttempt(msg.sender, true, "Registration successful");
        } else {
            emit RegistrationUpdate(msg.sender, true, "Registration updated");
        }

        students[msg.sender] = StudentData({
            name: _name,
            age: _age,
            email: _email,
            skillset: _skillset,
            participationType: _participationType,
            needsLodging: _needsLodging,
            dietaryRestriction: _dietaryRestriction,
            isRegistered: true
        });
    }

    /**
     * @dev Retrieves a student's data by their Ethereum address
     * @param _studentAddress Address of the student to query
     * @return StudentData struct containing the student's information
     */
    function getStudentByAddress(address _studentAddress) public view returns (StudentData memory) {
        require(students[_studentAddress].isRegistered, "Student not registered");
        return students[_studentAddress];
    }

    /**
     * @dev Checks if a student is registered
     * @param _studentAddress Address of the student to check
     * @return bool indicating if the student is registered
     */
    function isStudentRegistered(address _studentAddress) public view returns (bool) {
        return students[_studentAddress].isRegistered;
    }

    /**
     * @dev Gets the total count of registered students
     * @return uint256 Total number of registered students
     */
    function getTotalRegisteredStudents() public view returns (uint256) {
        return registeredAddresses.length;
    }

    /**
     * @dev Gets the count of in-person students
     * @return uint256 Number of in-person students
     */
    function getInPersonStudentsCount() public view returns (uint256) {
        uint256 count = 0;
        for (uint i = 0; i < registeredAddresses.length; i++) {
            if (students[registeredAddresses[i]].participationType == ParticipationType.InPerson) {
                count++;
            }
        }
        return count;
    }

    /**
     * @dev Gets the count of online students
     * @return uint256 Number of online students
     */
    function getOnlineStudentsCount() public view returns (uint256) {
        uint256 count = 0;
        for (uint i = 0; i < registeredAddresses.length; i++) {
            if (students[registeredAddresses[i]].participationType == ParticipationType.Online) {
                count++;
            }
        }
        return count;
    }
}