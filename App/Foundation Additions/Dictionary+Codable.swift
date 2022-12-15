//
//  Dictionary+Codable.swift
//  The Big 3
//
//  Created by Joseph Wardell on 12/15/22.
//

import Foundation

extension Dictionary where Key == String, Value == Encodable {
    
    init(_ key: String, _ value: Value) throws {
        self.init()
        try encode(value, for: key)
    }
    
    mutating func encode(_ value: Value, for key: String) throws {
        let encoder = JSONEncoder()
        let encoded = try encoder.encode(value)
        updateValue(encoded, forKey: key)
    }
}

extension Dictionary where Value == Any, Key == String {
    
    func decode<T>(_ key: String) -> T? where T: Codable {
        guard let data = self[key] as? Data,
              let goal = try? JSONDecoder().decode(T.self, from: data)
        else { return nil }
        return goal
    }
}
