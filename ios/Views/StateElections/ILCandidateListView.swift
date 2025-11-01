//
//  ILCandidateListView.swift
//  VoteVault
//

import SwiftUI

struct ILCandidateListView: View {
    let office: ILElectionOffice
    let year: Int
    
    @State private var candidates: [ILCandidate] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Fetching Candidates...")
            } else if let errorMessage = errorMessage {
                Text(errorMessage).foregroundColor(.red).padding()
            } else if candidates.isEmpty {
                Text("No candidates found for this selection.").foregroundColor(.secondary).padding()
            } else {
                List(candidates) { candidate in
                    NavigationLink(destination: ILCandidateDetailView(candidate: candidate, year: year)) {
                        ILCandidateTileView(candidate: candidate)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("\(year) \(office.name) Race")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchIllinoisCandidates()
        }
    }
    
    // MODIFIED: Implemented a two-step fetch to handle hidden form fields (__VIEWSTATE, __EVENTVALIDATION).
    private func fetchIllinoisCandidates() {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "https://www.elections.il.gov/CampaignDisclosure/DownloadCDDataFiles.aspx") else {
            self.errorMessage = "Invalid URL."
            self.isLoading = false
            return
        }

        // Step 1: GET the page to scrape hidden fields
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let html = String(data: data, encoding: .utf8) else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load initial page."
                    self.isLoading = false
                }
                return
            }
            
            // Scrape the required hidden values from the HTML
            let viewState = self.scrapeValue(for: "__VIEWSTATE", in: html)
            let eventValidation = self.scrapeValue(for: "__EVENTVALIDATION", in: html)
            
            // Step 2: POST the data along with the scraped hidden values
            self.postToDownloadFile(url: url, viewState: viewState, eventValidation: eventValidation)
            
        }.resume()
    }
    
    private func postToDownloadFile(url: URL, viewState: String, eventValidation: String) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        // Construct the full POST data including the hidden fields AND the download button's value.
        // The space in "Download File" needs to be URL encoded as "+".
        let postDataString = "ddlFileType=Cand&__VIEWSTATE=\(viewState)&__EVENTVALIDATION=\(eventValidation)&btnDownload=Download+File"
        request.httpBody = postDataString.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    self.errorMessage = "Network Error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data, let text = String(data: data, encoding: .utf8) else {
                    self.errorMessage = "Could not read data from the server."
                    return
                }
                
                print("DEBUG: text: \(text)")
                print("DEBUG: data: \(data)")
                
                // Check if we got HTML back again (which would mean an error)
                if text.trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix("<!DOCTYPE html") {
                    self.errorMessage = "Failed to download data. The server responded with a web page instead of a data file. This may be due to a change on the IL elections website."
                    return
                }
                
                var parsedCandidates: [ILCandidate] = []
                let rows = text.split(whereSeparator: \.isNewline)
                
                for row in rows.dropFirst() {
                    print("DEBUG: row: \(row)")
                    let fields = row.split(separator: "|", omittingEmptySubsequences: false).map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
                    
                    if fields.count >= 9 {
                        let officeAndYear = fields[6].split(separator: "-").map { $0.trimmingCharacters(in: .whitespaces) }
                        let officeNameFromFile = String(officeAndYear.first ?? "")
                        let yearFromFile = Int(officeAndYear.last ?? "")
                        
                        let candidate = ILCandidate(
                            lastName: fields[0],
                            firstName: fields[1],
                            address: fields[2],
                            city: fields[3],
                            state: fields[4],
                            zip: fields[5],
                            office: officeNameFromFile,
                            politicalParty: fields[7],
                            committeeID: fields[8],
                            electionYear: yearFromFile ?? 0
                        )
                        parsedCandidates.append(candidate)
                    }
                }
                
                // Perform filtering after parsing
                self.candidates = parsedCandidates.filter {
                    $0.office.trimmingCharacters(in: .whitespaces).lowercased() == self.office.name.lowercased() && $0.electionYear == self.year
                }
            }
        }.resume()
    }
    
    // Helper function to scrape a hidden input value from HTML content
    private func scrapeValue(for key: String, in html: String) -> String {
        guard let range = html.range(of: "id=\"\(key)\"") else { return "" }
        let subsequentHTML = html[range.upperBound...]
        guard let valueRangeStart = subsequentHTML.range(of: "value=\"") else { return "" }
        let fromValue = subsequentHTML[valueRangeStart.upperBound...]
        guard let valueRangeEnd = fromValue.range(of: "\"") else { return "" }
        
        let value = String(fromValue[..<valueRangeEnd.lowerBound])
        // URL encode the scraped value to handle special characters
        return value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
}

