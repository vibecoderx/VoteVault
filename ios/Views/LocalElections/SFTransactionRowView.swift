//
//  SFTransactionRowView.swift
//  VoteVault
//


import SwiftUI

struct SFTransactionRowView: View {
    let transaction: SFTransaction

    // Determine color based on transaction type
    private var amountColor: Color {
        transaction.form_type == "A" ? .green : .orange
    }
    
    // Determine label for the description
    private var descriptionLabel: String {
        transaction.form_type == "A" ? "Employer/Occ" : "Payee"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(transaction.primaryName)
                    .font(.headline)
                Spacer()
                Text(formatAmount(transaction.amount))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(amountColor)
            }

            InfoRow(label: "Date", value: formattedDate(transaction.transaction_date))
            
            let location = transaction.location
            if !location.isEmpty {
                InfoRow(label: "Location", value: location)
            }
            
            let description = transaction.description
            if !description.isEmpty {
                 InfoRow(label: descriptionLabel, value: description)
            }
            
             InfoRow(label: "Transaction ID", value: transaction.transaction_id)
        }
        .padding(.vertical, 6)
    }

    private func formatAmount(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }

    // Handle ISO 8601 date strings
    private func formattedDate(_ dateString: String?) -> String {
        guard let dateString = dateString else { return "N/A" }
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .none
            return displayFormatter.string(from: date)
        }
        
        // Fallback for just date part if time parsing fails
        formatter.formatOptions = [.withFullDate]
        if let date = formatter.date(from: String(dateString.prefix(10))) {
             let displayFormatter = DateFormatter()
             displayFormatter.dateStyle = .medium
             return displayFormatter.string(from: date)
        }
        
        return dateString // Return original if all parsing fails
    }
}

/*
struct SFTransactionRowView_Previews: PreviewProvider {
    static var previews: some View {
        // Sample contribution
        let sampleContrib = SFTransaction(
            filer_name: "London Breed", filer_id: "1396537", election: "2024",
            transaction_type: "Contribution", transaction_sub_type: "Monetary",
            transaction_date: "2023-10-27T00:00:00.000", calculated_amount: "500.00",
            donor_name: "John Smith", donor_employer: "Acme Inc", donor_occupation: "Engineer",
            donor_city: "San Francisco", donor_state: "CA",
            payee_name: nil, payee_city: nil, payee_state: nil,
            transaction_id: "T12345"
        )
        
        // Sample expenditure
        let sampleExpend = SFTransaction(
            filer_name: "London Breed", filer_id: "1396537", election: "2024",
            transaction_type: "Expenditure", transaction_sub_type: "Campaign Consultants",
            transaction_date: "2023-11-01T00:00:00.000", calculated_amount: "2500.00",
            donor_name: nil, donor_employer: nil, donor_occupation: nil,
            donor_city: nil, donor_state: nil,
            payee_name: "Political Services Co", payee_city: "Sacramento", payee_state: "CA",
            transaction_id: "T67890"
        )
        
        VStack {
            SFTransactionRowView(transaction: sampleContrib)
            Divider()
            SFTransactionRowView(transaction: sampleExpend)
        }
        .padding()
    }
}
*/
