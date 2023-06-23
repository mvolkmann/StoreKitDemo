import StoreKit

class StoreKitStore: NSObject, ObservableObject {
    // This is a Set of purchasable product ids.
    private var allProductIdentifiers =
        Set(["r.mark.volkmann.gmail.com.StoreKitDemo"])

    private var productsRequest: SKProductsRequest?

    private var fetchedProducts: [SKProduct] = []

    typealias CompletionHandler = ([SKProduct]) -> Void

    private var completionHandler: CompletionHandler?

    override init() {
        super.init()
        fetchProducts { products in
            print("products =", products)
        }
    }

    private func fetchProducts(
        _ completion: @escaping CompletionHandler
    ) {
        guard productsRequest == nil else { return }
        completionHandler = completion
        productsRequest =
            SKProductsRequest(productIdentifiers: allProductIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }
}

extension StoreKitStore: SKProductsRequestDelegate {
    func productsRequest(
        _ request: SKProductsRequest,
        didReceive response: SKProductsResponse
    ) {
        let loadedProducts = response.products
        let invalidProducts = response.invalidProductIdentifiers
        guard !loadedProducts.isEmpty else {
            print("failed to load products")
            if !invalidProducts.isEmpty {
                print("invalid products found: \(invalidProducts)")
            }
            productsRequest = nil
            return
        }

        // Cache the fetched products.
        fetchedProducts = loadedProducts

        // Notify listeners of loaded products.
        DispatchQueue.main.async {
            self.completionHandler?(loadedProducts)
            self.completionHandler = nil
            self.productsRequest = nil
        }
    }
}
