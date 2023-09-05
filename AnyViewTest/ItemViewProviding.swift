//
//  AnyViewTest
//
//  Created by Michael Long on 9/4/23.
//

import SwiftUI

protocol ItemViewProviding {
    func view(for item: Item) -> AnyView
}

struct ProviderDemoView: View {
    let item: Item
    let provider: any ItemViewProviding
    var body: some View {
        provider.view(for: item)
    }
}

struct ProviderListView: View {
    let items: [Item]
    let provider: any ItemViewProviding
    init(items: [Item], provider: any ItemViewProviding) {
        self.items = items
        self.provider = provider
    }
    var body: some View {
        let _ = print("List Evaluated")
        List(items) { item in
            provider.view(for: item) // VStack { provider.view(for: item) }
        }
        .listStyle(.plain)
        .navigationTitle("ProviderView")
    }
}

struct ItemProvider: ItemViewProviding {
    func view(for item: Item) -> AnyView {
        AnyView(ItemView(item: item))
    }
}


//protocol AssociatedViewProviding {
//    associatedtype Content: View
//    func view(for item: Item) -> Content
//}
//
//struct AssociatedProviderDemoView: View {
//    let item: Item
//    let provider: any AssociatedViewProviding
//    var body: some View {
//        provider.view(for: item)
//    }
//}
