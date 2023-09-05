//
//  DestinationView.swift
//  AnyViewTest
//
//  Created by Michael Long on 9/4/23.
//

import SwiftUI

struct DestinationView: View {
    let item: Item
    @State var id = UUID().uuidString
    @State var name = "Michael"
    @EnvironmentObject var model: ContentModel
    init(item: Item) {
        self.item = item
        print("Destination \(item.id) Initialized")
    }
    var body: some View {
        let _ = print("Destination \(item.id) Evaluated with \(id)")
        VStack(spacing: 30) {
            Text("Name is \(name)")
            TextField("Name", text: $name)
                .textFieldStyle(.roundedBorder)
            Text("Count is \(model.count)")
            Button("Update Counter") {
                print("Updating Counter")
                model.count += 1
                print("Updated Counter")
            }
            Text(id)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("Item \(item.id)")
    }
}
