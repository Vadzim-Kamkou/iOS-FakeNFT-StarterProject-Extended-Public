import Foundation

@Observable
@MainActor
final class ServicesAssembly {
    
    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let paymentStorage: PaymentStorage
    private let cartStorage: CartStorage
    
    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        paymentStorage: PaymentStorage,
        cartStorage: CartStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.paymentStorage = paymentStorage
        self.cartStorage = cartStorage
    }
    
    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
    
    var paymentService: PaymentServices {
        PaymentServices(networkClient: networkClient,
                        storage: paymentStorage)
    }
    
    var cartService: CartServiceImpl {
        CartServiceImpl(networkClient: networkClient, storage: cartStorage)
    }
    
    var collectionService: CollectionService {
        CollectionServiceImpl(networkClient: networkClient)
    }
    
    var profileService: ProfileService {
        ProfileServiceImpl(networkClient: networkClient)
    }
}

// MARK: Preview Helpers
extension ServicesAssembly {
    static var preview: ServicesAssembly {
        let networkClient = DefaultNetworkClient()
        let nftStorage = NftStorageImpl()
        let paymentStorage = PaymentStorageImpl()
        let cartStorage = CartStorageImpl()
        
        return ServicesAssembly(
            networkClient: networkClient,
            nftStorage: nftStorage,
            paymentStorage: paymentStorage,
            cartStorage: cartStorage
        )
    }
}
