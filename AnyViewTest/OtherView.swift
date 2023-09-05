//
//  OtherView.swift
//  AnyViewTest
//
//  Created by Michael Long on 9/4/23.
//

import SwiftUI

struct OtherView: View {
    @State var item: Item
    init(item: Item) {
        self.item = item
        print("Other \(item.id) Initialized")
    }
    var body: some View {
        let _ = print("Other \(item.id) Evaluated")
        NavigationLink(destination: DestinationView(item: item)) {
            HStack {
                Text(item.text)
                Spacer()
                Button("+") {
                    print("Updating Other \(item.id)")
                    item.text = item.text + " Updated"
                    print("Updated Other \(item.id)")
                }
                .foregroundColor(.accentColor)
                .buttonStyle(.plain)
            }
        }
    }
}
