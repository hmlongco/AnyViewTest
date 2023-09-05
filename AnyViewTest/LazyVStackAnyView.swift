//
//  LazyVStackAnyView.swift
//  AnyViewTest
//
//  Created by Michael Long on 9/4/23.
//

import SwiftUI

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

struct LazyVStackAnyView_Previews: PreviewProvider {
    static var previews: some View {
        LazyVStackAnyView(items: [])
    }
}
