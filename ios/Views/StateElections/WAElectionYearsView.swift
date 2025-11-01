//
//  WAElectionYearsView.swift
//  VoteVault
//

import SwiftUI

struct WAElectionYearsView: View {
    let office: String
    @State private var electionYears: [WAElectionYear] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Fetching Election Years...")
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else if electionYears.isEmpty {
                Text("No election data found for this office.")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                VStack(spacing: 20) {
                    Text("Select an Election Year")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    List(electionYears, id: \.self) { year in
                        if let yearInt = Int(year.election_year) {
                            NavigationLink(destination: WACandidateListView(office: office, year: yearInt, officeDisplayName: office)) {
                                ElectionTypeRow(title: "\(year.election_year) Election", icon: "calendar")
                            }
                        }
                    }
                    .listStyle(.plain)
                }
                .padding(.top)
            }
        }
        .navigationTitle(office)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchElectionYears()
        }
    }
    
    private func fetchElectionYears() {
        isLoading = true
        var officeQuery: String
        
        officeQuery = "office='\(office)'"
        print("DEBUG: fetchElectionYears: officeQuery: \(officeQuery)")

        
        guard let url = URL(string: "https://data.wa.gov/resource/kv7h-kjye.json?$select=election_year&$where=\(officeQuery)&$group=election_year&$order=election_year DESC") else {
            errorMessage = "Invalid URL."
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                isLoading = false
                if let data = data {
                    do {
                        let decodedResponse = try JSONDecoder().decode([WAElectionYear].self, from: data)
                        self.electionYears = decodedResponse
                    } catch {
                        self.errorMessage = "Failed to parse election years: \(error.localizedDescription)"
                    }
                } else {
                    self.errorMessage = "Error fetching election years: \(error?.localizedDescription ?? "Unknown error")"
                }
            }
        }.resume()
    }
}

struct WAElectionYearsView_Previews: PreviewProvider {
    static var previews: some View {
        WAElectionYearsView(office: "Governor")
    }
}

