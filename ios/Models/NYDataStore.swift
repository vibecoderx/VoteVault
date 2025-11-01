//
//  NYDataStore.swift
//  VoteVault
//

import Foundation

// MARK: - New York Hardcoded Data Models

struct NYCandidateInfo {
    let name: String
    let party: String
    let committeeName: String
}

// MARK: - New York Election Data Store

// This dictionary contains the hardcoded data for New York state elections.
// It maps election types (offices) to years, and then to a list of candidates.
// The `committeeName` is the exact name used to query the NYS Board of Elections API.

let newYorkElectionData: [String: [Int: [NYCandidateInfo]]] = [
    "Governor": [
        2022: [
            NYCandidateInfo(name: "Kathy C. Hochul", party: "Democratic", committeeName: "Friends for Kathy Hochul"),
            NYCandidateInfo(name: "Lee Zeldin", party: "Republican", committeeName: "Zeldin for New York")
        ],
        2018: [
            NYCandidateInfo(name: "Andrew M. Cuomo", party: "Democratic", committeeName: "Andrew Cuomo for New York Inc."),
            NYCandidateInfo(name: "Marcus J. Molinaro", party: "Republican", committeeName: "Molinaro For New York")
        ],
        2014: [
            NYCandidateInfo(name: "Andrew M. Cuomo", party: "Democratic", committeeName: "Andrew Cuomo for New York Inc."),
            NYCandidateInfo(name: "Rob Astorino", party: "Republican", committeeName: "Astorino For Governor")
        ],
        2010: [
            NYCandidateInfo(name: "Andrew M. Cuomo", party: "Democratic", committeeName: "Andrew Cuomo for New York Inc."),
            NYCandidateInfo(name: "Carl Paladino", party: "Republican", committeeName: "Paladino For The People")
        ]
    ],
    "Attorney General": [
        2022: [
            NYCandidateInfo(name: "Letitia A. James", party: "Democratic", committeeName: "James For NY"),
            NYCandidateInfo(name: "Michael Henry", party: "Republican", committeeName: "Henry for New York")
        ],
        2018: [
            NYCandidateInfo(name: "Letitia A. James", party: "Democratic", committeeName: "James For NY"),
            NYCandidateInfo(name: "Keith Wofford", party: "Republican", committeeName: "Keith Wofford for Attorney General"),
            NYCandidateInfo(name: "Michael H Sussman", party: "Green", committeeName: "Sussman For Nysag 2018")
        ],
        2014: [
            NYCandidateInfo(name: "Eric T. Schneiderman", party: "Democratic", committeeName: "Schneiderman 2014"),
            NYCandidateInfo(name: "John Cahill", party: "Republican", committeeName: "Friends Of Cahill")
        ],
        2010: [
            NYCandidateInfo(name: "Eric T. Schneiderman", party: "Democratic", committeeName: "Schneiderman For Attorney General Inc."),
            NYCandidateInfo(name: "Dan Donovan", party: "Republican", committeeName: "Donovan 2010")
        ]
    ],
    "Comptroller": [
        2022: [
            NYCandidateInfo(name: "Thomas P. DiNapoli", party: "Democratic", committeeName: "Dinapoli 2022 Inc."),
            NYCandidateInfo(name: "Paul Rodriguez", party: "Republican", committeeName: "Paul Rodriguez for Comptroller"),
            NYCandidateInfo(name: "Bill Schmidt", party: "Libertarian", committeeName: "Friends Of Bill Schmidt")
        ],
        2018: [
            NYCandidateInfo(name: "Thomas P. DiNapoli", party: "Democratic", committeeName: "Dinapoli 2022 Inc."),
            NYCandidateInfo(name: "Jonathan Trichter", party: "Republican", committeeName: "Trichter For New York"),
            NYCandidateInfo(name: "Mark Dunlea", party: "Green", committeeName: "Friends Of Mark Dunlea")
        ],
        2014: [
            NYCandidateInfo(name: "Thomas P. DiNapoli", party: "Democratic", committeeName: "Dinapoli 2022 Inc."),
            NYCandidateInfo(name: "Robert Antonacci", party: "Republican", committeeName: "Antonacci For The People")
        ],
        2010: [
            NYCandidateInfo(name: "Thomas P. DiNapoli", party: "Democratic", committeeName: "Dinapoli 2022 Inc."),
            NYCandidateInfo(name: "Harry Wilson", party: "Republican", committeeName: "Taxpayers For Wilson")
        ]
    ]
]

