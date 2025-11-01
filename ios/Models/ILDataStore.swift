//
//  ILDataStore.swift
//  VoteVault
//

import Foundation

// MARK: - Illinois Hardcoded Data

// A struct to hold the mapping between office names and their API codes
struct ILElectionOffice {
    let name: String
    let officeCode: Int
}

// This array contains the hardcoded data for Illinois state elections.
// The `officeCode` is the value required to query the Illinois Board of Elections website.
let illinoisElectionOffices: [ILElectionOffice] = [
    ILElectionOffice(name: "Governor", officeCode: 1),
    ILElectionOffice(name: "Lieutenant Governor", officeCode: 2),
    ILElectionOffice(name: "Attorney General", officeCode: 3),
    ILElectionOffice(name: "Secretary of State", officeCode: 4),
    ILElectionOffice(name: "Comptroller", officeCode: 5),
    ILElectionOffice(name: "Treasurer", officeCode: 6),
    ILElectionOffice(name: "State Senator", officeCode: 10),
    ILElectionOffice(name: "State Representative", officeCode: 11)
]
