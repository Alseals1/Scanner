//
//  ScanMeApp.swift
//  ScanMe
//
//  Created by Alandis Seals on 7/21/23.
//

import SwiftUI

@main
struct ScanMeApp: App {
    @StateObject private var vm = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
                .task {
                    await vm.requestDataScannerAccessStatus()
                }
        }
    }
}
