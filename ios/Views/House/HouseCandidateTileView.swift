//
//  HouseCandidateTileView.swift
//  VoteVault
//

import SwiftUI

// MARK: - House Candidate Tile View
struct HouseCandidateTileView: View {
    let candidate: ElectionSummary
    
    private var partyColor: Color {
        switch candidate.party_full {
        case "DEMOCRATIC PARTY":
            return .blue
        case "REPUBLICAN PARTY":
            return .red
        default:
            return .gray
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(candidate.candidate_name ?? "N/A")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(partyColor)
            
            Text(candidate.party_full ?? "Unknown Party")
                .font(.subheadline)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 5) {
                InfoRow(label: "Committee Name", value: candidate.candidate_pcc_name ?? "N/A")
                InfoRow(label: "Committee ID", value: candidate.candidate_pcc_id ?? "N/A")
            }
            .font(.caption)
            .foregroundColor(.secondary)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 5) {
                FinancialRow(label: "Funds Received", amount: candidate.total_receipts ?? 0)
                FinancialRow(label: "Funds Spent", amount: candidate.total_disbursements ?? 0)
                FinancialRow(label: "Remaining Cash", amount: candidate.cash_on_hand_end_period ?? 0)
            }
            .padding(.top, 5)
        }
        .padding(.vertical)
    }
}
