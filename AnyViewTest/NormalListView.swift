//
//  NormalListView.swift
//  AnyViewTest
//
//  Created by Michael Long on 9/4/23.
//

import SwiftUI

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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("+") { items.append(Item(id: items.count + 1))  }
            }
        }
        .navigationTitle(title)
    }
}

struct NormalListView_Previews: PreviewProvider {
    static var previews: some View {
        NormalListView(items: [])
    }
}
