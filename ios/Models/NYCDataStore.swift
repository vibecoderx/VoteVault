//
//  NYCDataStore.swift
//  VoteVault
//

import Foundation

// MARK: - NYC Mayoral Candidate Data Model

struct NYCMayoralCandidate: Identifiable {
    let id: String // Use CFB ID as the unique identifier
    let name: String
    let party: String
}

// MARK: - NYC Mayoral Election Data Store

let nycMayoralElectionData: [Int: [NYCMayoralCandidate]] = [
    2025: [
        NYCMayoralCandidate(id: "2899", name: "Zohran Mamdani", party: "Democrat"),
        NYCMayoralCandidate(id: "2618", name: "Curtis Sliwa", party: "Republican"),
        NYCMayoralCandidate(id: "2993", name: "Andrew Cuomo", party: "Independent")
    ],

    2021: [
        NYCMayoralCandidate(id: "1545", name: "Eric L. Adams", party: "Democrat"),
        NYCMayoralCandidate(id: "2618", name: "Curtis Sliwa", party: "Republican"),
    ],

    2017: [
        NYCMayoralCandidate(id: "326", name: "Bill de Blasio", party: "Democrat"),
        NYCMayoralCandidate(id: "2071", name: "Nicole Malliotakis", party: "Republican"),
    ],

    2013: [
        NYCMayoralCandidate(id: "326", name: "Bill de Blasio", party: "Democrat"),
        NYCMayoralCandidate(id: "1690", name: "Joseph J. Lhota", party: "Republican"),
    ],

    2009: [
        NYCMayoralCandidate(id: "605", name: "Michael R. Bloomberg", party: "Independent"),
        NYCMayoralCandidate(id: "260", name: "William C. Thompson Jr.", party: "Democrat"),
    ],
    
    2005: [
        NYCMayoralCandidate(id: "605", name: "Michael R. Bloomberg", party: "Republican"),
        NYCMayoralCandidate(id: "AY", name: "Fernando Ferrer", party: "Democrat"),
    ],
    
    2001: [
        NYCMayoralCandidate(id: "605", name: "Michael R. Bloomberg", party: "Republican"),
        NYCMayoralCandidate(id: "A7", name: "Mark Green", party: "Democrat"),
    ],
    
    1997: [
        NYCMayoralCandidate(id: "A6", name: "Rudy Giuliani", party: "Republican"),
        NYCMayoralCandidate(id: "A5", name: "Ruth Messinger", party: "Democrat"),
    ],
    
    1993: [
        NYCMayoralCandidate(id: "A6", name: "Rudy Giuliani", party: "Republican"),
        NYCMayoralCandidate(id: "3", name: "David Dinkins", party: "Democrat"),
    ],
    
    1989: [
        NYCMayoralCandidate(id: "A6", name: "Rudy Giuliani", party: "Republican"),
        NYCMayoralCandidate(id: "3", name: "David Dinkins", party: "Democrat"),
    ]
]

// MARK: - Helper Function (Optional)

// Function to easily get candidates for a specific year
func getNYCMayoralCandidates(for year: Int) -> [NYCMayoralCandidate] {
    return nycMayoralElectionData[year] ?? []
}

// Function to get available election years
func getNYCMayoralElectionYears() -> [Int] {
    return nycMayoralElectionData.keys.sorted(by: >) // Sort descending
}

