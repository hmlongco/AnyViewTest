//
//  ContentView.swift
//  AnyViewTest
//
//  Created by Michael Long on 6/20/23.
//

import SwiftUI

class ContentModel: ObservableObject {

    @Published var count: Int = 0

    let items10 = (0 ..< 10).map { Item(id: $0 + 1) }
    let items100 = (0 ..< 100).map { Item(id: $0 + 1) }
    let items1K = (0 ..< 1_000).map { Item(id: $0 + 1) }
    let items10K = (0 ..< 10_000).map { Item(id: $0 + 1) }
    let items100K = (0 ..< 100_000).map { Item(id: $0 + 1) }

}

struct ContentView: View {

    @StateObject var model = ContentModel()

    var body: some View {

        let _ = print("ContentView Evaluated, List Menu Initialized")

        NavigationView {
            List {
                Section("List with Item - O(1)") {
                    NavigationLink {
                        NormalListView(items: model.items10)
                    } label: { Text("Item 10") }
                    NavigationLink {
                        NormalListView(items: model.items1K)
                    } label: { Text("Item 1K") }
                    NavigationLink {
                        NormalListView(items: model.items10K)
                    } label: { Text("Item 10K") }
                    NavigationLink {
                        NormalListView(items: model.items100K)
                    } label: { Text("Item 100K") }
                }

                Section("List with AnyView(Item) - O(N)") {
                    NavigationLink {
                        AnyListView(items: model.items10)
                    } label: { Text("AnyView(Item) 10") }
                    NavigationLink {
                        AnyListView(items: model.items100)
                    } label: { Text("AnyView(Item) 100") }
                    NavigationLink {
                        AnyListView(items: model.items1K)
                    } label: { Text("AnyView(Item) 1K") }
                    NavigationLink {
                        AnyListView(items: model.items10K)
                    } label: { Text("AnyView(Item) 10K - DELAY") }
                    NavigationLink {
                        AnyListView(items: model.items100K)
                    } label: { Text("AnyView(Item) 100K - AVOID") }
                }

                Section("List with Conditional(Item) - O(N)") {
                    NavigationLink {
                        ConditionalListView(items: model.items10)
                    } label: { Text("Conditional(Item) 10") }
                    NavigationLink {
                        ConditionalListView(items: model.items1K)
                    } label: { Text("Conditional(Item) 1K") }
                    NavigationLink {
                        ConditionalListView(items: model.items10K)
                    } label: { Text("Conditional(Item) 10K - DELAY") }
                    NavigationLink {
                        ConditionalListView(items: model.items100K)
                    } label: { Text("Conditional(Item) 100K - AVOID") }
                }

                Section("List with Wrapped(AnyView) - O(1)") {
                    NavigationLink {
                        WrappedAnyListView(items: model.items10)
                    } label: { Text("Wrapped(AnyView) 10") }
                    NavigationLink {
                        WrappedAnyListView(items: model.items100K)
                    } label: { Text("Wrapped(AnyView) 100K") }
                }

                Section("List with Provider(Item) - O(1)") {
                    NavigationLink {
                        ProviderListView(items: model.items1K, provider: ItemProvider())
                    } label: { Text("ProviderListView AnyView(Item) 1K") }
                }

                Section("LazyVStack AnyView(Item) - O(1)") {
                    NavigationLink {
                        LazyVStackAnyView(items: model.items100K)
                    } label: { Text("LazyVStack AnyView(Item) 100K") }
                }

                Section("AnyView(List) - O(1)") {
                    NavigationLink {
                        AnyView(NormalListView(items: model.items100K, title: "AnyView(List)"))
                    } label: { Text("AnyView(List) 100K") }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Performance")
        }
        .navigationViewStyle(.stack)
        .environmentObject(model)
    }
}
