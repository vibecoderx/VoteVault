//
// File: CandidateTileView.swift
// Folder: Views/Shared
//

import SwiftUI

struct CandidateTileView: View {
    let summary: PresidentialFinancialSummary

    private var backgroundColor: Color {
        if summary.candidate_id == "P00000001" {
            return Color(UIColor.brown)
        }
        switch summary.candidate_party_affiliation {
        case "DEM": return Color.blue
        case "REP": return Color.red
        case "IND": return Color.gray
        default: return Color(UIColor.lightGray)
        }
    }
    
    private var textColor: Color {
        if ["DEM", "REP", "IND"].contains(summary.candidate_party_affiliation) {
            return .white
        }
        return .primary
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading) {
                Text(summary.candidate_name ?? "N/A")
                    .font(.title2).bold()
                Text("Committee Name: \(summary.committee_name ?? "N/A")")
                    .font(.subheadline)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .cornerRadius(8)
            .padding(.top, -8)
            .padding(.horizontal, -12)
            
            VStack(alignment: .leading, spacing: 10) {
                Divider()
                Text("Summary").font(.headline).padding(.top, 5)
                FinancialRow(label: "Total Money Raised", amount: summary.net_receipts ?? 0)
                FinancialRow(label: "Total Money Spent", amount: summary.disbursements_less_offsets ?? 0)
                FinancialRow(label: "Cash Left", amount: summary.cash_on_hand_end ?? 0)
                Divider()
                Text("Funding Sources").font(.headline).padding(.top, 5)
                FinancialRow(label: "From Individuals", amount: summary.individual_contributions_less_refunds ?? 0)
                FinancialRow(label: "From PACs", amount: summary.pac_contributions_less_refunds ?? 0)
                FinancialRow(label: "From Party", amount: summary.party_contributions_less_refunds ?? 0)
                FinancialRow(label: "Federal Funds", amount: summary.federal_funds ?? 0)
                FinancialRow(label: "From Affiliated Committees", amount: summary.transfers_from_affiliated_committees ?? 0)
            }
        }
        .padding(.vertical)
    }
}
