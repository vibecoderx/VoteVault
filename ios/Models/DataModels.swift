//
// File: DataModels.swift
// Folder: Models
//

import Foundation
import SwiftUI

// MARK: - FEDERAL ELECTION DATA MODELS

struct PresidentialResponse: Codable {
    let results: [PresidentialFinancialSummary]
}

struct PresidentialFinancialSummary: Codable, Identifiable {
    var id: String { candidate_id }
    let candidate_id: String
    let candidate_name: String?
    let candidate_party_affiliation: String?
    let committee_id: String?
    let committee_name: String?
    let net_receipts: Double?
    let pac_contributions_less_refunds: Double?
    let party_contributions_less_refunds: Double?
    let individual_contributions_less_refunds: Double?
    let federal_funds: Double?
    let disbursements_less_offsets: Double?
    let cash_on_hand_end: Double?
    let transfers_from_affiliated_committees: Double?
}

struct ContributionBySizeResponse: Codable {
    let results: [ContributionBySize]
}

struct ContributionBySize: Codable, Identifiable {
    var id: Int { size }
    let candidate_id: String
    let contribution_receipt_amount: Double
    let size: Int
}

struct ContributionByStateResponse: Codable {
    let results: [ContributionByState]
}

struct ContributionByState: Codable, Identifiable {
    var id: String { contribution_state }
    let contribution_receipt_amount: Double
    let contribution_state: String
}

struct SenateContributionBySizeResponse: Codable {
    let results: [SenateContributionBySize]
}

struct SenateContributionBySize: Codable, Identifiable {
    var id: Int { size }
    let committee_id: String
    let count: Int?
    let cycle: Int
    let size: Int
    let total: Double?
}

struct SenateContributionByStateResponse: Codable {
    let results: [SenateContributionByState]
}

struct SenateContributionByState: Codable, Identifiable {
    var id: String { state }
    let committee_id: String
    let count: Int
    let cycle: Int
    let state: String
    let state_full: String
    let total: Double
}

struct ElectionsResponse: Codable {
    let results: [ElectionSummary]
}

struct ElectionSummary: Codable, Identifiable {
    var id: String { candidate_id }
    let candidate_id: String
    let candidate_name: String?
    let party_full: String?
    let total_receipts: Double?
    let total_disbursements: Double?
    let cash_on_hand_end_period: Double?
    let candidate_pcc_name: String?
    let candidate_pcc_id: String?
}

struct CandidateResponse: Codable {
    let results: [Candidate]
}

struct Candidate: Codable, Identifiable {
    var id: String { candidate_id }
    let candidate_id: String
    let district_number: Int?
}

struct ItemizedContributionResponse: Codable {
    let results: [ItemizedContribution]
}

struct ItemizedContribution: Codable, Identifiable {
    let id = UUID()
    let contributor_name: String?
    let contribution_receipt_date: String?
    let contribution_receipt_amount: Double?
    let contributor_city: String?
    let contributor_state: String?
    let contributor_occupation: String?
    let pdf_url: String?
    let committee: CommitteeInfo?

    private enum CodingKeys: String, CodingKey {
        case contributor_name, contribution_receipt_date, contribution_receipt_amount,
             contributor_city, contributor_state, contributor_occupation,
             pdf_url, committee
    }
}

struct ItemizedDisbursementResponse: Codable {
    let results: [ItemizedDisbursement]
}

struct ItemizedDisbursement: Codable, Identifiable {
    let id = UUID()
    let disbursement_amount: Double?
    let disbursement_date: String?
    let disbursement_purpose_category: String?
    let disbursement_description: String?
    let recipient_name: String?
    let recipient_city: String?
    let recipient_state: String?
    let pdf_url: String?
    let committee: CommitteeInfo?
    
    private enum CodingKeys: String, CodingKey {
        case disbursement_amount, disbursement_date, disbursement_purpose_category,
             disbursement_description, recipient_name, recipient_city,
             recipient_state, pdf_url, committee
    }
}

struct ExpenditureByPurposeResponse: Codable {
    let results: [ExpenditureByPurpose]
}

struct ExpenditureByPurpose: Codable, Identifiable {
    var id: String { purpose }
    let purpose: String
    let total: Double
}

struct ExpenditureByRecipientResponse: Codable {
    let results: [ExpenditureByRecipient]
}

struct ExpenditureByRecipient: Codable, Identifiable {
    var id: String { recipient_name }
    let recipient_name: String
    let total: Double
    let recipient_disbursement_percent: Double
}

struct SuperPACResponse: Codable {
    let results: [SuperPACExpenditure]
}

struct SuperPACExpenditure: Codable, Identifiable {
    var id: String { committee_id + String(total) }
    let committee_id: String
    let committee_name: String?
    let total: Double
    let support_oppose_indicator: String
    let cycle: Int
}

struct CommitteeInfo: Codable {
    let cycle: Int?
}

// MARK: - SUPER PAC DATA MODELS

struct SuperPACExpenditureByCandidateResponse: Codable {
    let results: [SuperPACExpenditureByCandidate]
}

struct SuperPACExpenditureByCandidate: Codable, Identifiable {
    var id: String { candidate_id + support_oppose_indicator }
    let candidate_id: String
    let cycle: Int
    let total: Double
    let support_oppose_indicator: String
}

struct CandidateDetailResponse: Codable {
    let results: [CandidateDetail]
}

struct CandidateDetail: Codable, Identifiable {
    var id: String { candidate_id }
    let candidate_id: String
    let name: String?
    let office_full: String?
    let party_full: String?
}

struct ExpenditureWithCandidateDetail: Identifiable {
    var id: String { expenditure.id }
    let expenditure: SuperPACExpenditureByCandidate
    let candidateDetail: CandidateDetail
}


// MARK: - WASHINGTON STATE ELECTION DATA MODELS

struct WAElectionYear: Codable, Hashable {
    let election_year: String
}

struct WACandidate: Codable, Identifiable, Hashable {
    var id: String { filer_id }
    let filer_name: String
    let filer_id: String
    let party: String?
}

struct WAContribution: Codable, Identifiable {
    var id: String { report_number + amount + receipt_date }
    let contributor_category: String?
    let contributor_name: String?
    let amount: String
    let receipt_date: String
    let contributor_city: String?
    let contributor_state: String?
    let description: String?
    let report_number: String
    let url: WACandidateUrl?
}

struct WACandidateUrl: Codable, Hashable {
    let url: String
}

struct WAExpenditure: Codable, Identifiable {
    var id: String { report_number + amount + expenditure_date }
    let recipient_name: String?
    let amount: String
    let expenditure_date: String
    let description: String?
    let report_number: String
    let url: WACandidateUrl?
}

// MARK: - NEW YORK STATE ELECTION DATA MODELS

struct NYContribution: Codable, Identifiable {
    var id: String { trans_number + sched_date }
    let filer_id: String?
    let trans_number: String
    let sched_date: String
    let cntrbr_type_desc: String?
    let flng_ent_name: String?
    let flng_ent_first_name: String?
    let flng_ent_last_name: String?
    let flng_ent_city: String?
    let flng_ent_state: String?
    let org_amt: String
}

struct NYExpenditure: Codable, Identifiable {
    var id: String { trans_number + sched_date }
    let filer_id: String?
    let trans_number: String
    let sched_date: String
    let purpose_code_desc: String?
    let trans_explntn: String?
    let flng_ent_name: String?
    let flng_ent_city: String?
    let flng_ent_state: String?
    let org_amt: String
}

// MARK: - ILLINOIS STATE ELECTION DATA MODELS

struct ILCandidate: Identifiable {
    let id = UUID()
    let lastName: String
    let firstName: String
    let address: String
    let city: String
    let state: String
    let zip: String
    let office: String
    let politicalParty: String
    let committeeID: String
    let electionYear: Int // Added for filtering
}

struct ILContribution: Identifiable {
    let id = UUID()
    let contributor: String
    let amount: Double
    let date: String
    let city: String
    let state: String
}

struct ILExpenditure: Identifiable {
    let id = UUID()
    let payee: String
    let amount: Double
    let date: String
    let purpose: String
}

// MARK: - NEW JERSEY STATE ELECTION DATA MODELS

// Model for the overall JSON response from the NJ handler
struct NJCandidateResponse: Codable {
    // let draw: Int
    // let recordsTotal: Int
    // let recordsFiltered: Int
    let data: [NJCandidate] // The data comes back as an array of NJCandidates
    
    private enum CodingKeys: String, CodingKey {
        case data
    }
}

// Model representing a parsed candidate from the NJ data
struct NJCandidate: Codable, Identifiable, Hashable {
    var id: String { ENTITY_S }
    let ENTITY_S: String
    let ENTITYNAME: String
    let OFFICE: String
    let PARTY: String
    let LOCATION: String
    let ELECTIONYEAR: String
    let ELECTIONTYPE: String
    let TOT_CONT_AMT: Int
    let TOT_EXP_AMT: Int
}

// Model for the response from GetContributorTotals API for NJ
struct NJContributorTotalResponse: Codable, Identifiable {
    var id: String { "\(Description)-\(Amount)" }
    let Description: String
    let Amount: Double
}

// Model for NJ Expenditure
struct NJPayeeTotalResponse: Codable, Identifiable {
    var id: String { "\(Description)-\(Amount)" }
    let Description: String
    let Amount: Double
}
