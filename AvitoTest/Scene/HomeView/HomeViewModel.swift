import Foundation

final class HomeViewModel {
    private let service: AdvertisementServiceProtocol
    
    init(service: AdvertisementServiceProtocol) {
        self.service = service
        fetchAdvertisements()
    }
    
    var advertisements: Observable<[Advertisement]> = Observable([])
    
    func fetchAdvertisements() {
        service.fetchAdvertisements { result in
            switch result {
            case .success(let data):
                self.advertisements.value = data.advertisements
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchDetail() {
        service.fetchDetailAdvertisement { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
