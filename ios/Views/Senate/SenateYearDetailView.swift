import SwiftUI

struct SenateYearDetailView: View {
    let state: String
    let cycle: Int
    
    @State private var candidates: [ElectionSummary] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Fetching Senate Election Data...")
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else if candidates.isEmpty {
                Text("No candidates with raised funds found for this cycle.")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                List(candidates) { candidate in
                    // Make the tile tappable, navigating to the new detail view
                    NavigationLink(destination: SenateCandidateDetailView(candidate: candidate, electionYear: cycle)) {
                        SenateCandidateTileView(candidate: candidate)
                    }
                }
            }
        }
        .navigationTitle("\(cycle) Senate Race")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchSenateData()
        }
    }
    
    func getAPIKey() -> String? {
        return "pNdJTlEjNg1iF0DX5idIiwfLfV50easOc7JhXHv6"
    }

    func fetchSenateData() {
        guard let apiKey = getAPIKey() else {
            errorMessage = "API Key is missing."
            isLoading = false
            return
        }
        
        let urlString = "https://api.open.fec.gov/v1/elections/?office=senate&state=\(state)&cycle=\(cycle)&has_raised_funds=true&sort=-total_receipts&per_page=20&api_key=\(apiKey)"
        
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
