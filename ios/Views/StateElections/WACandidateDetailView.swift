//
//  WACandidateDetailView.swift
//  VoteVault
//

import SwiftUI

struct WACandidateDetailView: View {
    let candidate: WACandidate
    
    @State private var contributions: [WAContribution] = []
    @State private var expenditures: [WAExpenditure] = []
    @State private var isLoadingContributions = true
    @State private var isLoadingExpenditures = true
    @State private var contributionError: String?
    @State private var expenditureError: String?
    
    @State private var selectedTab = 0

    var body: some View {
        VStack {
            Picker("Data", selection: $selectedTab) {
                Text("Contributions").tag(0)
                Text("Expenditures").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            if selectedTab == 0 {
                if isLoadingContributions {
                    ProgressView("Fetching Contributions...")
                } else if let error = contributionError {
                    Text(error).foregroundColor(.red).padding()
                } else if contributions.isEmpty {
                    Text("No contributions found for this candidate.").foregroundColor(.secondary).padding()
                } else {
                    List(contributions) { contribution in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(contribution.contributor_name?.capitalized ?? "N/A")
                                    .font(.headline)
                                Spacer()
                                if let amountDouble = Double(contribution.amount) {
                                    Text(String(format: "$%.2f", amountDouble))
                                        .font(.headline)
                                        .fontWeight(.bold)
                                }
                            }

                            Divider()

                            VStack(alignment: .leading, spacing: 5) {
                                InfoRow(label: "Date", value: formatDate(contribution.receipt_date))
                                if let category = contribution.contributor_category, !category.isEmpty {
                                    InfoRow(label: "Category", value: category)
                                }
                                
                                if let description = contribution.description, !description.isEmpty {
                                    InfoRow(label: "Description", value: description)
                                }
                            }
                            .font(.subheadline)
                            
                            if let urlString = contribution.url?.url, let url = URL(string: urlString) {
                                HStack {
                                    Spacer()
                                    Link("More Details", destination: url)
                                        .font(.caption)
                                        .foregroundColor(.accentColor)
                                }
                                .padding(.top, 4)
                            }
                        }
                        .padding(.vertical)
                    }
                }
            } else {
                if isLoadingExpenditures {
                    ProgressView("Fetching Expenditures...")
                } else if let error = expenditureError {
                    Text(error).foregroundColor(.red).padding()
                } else if expenditures.isEmpty {
                    Text("No expenditures found for this candidate.").foregroundColor(.secondary).padding()
                } else {
                    List(expenditures) { expenditure in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(expenditure.recipient_name?.capitalized ?? "N/A")
                                    .font(.headline)
                                Spacer()
                                if let amountDouble = Double(expenditure.amount) {
                                    Text(String(format: "$%.2f", amountDouble))
                                        .font(.headline)
                                        .fontWeight(.bold)
                                }
                            }
                            InfoRow(label: "Date", value: formatDate(expenditure.expenditure_date))
                            if let description = expenditure.description {
                                InfoRow(label: "Description", value: description)
                            }
                            if let urlString = expenditure.url?.url, let url = URL(string: urlString) {
                                HStack {
                                    Spacer()
                                    Link("More Details", destination: url)
                                        .font(.caption)
                                        .foregroundColor(.accentColor)
                                }
                                .padding(.top, 4)
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
        }
        .navigationTitle(candidate.filer_name.capitalized)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchContributions()
            fetchExpenditures()
        }
    }
    
    private func fetchContributions() {
        isLoadingContributions = true
        let urlString = "https://data.wa.gov/resource/kv7h-kjye.json?$where=filer_id='\(candidate.filer_id)'&$order=amount DESC&$limit=100"
        
        print("DEBUG: fetchContributions urlString: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            contributionError = "Invalid URL for contributions."
            isLoadingContributions = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                isLoadingContributions = false
                if let data = data {
                    do {
                        let decodedResponse = try JSONDecoder().decode([WAContribution].self, from: data)
                        self.contributions = decodedResponse
                    } catch {
                        self.contributionError = "Failed to parse contributions: \(error.localizedDescription)"
                    }
                } else {
                    self.contributionError = "Error fetching contributions: \(error?.localizedDescription ?? "Unknown error")"
                }
            }
        }.resume()
    }
    
    private func fetchExpenditures() {
        isLoadingExpenditures = true
        let urlString = "https://data.wa.gov/resource/tijg-9zyp.json?$where=filer_id='\(candidate.filer_id)'&$order=amount DESC&$limit=100"
        
        print("DEBUG: fetchExpenditures urlString: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            expenditureError = "Invalid URL for expenditures."
            isLoadingExpenditures = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                isLoadingExpenditures = false
                if let data = data {
                    do {
                        let decodedResponse = try JSONDecoder().decode([WAExpenditure].self, from: data)
                        self.expenditures = decodedResponse
                    } catch {
                        self.expenditureError = "Failed to parse expenditures: \(error.localizedDescription)"
                    }
                } else {
                    self.expenditureError = "Error fetching expenditures: \(error?.localizedDescription ?? "Unknown error")"
                }
            }
        }.resume()
    }

    private func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            return displayFormatter.string(from: date)
        }
        return dateString
    }
}

