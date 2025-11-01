//
//  SFDataStore.swift
//  VoteVault
//

import Foundation

// MARK: - San Francisco Mayoral Candidate Data Model

struct SFMayoralCandidate: Identifiable {
    var id: String { filerId } // Use Filer ID as the unique identifier
    let name: String
    let party: String
    let filerId: String
}

// MARK: - San Francisco Mayoral Election Data Store

let sfMayoralElectionData: [String: [SFMayoralCandidate]] = [

    "2024": [
        SFMayoralCandidate(name: "London Breed", party: "Democrat", filerId: "1441599"),
        SFMayoralCandidate(name: "Daniel Lurie", party: "Democrat", filerId: "1463099"),
        SFMayoralCandidate(name: "Mark Farrell", party: "Democrat", filerId: "1466726"),
        SFMayoralCandidate(name: "Aaron Peskin", party: "Democrat", filerId: "1468468")
    ],

    "2019": [
        SFMayoralCandidate(name: "London Breed", party: "Democrat", filerId: "1408423"),
        SFMayoralCandidate(name: "Ellen Lee Zhou", party: "Other", filerId: "1412530"),
        SFMayoralCandidate(name: "Joel Ventresca", party: "Other", filerId: "1")
    ],
    
    "2018": [
        SFMayoralCandidate(name: "London Breed", party: "Democrat", filerId: "1401170"),
        SFMayoralCandidate(name: "Mark Leno", party: "Democrat", filerId: "1396280"),
        SFMayoralCandidate(name: "Jane Kim", party: "Democrat", filerId: "1396602"),
        SFMayoralCandidate(name: "Angela Alioto", party: "Democrat", filerId: "2")
    ],
    
    "2015": [
        SFMayoralCandidate(name: "Ed Lee", party: "Democrat", filerId: "1374941"),
        SFMayoralCandidate(name: "Francisco Herrera", party: "Democrat", filerId: "3"),
        SFMayoralCandidate(name: "Amy Farah Weiss", party: "Other", filerId: "4"),
        SFMayoralCandidate(name: "Stuart Schuffman", party: "Other", filerId: "5"),
    ],
    
    "2011": [
        SFMayoralCandidate(name: "Ed Lee", party: "Democrat", filerId: "1336424"),
        SFMayoralCandidate(name: "John Avalos", party: "Democrat", filerId: "1331718"),
        SFMayoralCandidate(name: "David Chiu", party: "Democrat", filerId: "1331362"),
        SFMayoralCandidate(name: "Dennis Herrera", party: "Democrat", filerId: "1331665")
    ],
    
    "2007": [
        SFMayoralCandidate(name: "Gavin Newsom", party: "Democrat", filerId: "1289948"),
        SFMayoralCandidate(name: "Quintin Mecke", party: "Democrat", filerId: "6"),
        SFMayoralCandidate(name: "Harold Hoogasian", party: "Republican", filerId: "7"),
        SFMayoralCandidate(name: "Wilma Pang", party: "Other", filerId: "8")
    ]
]

// MARK: - Helper Functions

// Function to easily get candidates for a specific year
func getSFMayoralCandidates(for year: String) -> [SFMayoralCandidate] {
    return sfMayoralElectionData[year] ?? []
}

// Function to get available election years (as Strings, sorted descending)
func getSFMayoralElectionYears() -> [String] {
    return sfMayoralElectionData.keys.sorted(by: >)
}
