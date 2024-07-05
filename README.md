# Hackathon Registration Smart Contract

This repository contains a Solidity smart contract for managing student registrations for a hackathon. The contract is designed to handle both in-person and online participants, collect necessary information, and provide various utility functions for efficient registration management.

## Features

- Student registration for hackathon (both in-person and online)
- Update existing registrations
- Configurable minimum age requirement (with absolute minimum safeguard)
- Tracking of in-person and online participants
- Handling of dietary restrictions and lodging needs
- Implementation of safeguards against common edge cases
- Capped total number of registrations

## Smart Contract Overview

- Enums: `Skillset`, `ParticipationType`, `DietaryRestriction`
- Struct: `StudentData` for comprehensive student information
- Functions for registration, updates, and data retrieval
- Events for logging registration attempts and updates

## Key Functions

- `registerOrUpdateStudent`: Register a new student or update existing registration
- `getStudentByAddress`: Retrieve a student's data by their Ethereum address
- `isStudentRegistered`: Check if a student is registered
- `getTotalRegisteredStudents`: Get the total count of registered students
- `getInPersonStudentsCount`: Get the count of in-person students
- `getOnlineStudentsCount`: Get the count of online students


## Note

This contract is for educational purposes and has not been audited for production use. Always ensure proper testing and auditing before deploying any smart contract to a live blockchain network.
