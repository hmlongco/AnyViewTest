//
//  WrapppedAnyListView.swift
//  AnyViewTest
//
//  Created by Michael Long on 9/4/23.
//

import SwiftUI

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

struct WrappedAnyListView_Previews: PreviewProvider {
    static var previews: some View {
        WrappedAnyListView(items: [])
    }
}
