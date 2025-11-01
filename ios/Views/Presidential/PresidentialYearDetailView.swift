//
// File: PresidentialYearDetailView.swift
// Folder: Views/Presidential
//

import SwiftUI

struct PresidentialYearDetailView: View {
    let electionYear: String
    
    @State private var summaries: [PresidentialFinancialSummary] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var partyFilter: String?

    var filteredSummaries: [PresidentialFinancialSummary] {
        if let party = partyFilter {
            return summaries.filter { $0.candidate_party_affiliation == party }
        } else {
            return summaries
        }
    }

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Fetching Financial Data...")
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                List {
                    VStack {
                        HStack(spacing: 15) {
                            FilterButton(title: "Dem", party: "DEM", selection: $partyFilter)
                            FilterButton(title: "Rep", party: "REP", selection: $partyFilter)
                            FilterButton(title: "Ind", party: "IND", selection: $partyFilter)
                        }
                        .padding(.top, 8)

                        Text("The list of candidates is sorted by the total money raised (from highest to lowest amount)")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)

                    ForEach(filteredSummaries) { summary in
                        NavigationLink(destination: CandidateDetailView(summary: summary, electionYear: electionYear)) {
                            CandidateTileView(summary: summary)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("\(electionYear) Presidential Finances")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchFinancialData()
        }
    }
    
    func getAPIKey() -> String? {
        return "pNdJTlEjNg1iF0DX5idIiwfLfV50easOc7JhXHv6"
    }

    func fetchFinancialData() {
        guard let apiKey = getAPIKey() else {
            errorMessage = "API Key is missing."
            isLoading = false
            return
        }
        
        let urlString = "https://api.open.fec.gov/v1/presidential/financial_summary/?sort=-net_receipts&page=1&election_year=\(electionYear)&per_page=10&api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL."
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                isLoading = false
                if let data = data {
                    do {
                        let decodedResponse = try JSONDecoder().decode(PresidentialResponse.self, from: data)
                        self.summaries = decodedResponse.results
                    } catch {
                        self.errorMessage = "Failed to parse data from the server. Error: \(error.localizedDescription)"
                    }
                } else {
                    let errorMessageString = error?.localizedDescription ?? "An unknown error occurred."
                    self.errorMessage = "Error fetching data: \(errorMessageString)"
                }
            }
        }.resume()
    }
}
