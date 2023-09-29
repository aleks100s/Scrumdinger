//
//  ScrumdingerApp.swift
//  Scrumdinger
//
//  Created by Alexander on 26.09.2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct ScrumdingerApp: App {
    var body: some Scene {
        WindowGroup {
			AppView(store: Store(initialState: AppFeature.State()) {
				AppFeature()
			})
        }
    }
}
