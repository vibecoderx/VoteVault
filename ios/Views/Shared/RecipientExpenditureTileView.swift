//
//  RecipientExpenditureTileView.swift
//  VoteVault
//

import SwiftUI

// MARK: - Recipient Expenditure Tile View
struct RecipientExpenditureTileView: View {
    let recipientData: ExpenditureByRecipient
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(recipientData.recipient_name)
                .font(.headline)
            
            InfoRow(label: "Total Amount", value: formatCurrencyShorthand(recipientData.total))
            InfoRow(label: "% of Total Expenditure", value: String(format: "%.2f%%", recipientData.recipient_disbursement_percent))
        }
        .padding(.vertical)
    }
}
