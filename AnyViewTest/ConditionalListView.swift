//
//  ConditionalListView.swift
//  AnyViewTest
//
//  Created by Michael Long on 9/4/23.
//

import SwiftUI

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
                OtherView(item: item)
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
