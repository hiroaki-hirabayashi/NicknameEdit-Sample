//
//  NicknameEdit_SampleApp.swift
//  NicknameEdit-Sample
//
//  Created by Hiroaki-Hirabayashi on 2022/04/13.
//

import SwiftUI

@main
struct NicknameEdit_SampleApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
