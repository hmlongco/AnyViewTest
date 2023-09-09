//
//  AnyViewTest
//
//  Created by Michael Long on 9/4/23.
//

import SwiftUI

protocol ItemViewProviding {
    func view(for item: Item) -> AnyView
    func wrappedAnyView(for item: Item) -> WrappedAnyView
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
            provider.view(for: item)
        }
        .listStyle(.plain)
        .navigationTitle("ProviderView")
    }
}

struct WrappedProviderListView: View {
    let items: [Item]
    let provider: any ItemViewProviding
    init(items: [Item], provider: any ItemViewProviding) {
        self.items = items
        self.provider = provider
    }
    var body: some View {
        let _ = print("List Evaluated")
        List(items) { item in
            provider.wrappedAnyView(for: item)
        }
        .listStyle(.plain)
        .navigationTitle("ProviderView")
    }
}

struct ItemProvider: ItemViewProviding {
    func view(for item: Item) -> AnyView {
        ItemView(item: item).asAnyView
    }
    func wrappedAnyView(for item: Item) -> WrappedAnyView {
        WrappedAnyView { ItemView(item: item) }
    }
}

struct WrappedAnyView: View {
    let wrapped: AnyView
    init<Content:View>(_ wrapped: Content) {
        self.wrapped = AnyView(wrapped)
    }
    init<Content:View>(@ViewBuilder _ wrapped: () -> Content) {
        self.wrapped = AnyView(wrapped())
    }
    var body: some View {
        VStack { wrapped }
    }
}

extension View {
    var asAnyView: AnyView {
        AnyView(self)
    }
    var asWrappedAnyView: WrappedAnyView {
        WrappedAnyView(self)
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
