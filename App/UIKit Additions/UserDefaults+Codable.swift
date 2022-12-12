//
//  UserDefaults+Codable.swift
//  CountMeIn
//
//  Created by Joseph Wardell on 12/1/21.
//

import Foundation

extension UserDefaults {
    
    func setCodable<C: Codable>(_ storeable: C, forKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(storeable) {
            self.set(encoded, forKey: key)
        }
    }
    
    func codable<C: Codable>(forKey key: String) -> C? {
        guard let data = object(forKey: key) as? Data else { return nil }
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(C.self, from: data)
        }
        catch {
            print("error retrieving value for key \(key) from \(self): \(error.localizedDescription)")
            return nil
        }
    }
    
}
