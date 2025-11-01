//
//  SuperPACExpenditureRowView.swift
//  VoteVault
//

import SwiftUI

struct SuperPACExpenditureRowView: View {
    let detail: ExpenditureWithCandidateDetail
    
    private var roleText: String {
        detail.expenditure.support_oppose_indicator == "S" ? "Support" : "Oppose"
    }
    
    private var roleColor: Color {
        detail.expenditure.support_oppose_indicator == "S" ? .green : .orange
    }
    
    private var partyColor: Color {
        switch detail.candidateDetail.party_full {
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
            // Header with Candidate Name and Role
            HStack {
                Text(detail.candidateDetail.name ?? "N/A")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Text(roleText)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(roleColor)
            }
            
            Divider()
            
            // Financial Info Section
            HStack {
                Text("Total Expenditure:")
                    .fontWeight(.semibold)
                Spacer()
                Text(formatCurrencyShorthand(detail.expenditure.total))
                    .font(.title3)
                    .fontWeight(.bold)
            }
            
            Divider()
            
            // Candidate Info Section
            VStack(alignment: .leading, spacing: 5) {
                InfoRow(label: "Office", value: detail.candidateDetail.office_full ?? "N/A")
                InfoRow(label: "Party", value: detail.candidateDetail.party_full ?? "N/A")
                    .foregroundColor(partyColor)
                InfoRow(label: "Candidate ID", value: detail.expenditure.candidate_id)
            }
            .font(.caption)
            .foregroundColor(.secondary)
            .padding(.top, 5)
        }
        .padding(.vertical)
    }
}

