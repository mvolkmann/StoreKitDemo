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
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var store: StoreKitStore
    @State private var isPurchasing = false

    // TODO: Can you get the product ids from the store object?
    private let productIds = ["p1", "p2", "p3"]
    private let iconSize = 70.0

    private func productIcon(id: String) -> some View {
        ZStack {
            Circle().fill(.gray.opacity(0.2))
            let color: Color = colors[id] ?? .black
            let image = icons[id] ??
                Image(systemName: "circle.slash")
            image
                .resizable()
                .scaledToFit()
                .foregroundStyle(color)
                .frame(width: iconSize / 2)
        }
        .frame(width: iconSize, height: iconSize)
    }

    var body: some View {
        VStack(alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/) {
            Text("Choose a plan.").fontWeight(.bold)

            StoreView(ids: productIds) { product in
                // productIcon(id: product.id)
                ProductView(id: product.id) {
                    productIcon(id: product.id)
                } placeholderIcon: {
                    Circle()
                }
            }
            // This size has an issue with horizontal alignment.
            // .productViewStyle(.large)
            // .productViewStyle(.regular) // default
            .productViewStyle(.compact)

            // TODO: Why doesn't this work?
            /*
             SubscriptionStoreView(groupID: "subscriptions")
                 .containerBackground(for: .subscriptionStoreFullHeight) {
                     Color.yellow
                 }
                .subscriptionStoreButtonLabel(.multiline)
                .subscriptionStorePickerItemBackground(.thinMaterial)
                .storeButton(.visible, for: .redeemCode)
             */
        }
        .padding()
        .background(.yellow.opacity(0.3))

        // This handles the event from any descendant view.
        .onInAppPurchaseStart { _ in
            isPurchasing = true
            // This might be used to dim other views.
        }

        // This handles the event from any descendant view.
        .onInAppPurchaseCompletion { product, result in
            if case let .success(.success(transaction)) = result {
                print("product =", product)
                print("transaction =", transaction)
                // TODO: process the transaction here
                dismiss()
            }
            isPurchasing = false
        }

        .subscriptionStatusTask(for: "subscriptions") { taskState in
            // TODO: Can you use this to avoid showing purchase options
            // TODO: to users that have already purchased one of them?
            print("taskState =", taskState)
        }

        .currentEntitlementTask(
            for: "r.mark.volkmann.gmail.com.StoreKitDemo"
        ) { state in
            // An enum value in the state object can have the values
            // loading, failure(any Error), or success(Entitlement).
            print("state =", state)
        }
    }
}

#Preview {
    ContentView()
}
