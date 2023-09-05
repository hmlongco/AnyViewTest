//
//  ItemView.swift
//  AnyViewTest
//
//  Created by Michael Long on 9/4/23.
//

import SwiftUI

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
        NavigationLink(destination: AnyView(DestinationView(item: item))) {
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

//struct ItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemView()
//    }
//}
