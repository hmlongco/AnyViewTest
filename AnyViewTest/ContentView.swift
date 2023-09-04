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
    let items10K = (0 ..< 10_000).map { Item(id: $0 + 1) }
    let items100K = (0 ..< 100_000).map { Item(id: $0 + 1) }
}

struct Item: Identifiable {
    var id: Int
    var text: String
    init(id: Int) {
        self.id = id
        self.text = "Item \(id)"
    }
}

// NavigationLink<Label, Destination>
struct ItemView: View {
    @State var item: Item
    init(item: Item) {
        self.item = item
        print("Item \(item.id) Initialized")
    }
    var body: some View {
        let _ = print("Item \(item.id) Evaluated")
        NavigationLink(destination: DestinationView(item: item)) {
            HStack {
                Text(item.text)
                Spacer()
                Button("+") {
                    print("Updating Item \(item.id)")
                    item.text = item.text + " Updated"
                    print("Updated Item \(item.id)")
                }
                .foregroundColor(.accentColor)
                .buttonStyle(.plain)
            }
        }
    }
}

struct OtherView: View {
    @State var item: Item
    var body: some View {
        Text("")
    }
}

// List<Never, ForEach<[Item], Int, ItemView>>
// List<Never, ForEach<[Item], Int, AnyView>>
// List<Never, ForEach<[Item], Int, _ConditionalContent<ItemView, OtherView>>>
struct NormalListView: View {
    @State var items: [Item]
    let title: String
    init(items: [Item], title: String = "Item") {
        self.items = items
        self.title = title
    }
    var body: some View {
        let _ = print("List Evaluated")
        List(items) { item in
            ItemView(item: item)
        }
        .listStyle(.plain)
        .navigationTitle(title)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("+") { items.append(Item(id: items.count + 1))  }
            }
        }
    }

}

struct ConditionalListView: View {
    @State var items: [Item]
    let title: String
    init(items: [Item], title: String = "Item") {
        self.items = items
        self.title = title
    }
    var body: some View {
        let _ = print("List Evaluated")
        List(items) { item in
            if item.id.isMultiple(of: 2) {
                ItemView(item: item)
            } else {
                ItemView(item: item)
            }
        }
        .listStyle(.plain)
        .navigationTitle(title)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("+") { items.append(Item(id: items.count + 1))  }
            }
        }
    }
}

struct AnyListView: View {
    @State var items: [Item]
    init(items: [Item]) {
        self.items = items
    }
    var body: some View {
        List(items) { item in
            AnyView(ItemView(item: item))
        }
        .navigationTitle("AnyView(Item)")
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("+") { items.append(Item(id: items.count + 1))  }
            }
        }
    }
}

struct WrappedAnyListView: View {
    @State var items: [Item]
    init(items: [Item]) {
        self.items = items
    }
    var body: some View {
        let _ = print("List Evaluated")
        List(items) { item in
            VStack { AnyView(ItemView(item: item)) }
        }
        .navigationTitle("Wrapped(AnyView)")
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("+") { items.append(Item(id: items.count + 1))  }
            }
        }
    }
}

struct LazyVStackAnyView: View {
    @State var items: [Item]
    init(items: [Item]) {
        self.items = items
    }
    var body: some View {
        let _ = print("List Evaluated")
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(items) { item in
                    AnyView(ItemView(item: item))
                }
            }
            .padding()
        }
        .navigationTitle("LazyVStack AnyView")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("+") { items.append(Item(id: items.count + 1))  }
            }
        }
    }
}

struct DestinationView: View {
    let item: Item
    @State var id = UUID().uuidString
    @EnvironmentObject var model: ContentModel
    init(item: Item) {
        self.item = item
        print("Destination \(item.id) Initialized")
    }
    var body: some View {
        let _ = print("Destination \(item.id) Evaluated")
        VStack(spacing: 30) {
            Text("Count is \(model.count)")
            Button("Update Counter") {
                model.count += 1
            }
            Text(id)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .navigationTitle("Item \(item.id)")
    }
}

struct ContentView: View {
    @StateObject var model = ContentModel()
    var body: some View {
        let _ = print("ContentView Evaluated, Lists Initialized")
        NavigationView {
            List {
                Section("List with Item - GOOD") {
                    NavigationLink {
                        NormalListView(items: model.items10)
                    } label: { Text("Item 10") }
                    NavigationLink {
                        NormalListView(items: model.items100)
                    } label: { Text("Item 100") }
                    NavigationLink {
                        NormalListView(items: model.items100K)
                    } label: { Text("Item 100K") }
                }

                Section("List with AnyView(Item) - BAD") {
                    NavigationLink {
                        AnyListView(items: model.items10)
                    } label: { Text("AnyView(Item) 10") }
                    NavigationLink {
                        AnyListView(items: model.items100)
                    } label: { Text("AnyView(Item) 100") }
                    NavigationLink {
                        AnyListView(items: model.items10K)
                    } label: { Text("AnyView(Item) 10K - DELAY") }
                    NavigationLink {
                        AnyListView(items: model.items100K)
                    } label: { Text("AnyView(Item) 100K - AVOID") }
                }

                Section("List with Conditional(Item) - BAD") {
                    NavigationLink {
                        ConditionalListView(items: model.items10)
                    } label: { Text("Conditional(Item) 10") }
                    NavigationLink {
                        ConditionalListView(items: model.items100)
                    } label: { Text("Conditional(Item) 100") }
                    NavigationLink {
                        ConditionalListView(items: model.items10K)
                    } label: { Text("Conditional(Item) 10K - DELAY") }
                    NavigationLink {
                        ConditionalListView(items: model.items100K)
                    } label: { Text("Conditional(Item) 100K - AVOID") }
                }

                Section("List with Wrapped(AnyView) - GOOD") {
                    NavigationLink {
                        WrappedAnyListView(items: model.items10)
                    } label: { Text("Wrapped(AnyView) 10") }
                    NavigationLink {
                        WrappedAnyListView(items: model.items100)
                    } label: { Text("Wrapped(AnyView) 100") }
                    NavigationLink {
                        WrappedAnyListView(items: model.items100K)
                    } label: { Text("Wrapped(AnyView) 100K") }
                }

                Section("LazyVStack AnyView(Item) - GOOD") {
                    NavigationLink {
                        LazyVStackAnyView(items: model.items10)
                    } label: { Text("LazyVStack AnyView(Item) 10") }
                    NavigationLink {
                        LazyVStackAnyView(items: model.items100)
                    } label: { Text("LazyVStack AnyView(Item) 100") }
                    NavigationLink {
                        LazyVStackAnyView(items: model.items100K)
                    } label: { Text("LazyVStack AnyView(Item) 100K") }
                }

                Section("AnyView(List) - GOOD") {
                    NavigationLink {
                        AnyView(NormalListView(items: model.items10, title: "AnyView(List)"))
                    } label: { Text("AnyView(List) 10") }
                    NavigationLink {
                        AnyView(NormalListView(items: model.items100, title: "AnyView(List)"))
                    } label: { Text("AnyView(List) 100") }
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

//struct SomeView: View {
//    let item: Item
//    var body: some View {
//        if item.id.isMultiple(of: 2) {
//            ItemView(item: item)
//        } else {
//            OtherView(item: item)
//        }
//    }
//}
//
