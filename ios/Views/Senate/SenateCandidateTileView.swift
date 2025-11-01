//
//  SenateCandidateTileView.swift
//  VoteVault
//

import SwiftUI

// MARK: - Senate Candidate Tile View
struct SenateCandidateTileView: View {
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
        VStack(alignment: .leading, spacing: 8) {
            Text(candidate.candidate_name ?? "N/A")
                .font(.headline)
                .foregroundColor(partyColor)
            
            Divider()
            
            FinancialRow(label: "Total Raised", amount: candidate.total_receipts ?? 0)
            FinancialRow(label: "Total Spent", amount: candidate.total_disbursements ?? 0)
            FinancialRow(label: "Cash on Hand", amount: candidate.cash_on_hand_end_period ?? 0)
        }
        .padding(.vertical)
    }
}
