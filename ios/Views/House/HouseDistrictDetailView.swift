//
// File: HouseDistrictDetailView.swift (MODIFIED)
// Folder: Views/House
//

import SwiftUI

struct HouseDistrictDetailView: View {
    let state: String
    let cycle: Int
    let district: Int
    
    @State private var candidates: [ElectionSummary] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Fetching House Election Data...")
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else if candidates.isEmpty {
                Text("No candidates with raised funds found for this selection.")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                List(candidates) { candidate in
                    NavigationLink(destination: HouseCandidateDetailView(candidate: candidate, electionYear: cycle)) {
                        HouseCandidateTileView(candidate: candidate)
                    }
                }
            }
        }
        .navigationTitle("\(state)-\(district) (\(cycle))")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchHouseData()
        }
    }
    
    func getAPIKey() -> String? {
        return "pNdJTlEjNg1iF0DX5idIiwfLfV50easOc7JhXHv6"
    }

    func fetchHouseData() {
        guard let apiKey = getAPIKey() else {
            errorMessage = "API Key is missing."
            isLoading = false
            return
        }
        
        let urlString = "https://api.open.fec.gov/v1/elections/?office=house&state=\(state)&cycle=\(cycle)&district=\(district)&has_raised_funds=true&sort=-total_receipts&per_page=20&api_key=\(apiKey)"
        
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
                        let decodedResponse = try JSONDecoder().decode(ElectionsResponse.self, from: data)
                        self.candidates = decodedResponse.results
                    } catch {
                        self.errorMessage = "Failed to parse data. Error: \(error.localizedDescription)"
                    }
                } else {
                    let errorMessageString = error?.localizedDescription ?? "An unknown error occurred."
                    self.errorMessage = "Error fetching data: \(errorMessageString)"
                }
            }
        }.resume()
    }
}
