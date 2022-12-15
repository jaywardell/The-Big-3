//
//  Dictionary+Codable.swift
//  The Big 3
//
//  Created by Joseph Wardell on 12/15/22.
//

import Foundation

extension Dictionary where Value == Any, Key == String {
    
    func decode<T>(_ key: String) -> T? where T: Codable {
        guard let data = self[key] as? Data,
              let goal = try? JSONDecoder().decode(T.self, from: data)
        else { return nil }
        return goal
    }
}
