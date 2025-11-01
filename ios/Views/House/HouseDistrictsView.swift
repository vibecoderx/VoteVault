//
// File: HouseDistrictsView.swift (MODIFIED)
// Folder: Views/House
//

import SwiftUI

struct HouseDistrictsView: View {
    let state: String
    let cycle: Int
    
    @State private var districts: [Int] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Finding Districts...")
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                List {
                    ForEach(districts, id: \.self) { district in
                        NavigationLink(destination: HouseDistrictDetailView(state: state, cycle: cycle, district: district)) {
                            // Using a more appropriate icon and less padding
                            ElectionTypeRow(title: "District \(district)", icon: "building.columns.fill")
                        }
                        .listRowInsets(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                    }
                }
                .listStyle(.plain) // Use plain style for a cleaner look
            }
        }
        .navigationTitle("Select a District")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchDistricts()
        }
    }
    
    func getAPIKey() -> String? {
        return "pNdJTlEjNg1iF0DX5idIiwfLfV50easOc7JhXHv6"
    }

    func fetchDistricts() {
        guard let apiKey = getAPIKey() else {
            errorMessage = "API Key is missing."
            isLoading = false
            return
        }
        
        let urlString = "https://api.open.fec.gov/v1/candidates/?office=H&state=\(state)&cycle=\(cycle)&per_page=100&api_key=\(apiKey)"
        
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
                        let decodedResponse = try JSONDecoder().decode(CandidateResponse.self, from: data)
                        let districtSet = Set(decodedResponse.results.compactMap { $0.district_number })
                        self.districts = Array(districtSet).sorted()
                        
                        if self.districts.isEmpty {
                            errorMessage = "No districts with candidates found for this cycle."
                        }
                        
                    } catch {
                        self.errorMessage = "Failed to parse district data. Error: \(error.localizedDescription)"
                    }
                } else {
                    let errorMessageString = error?.localizedDescription ?? "An unknown error occurred."
                    self.errorMessage = "Error fetching data: \(errorMessageString)"
                }
            }
        }.resume()
    }
}
