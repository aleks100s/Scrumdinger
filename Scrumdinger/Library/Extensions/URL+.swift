//
//  URL+.swift
//  Scrumdinger
//
//  Created by Alexander on 05.10.2023.
//

import Foundation

extension URL {
	static let standups = Self.documentsDirectory.appending(component: "standups.json")
}
