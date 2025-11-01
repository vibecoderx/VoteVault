//
//  NYCandidateDetailView.swift
//  VoteVault
//

import SwiftUI

struct NYCandidateDetailView: View {
    let candidate: NYCandidateInfo
    let year: Int
    
    @State private var contributions: [NYContribution] = []
    @State private var expenditures: [NYExpenditure] = []
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
                                Text(contributorDisplayName(for: contribution))
                                    .font(.headline)
                                Spacer()
                                if let amountDouble = Double(contribution.org_amt) {
                                    Text(formatCurrency(amountDouble))
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.green)
                                }
                            }
                            InfoRow(label: "Date", value: formatDate(contribution.sched_date))
                            InfoRow(label: "Location", value: "\(contribution.flng_ent_city ?? ""), \(contribution.flng_ent_state ?? "")")
                            InfoRow(label: "Txn#", value: contribution.trans_number)
                            InfoRow(label: "Type", value: contribution.cntrbr_type_desc ?? "N/A")
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
                                Text(expenditure.flng_ent_name?.capitalized ?? "N/A")
                                    .font(.headline)
                                Spacer()
                                if let amountDouble = Double(expenditure.org_amt) {
                                    Text(formatCurrency(amountDouble))
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.green)
                                }
                            }
                            InfoRow(label: "Date", value: formatDate(expenditure.sched_date))
                            InfoRow(label: "Purpose", value: expenditure.purpose_code_desc ?? "")
                            InfoRow(label: "Explanation", value: expenditure.trans_explntn ?? "")
                        }
                        .padding(.vertical)
                    }
                }
            }
        }
        .navigationTitle(candidate.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchContributions()
            fetchExpenditures()
        }
    }
    
    private func contributorDisplayName(for contribution: NYContribution) -> String {
        if let orgName = contribution.flng_ent_name, !orgName.isEmpty {
            return orgName.capitalized
        } else {
            let firstName = contribution.flng_ent_first_name ?? ""
            let lastName = contribution.flng_ent_last_name ?? ""
            return "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces).capitalized
        }
    }
    
    private func fetchContributions() {
        isLoadingContributions = true
        
        let urlString = "https://data.ny.gov/resource/4j2b-6a2j.json?$where=cand_comm_name like '\(candidate.committeeName)' AND election_year='\(year)'&$order=org_amt DESC&$limit=1000"
        
        guard let url = URL(string: urlString) else {
            contributionError = "Invalid URL for contributions."
            isLoadingContributions = false
            return
        }
        
        print("DEBUG: NY contributions url: \(url)")
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                isLoadingContributions = false
                if let data = data {
                    do {
                        let decodedResponse = try JSONDecoder().decode([NYContribution].self, from: data)
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

        let urlString = "https://data.ny.gov/resource/ajsb-8pni.json?$where=cand_comm_name like '\(candidate.committeeName)' AND election_year='\(year)'&$order=org_amt DESC&$limit=1000"
        
        guard let url = URL(string: urlString) else {
            expenditureError = "Invalid URL for expenditures."
            isLoadingExpenditures = false
            return
        }
        
        print("DEBUG: NY expenditures url: \(url)")
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                isLoadingExpenditures = false
                if let data = data {
                    do {
                        let decodedResponse = try JSONDecoder().decode([NYExpenditure].self, from: data)
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

    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }

    private func formatDate(_ dateString: String?) -> String {
        guard let dateString = dateString else { return "N/A" }
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            return displayFormatter.string(from: date)
        }
        return dateString.split(separator: "T").first.map(String.init) ?? dateString
    }
}

