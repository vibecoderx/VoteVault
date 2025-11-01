//
//  SFDataModels.swift
//  VoteVault
//

import Foundation

// MARK: - Model for SUM Query
// This struct is used to decode the response from a SUM() query
// The API returns an array: [ { "sum_calculated_amount": "12345.67" } ]
struct SFTotalAmount: Codable {
    let sum_calculated_amount: String?
}

// Represents a single transaction (Contribution or Expenditure)
// from the SF OpenData API (pitq-e56w)
struct SFTransaction: Codable, Identifiable {
    
    // Use transaction_id as the unique ID
    var id: String { transaction_id }
    
    // Common Fields
    let transaction_id: String
    let form_type: String
    let transaction_date: String? // This is an ISO 8601 string (e.g., "2023-10-27T00:00:00.000")
    let transaction_first_name: String?  // Contributor or Payee
    let transaction_last_name: String?   // Contributor or Payee
    let transaction_city: String?
    let transaction_state: String?
    
    // Amount
    let calculated_amount: String? // Comes as String, e.g., "500.00"
    
    // Contribution Fields
    let transaction_occupation: String?
    let transaction_employer: String?
        
    // Computed property to safely convert amount string to Double
    var amount: Double {
        guard let amountString = calculated_amount else { return 0.0 }
        return Double(amountString) ?? 0.0
    }
    
    // Computed property to get the relevant name (donor or payee)
    var primaryName: String {
        return (transaction_first_name ?? "") + " " + (transaction_last_name ?? "")
    }
    
    // Computed property to get location
    var location: String {
        var city, state: String?
        city = transaction_city
        state = transaction_state
        
        let components = [city?.capitalized, state?.uppercased()].compactMap { $0 }.filter { !$0.isEmpty }
        return components.joined(separator: ", ")
    }
    
    // Computed property for employer/occupation
    var description: String {
        let components = [transaction_occupation, transaction_employer].compactMap { $0 }.filter { !$0.isEmpty }
        return components.joined(separator: " / ")
    }
}
