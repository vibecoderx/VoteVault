//
//  ExpenditureTileView.swift
//  VoteVault
//

import SwiftUI

// MARK: - Expenditure Tile View
struct ExpenditureTileView: View {
    let disbursement: ItemizedDisbursement
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(disbursement.recipient_name ?? "N/A")
                    .font(.headline)
                Spacer()
                Text("$\((disbursement.disbursement_amount ?? 0), specifier: "%.2f")")
                    .font(.headline)
                    .fontWeight(.bold)
            }
            
            InfoRow(label: "Purpose", value: disbursement.disbursement_purpose_category ?? "N/A")
            InfoRow(label: "Date", value: formatDate(disbursement.disbursement_date))
            InfoRow(label: "Location", value: "\(disbursement.recipient_city ?? "N/A"), \(disbursement.recipient_state ?? "N/A")")
            
            if let description = disbursement.disbursement_description {
                Text("Description: \(description)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if let urlString = disbursement.pdf_url, let url = URL(string: urlString) {
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
