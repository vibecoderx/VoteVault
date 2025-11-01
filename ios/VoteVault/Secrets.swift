//
//  Secrets.swift
//  VoteVault
//

import Foundation

// A helper struct to retrieve secrets from the app's Info.plist
struct Secrets {
    
    /// Retrieves a value from the app's Info.plist for a given key.
    /// - Parameter key: The key for the secret (e.g., "SF_APP_TOKEN").
    /// - Returns: The value as a String, or nil if not found.
    static func get(key: String) -> String? {
        guard let value = Bundle.main.infoDictionary?[key] as? String else {
            print("Error: Secret key '\(key)' not found in Info.plist. Make sure Secrets.xcconfig is set up correctly.")
            return nil
        }
        // Handle cases where the value might be a placeholder
        if value.starts(with: "$(") || value.isEmpty {
            print("Error: Secret key '\(key)' seems to be a placeholder. Check your build configuration.")
            return nil
        }
        return value
    }
}
