//
//  NJDataStore.swift
//  VoteVault
//

import Foundation

struct NJOfficeInfo {
    let name: String
    let officeCode: String
}

// MODIFIED: Updated the data store with the correct numeric codes scraped from the website's HTML.
let newJerseyElectionData: [NJOfficeInfo] = [
    NJOfficeInfo(name: "Governor", officeCode: "0"),
    NJOfficeInfo(name: "Lt. Governor", officeCode: "_"),
    NJOfficeInfo(name: "State Senate", officeCode: "1"),
    NJOfficeInfo(name: "State Assembly", officeCode: "2")
]

// Available years for NJ elections. This can be expanded.
let newJerseyElectionYears: [Int] = [2025, 2023, 2021, 2019, 2017, 2015, 2013, 2011, 2009]

