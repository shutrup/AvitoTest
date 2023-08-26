import Foundation

private protocol DetailViewModelProtocol {
    func fetchDetailInfo()
}

final class DetailViewModel: DetailViewModelProtocol {
    private let service: AdvertisementServiceProtocol
    private(set) var detail: Detail?
    private var detailId: String = ""
    
    var viewState: Observable<ViewState> = Observable(Optional.none)
    
    init(service: AdvertisementServiceProtocol, detailId: String) {
        self.service = service
        self.detailId = detailId
    }
    
    func fetchDetailInfo() {
        viewState.value = .loading
        service.fetchDetailAdvertisement(id: detailId) { result in
            switch result {
            case .success(let data):
                self.detail = data
                self.viewState.value = .loaded
            case .failure(let error):
                self.viewState.value = .error(message: error.localizedDescription)
            }
        }
    }
}
