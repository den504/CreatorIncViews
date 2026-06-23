//
//  ContentView.swift
//  CreatorInc
//
//  Created by Dennis Okafor on 16/06/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var activeScreen: ActiveScreen = .welcome
    @State private var selectedRole: AccountRole = .creator

    var body: some View {
        switch activeScreen {
        case .welcome:
            WelcomeView { role in
                selectedRole = role
                activeScreen = .createAccount
            }
        case .createAccount:
            CreateAccountView(selectedRole: $selectedRole) {
                activeScreen = .welcome
            }
        }
    }
}

private enum ActiveScreen {
    case welcome
    case createAccount
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
