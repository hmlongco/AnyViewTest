//
//  AnyListView.swift
//  AnyViewTest
//
//  Created by Michael Long on 9/4/23.
//

import SwiftUI

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

struct AnyListView_Previews: PreviewProvider {
    static var previews: some View {
        AnyListView(items: [])
    }
}
