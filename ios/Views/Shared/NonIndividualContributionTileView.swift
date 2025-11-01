//
//  NonIndividualContributionTileView.swift
//  VoteVault
//

import SwiftUI

// MARK: - Non-Individual Contribution Tile View
struct NonIndividualContributionTileView: View {
    let contribution: ItemizedContribution
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(contribution.contributor_name ?? "N/A")
                    .font(.headline)
                Spacer()
                Text("$\((contribution.contribution_receipt_amount ?? 0), specifier: "%.2f")")
                    .font(.headline)
                    .fontWeight(.bold)
            }
            
            InfoRow(label: "Date", value: formatDate(contribution.contribution_receipt_date))
            InfoRow(label: "Location", value: "\(contribution.contributor_city ?? "N/A"), \(contribution.contributor_state ?? "N/A")")
            
            if let urlString = contribution.pdf_url, let url = URL(string: urlString) {
                Link("Filing Details (PDF)", destination: url)
                    .font(.caption)
                    .foregroundColor(.accentColor)
            }
        }
        .padding(.vertical)
    }
    
    private func formatDate(_ dateString: String?) -> String {
        guard let dateString = dateString else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = formatter.date(from: dateString) {
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
        return dateString
    }
}
