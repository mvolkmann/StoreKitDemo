import StoreKit
import SwiftUI

private let colors: [String: Color] = [
    "p1": .black,
    "p2": .red,
    "p3": .red
]
private let icons: [String: Image] = [
    "p1": Image(systemName: "suit.club.fill"),
    "p2": Image(systemName: "suit.diamond.fill"),
    "p3": Image(systemName: "suit.heart.fill")
]

struct ContentView: View {
    @EnvironmentObject private var store: StoreKitStore

    // TODO: Can you get the product ids from the store object?
    let productIds = ["p1", "p2", "p3"]

    private func productIcon(id: String) -> some View {
        ZStack {
            Circle().fill(.gray).opacity(0.5)
            let color: Color = colors[id] ?? .black
            let image = icons[id] ??
                Image(systemName: "circle.slash")
            image
                .resizable()
                .scaledToFit()
                .foregroundStyle(color)
                .frame(width: 40)
        }
        .frame(width: 70)
    }

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            StoreView(ids: productIds) { product in
                productIcon(id: product.id)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
