import Foundation

final class DetailViewModel {
    var detail: Detail? = nil
    var service: AdvertisementServiceProtocol = AdvertisementService.advertisementService
    var viewState: Observable<ViewState> = Observable(ViewState.none)
    
    init(detailId: String) {
       fetchDetailInfo(detailId: detailId)
    } 
    
    func fetchDetailInfo(detailId: String) {
        viewState.value = .loading
        service.fetchDetailAdvertisement(id: detailId) { result in
            switch result {
            case .success(let data):
                self.detail = data
                self.viewState.value = .loaded
            case .failure:
                self.viewState.value = .error
            }
        }
    }
}
