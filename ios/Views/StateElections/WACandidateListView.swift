//
//  WACandidateListView.swift
//  VoteVault
//

import SwiftUI

struct WACandidateListView: View {
    let office: String
    let year: Int
    let officeDisplayName: String
    
    @State private var candidates: [WACandidate] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var partyFilter: String?
    
    var filteredCandidates: [WACandidate] {
        if let party = partyFilter {
            if party == "OTHER" {
                return candidates.filter {
                    return $0.party != "DEMOCRATIC" && $0.party != "REPUBLICAN"
                }
            }
            return candidates.filter { $0.party == party }
        } else {
            return candidates
        }
    }

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Fetching Candidates...")
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else if candidates.isEmpty {
                Text("No candidates found for this selection.")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                List {
                    VStack {
                        HStack(spacing: 15) {
                            FilterButton(title: "Dem", party: "DEMOCRATIC", selection: $partyFilter)
                            FilterButton(title: "Rep", party: "REPUBLICAN", selection: $partyFilter)
                            FilterButton(title: "Other", party: "OTHER", selection: $partyFilter)
                        }
                        .padding(.top, 8)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)

                    ForEach(filteredCandidates) { candidate in
                        NavigationLink(destination: WACandidateDetailView(candidate: candidate)) {
                            WACandidateTileView(candidate: candidate)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("\(year) \(officeDisplayName) Race")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchCandidates()
        }
    }
    
    private func fetchCandidates() {
        isLoading = true
        var officeQuery: String

        officeQuery = "office='\(office)'"
        
        guard let url = URL(string: "https://data.wa.gov/resource/kv7h-kjye.json?$select=filer_name,filer_id,party&$where=\(officeQuery) AND election_year='\(year)'&$group=filer_name,filer_id,party&$order=filer_name") else {
            errorMessage = "Invalid URL."
            isLoading = false
            return
        }
        
        print("DEBUG: fetchCandidates URL: \(url)")
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                isLoading = false
                if let data = data {
                    do {
                        let decodedResponse = try JSONDecoder().decode([WACandidate].self, from: data)
                        self.candidates = decodedResponse
                    } catch {
                        self.errorMessage = "Failed to parse candidate data: \(error.localizedDescription)"
                    }
                } else {
                    self.errorMessage = "Error fetching candidate data: \(error?.localizedDescription ?? "Unknown error")"
                }
            }
        }.resume()
    }
}

