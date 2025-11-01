//
//  ILCandidateDetailView.swift
//  VoteVault
//

import SwiftUI

struct ILCandidateDetailView: View {
    let candidate: ILCandidate
    let year: Int
    
    @State private var contributions: [ILContribution] = []
    @State private var expenditures: [ILExpenditure] = []
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
                                Text(contribution.contributor.capitalized)
                                    .font(.headline)
                                Spacer()
                                Text(formatCurrency(contribution.amount))
                                    .font(.headline)
                                    .fontWeight(.bold)
                            }
                            InfoRow(label: "Date", value: contribution.date)
                            InfoRow(label: "Location", value: "\(contribution.city), \(contribution.state)")
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
                                Text(expenditure.payee.capitalized)
                                    .font(.headline)
                                Spacer()
                                Text(formatCurrency(expenditure.amount))
                                    .font(.headline)
                                    .fontWeight(.bold)
                            }
                            InfoRow(label: "Date", value: expenditure.date)
                            InfoRow(label: "Purpose", value: expenditure.purpose)
                        }
                        .padding(.vertical)
                    }
                }
            }
        }
        .navigationTitle("\(candidate.firstName) \(candidate.lastName)")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchFinancialData()
        }
    }
    
    private func fetchFinancialData() {
        fetchContributions()
        fetchExpenditures()
    }
    
    // MODIFIED: Updated to use the new download URL and filter by committee ID
    private func fetchContributions() {
        isLoadingContributions = true
        downloadAndParseFile(fileType: "RecA", completion: { result in
            DispatchQueue.main.async {
                isLoadingContributions = false
                switch result {
                case .success(let text):
                    let allContributions = self.parseContributions(from: text)
                    // FIXED: Filter the tuples and then map to get just the contribution objects.
                    self.contributions = allContributions
                        .filter { $0.committeeID == self.candidate.committeeID }
                        .map { $0.contribution }
                case .failure(let error):
                    self.contributionError = error.localizedDescription
                }
            }
        })
    }
    
    // MODIFIED: Updated to use the new download URL and filter by committee ID
    private func fetchExpenditures() {
        isLoadingExpenditures = true
        downloadAndParseFile(fileType: "D2-Expend", completion: { result in
            DispatchQueue.main.async {
                isLoadingExpenditures = false
                switch result {
                case .success(let text):
                    let allExpenditures = self.parseExpenditures(from: text)
                    // FIXED: Filter the tuples and then map to get just the expenditure objects.
                    self.expenditures = allExpenditures
                        .filter { $0.committeeID == self.candidate.committeeID }
                        .map { $0.expenditure }
                case .failure(let error):
                    self.expenditureError = error.localizedDescription
                }
            }
        })
    }

    private func downloadAndParseFile(fileType: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://www.elections.il.gov/CampaignDisclosure/DownloadCDDataFiles.aspx?ddlFileType=\(fileType)") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        print("DEBUG: IL download url: \(url)")

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data, let text = String(data: data, encoding: .utf8) else {
                completion(.failure(URLError(.cannotDecodeContentData)))
                return
            }
            completion(.success(text))
        }.resume()
    }
    
    // MODIFIED: Added committeeID to the parsed struct for filtering
    private func parseContributions(from text: String) -> [(contribution: ILContribution, committeeID: String)] {
        var parsedData: [(ILContribution, String)] = []
        let rows = text.split(whereSeparator: \.isNewline).dropFirst()
        
        for row in rows {
            let fields = row.split(separator: "|", omittingEmptySubsequences: false).map { String($0) }
            if fields.count >= 10, let amount = Double(fields[8]) {
                let contribution = ILContribution(
                    contributor: "\(fields[4]) \(fields[3])",
                    amount: amount,
                    date: fields[7],
                    city: fields[5],
                    state: fields[6]
                )
                let committeeID = fields[1] // Committee ID is the second column
                parsedData.append((contribution, committeeID))
            }
        }
        return parsedData
    }
    
    // MODIFIED: Added committeeID to the parsed struct for filtering
    private func parseExpenditures(from text: String) -> [(expenditure: ILExpenditure, committeeID: String)] {
        var parsedData: [(ILExpenditure, String)] = []
        let rows = text.split(whereSeparator: \.isNewline).dropFirst()
        
        for row in rows {
            let fields = row.split(separator: "|", omittingEmptySubsequences: false).map { String($0) }
            if fields.count >= 11, let amount = Double(fields[9]) {
                let expenditure = ILExpenditure(
                    payee: fields[4],
                    amount: amount,
                    date: fields[8],
                    purpose: fields[6]
                )
                let committeeID = fields[1] // Committee ID is the second column
                parsedData.append((expenditure, committeeID))
            }
        }
        return parsedData
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: amount)) ?? ""
    }
}

