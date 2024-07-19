//
//  TabView.swift
//  thatsumetmoi
//
//  Created by TuanDL2 on 19/7/24.
//

import SwiftUI

struct AppTabView: View {
    var body: some View {
        TabView {
//            NavigationView {
                HomeView()
//            }
            .tabItem {
                Label("Home", systemImage: "house")
            }

            NavigationView {
                DiscoverView()
            }
            .tabItem {
                Label("Discover", systemImage: "magnifyingglass")
            }
        }
    }
}


#Preview {
    AppTabView()
}
