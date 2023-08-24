import Foundation

final class DetailViewModel {
    var detail: Detail? = nil
    
    var service: AdvertisementServiceProtocol = AdvertisementService.advertisementService
    
    
    func fetchDetailInfo(detailId: String) {
        service.fetchDetailAdvertisement(id: detailId) { result in
            switch result {
            case .success(let data):
                self.detail = data
            case .failure(let error):
                print(error)
            }
        }
    }
}
