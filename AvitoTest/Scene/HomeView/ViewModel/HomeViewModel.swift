import Foundation

private protocol HomeViewModelProtocol {
    var viewState: Observable<ViewState> { get }
    var advertisements: Observable<[Advertisement]> { get }
    
    func fetchAdvertisements()
}

final class HomeViewModel: HomeViewModelProtocol {
    private let service: AdvertisementServiceProtocol
    var advertisements: Observable<[Advertisement]> = Observable([])
    var viewState: Observable<ViewState> = Observable(ViewState.none)
    
    init(service: AdvertisementServiceProtocol) {
        self.service = service
    }
    
    func fetchAdvertisements() {
        viewState.value = .loading
        
        service.fetchAdvertisements { result in
            switch result {
            case .success(let data):
                self.advertisements.value = data.advertisements
                self.viewState.value = .loaded
            case .failure(let error):
                self.viewState.value = .error(message: error.localizedDescription)
            }
        }
    }
}

