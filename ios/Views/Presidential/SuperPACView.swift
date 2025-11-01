//
// File: SuperPACView.swift
// Folder: Views/Presidential
//

import SwiftUI

struct SuperPACView: View {
    let candidateId: String
    let electionYear: Int

    enum SupportType: String, CaseIterable, Identifiable {
        case supporting = "For"
        case opposing = "Against"
        var id: Self { self }
    }

    @State private var selectedType: SupportType = .supporting
    @State private var supportExpenditures: [SuperPACExpenditure] = []
    @State private var opposeExpenditures: [SuperPACExpenditure] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Fetching Super PAC Data...")
            } else if let errorMessage = errorMessage {
                Text(errorMessage).foregroundColor(.red).padding()
            } else {
                HStack(spacing: 0) {
                    SuperPACFilterButton(title: "For", type: .supporting, selection: $selectedType)
                    SuperPACFilterButton(title: "Against", type: .opposing, selection: $selectedType)
                }
                .padding()

                List {
                    if selectedType == .supporting {
                        ForEach(supportExpenditures) { item in
                            SuperPACTileView(expenditure: item)
                        }
                    } else {
                        ForEach(opposeExpenditures) { item in
                            SuperPACTileView(expenditure: item)
                        }
                    }
                }
            }
        }
        .navigationTitle("Super PAC Expenditures")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: fetchSuperPACData)
    }

    func getAPIKey() -> String? {
        return "pNdJTlEjNg1iF0DX5idIiwfLfV50easOc7JhXHv6"
    }

    func fetchSuperPACData() {
        guard let apiKey = getAPIKey() else {
            errorMessage = "API Key is missing."
            isLoading = false
            return
        }

        let urlString = "https://api.open.fec.gov/v1/schedules/schedule_e/by_candidate/?candidate_id=\(candidateId)&cycle=\(electionYear)&sort=-total&per_page=50&api_key=\(apiKey)"

        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL for Super PAC data."
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                isLoading = false
                if let data = data {
                    do {
                        let decodedResponse = try JSONDecoder().decode(SuperPACResponse.self, from: data)
                        let filtered = decodedResponse.results.filter { $0.cycle == electionYear }
                        
                        self.supportExpenditures = filtered.filter { $0.support_oppose_indicator == "S" }
                        self.opposeExpenditures = filtered.filter { $0.support_oppose_indicator == "O" }

                    } catch {
                        self.errorMessage = "Failed to parse Super PAC data. Error: \(error.localizedDescription)"
                    }
                } else {
                    let errorMessageString = error?.localizedDescription ?? "An unknown error occurred."
                    self.errorMessage = "Error fetching Super PAC data: \(errorMessageString)"
                }
            }
        }.resume()
    }
}
