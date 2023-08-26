import UIKit

class HomeViewController: UIViewController {
    typealias ViewModel = HomeViewModel
    
    private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        self.viewModel.fetchAdvertisements()
        super.init(nibName: nil, bundle: nil)
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.id)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.advertisements.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.id, for: indexPath) as! HomeCollectionViewCell
        
        guard let item = viewModel.advertisements.value?[indexPath.row] else { return cell }
        cell.configure(with: item)
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.width - 30) / 2
        return CGSize(width: cellWidth, height: 250)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = viewModel.advertisements.value?[indexPath.row] else { return }
        let service = AdvertisementService()
        let detailViewController = DetailViewController(service: service, detailId: item.id)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

//MARK: PRIVATE METHODS

private extension HomeViewController {
    func setUp() {
        self.view.backgroundColor = .white
        self.view.addSubview(collectionView)
        
        setUpConstraints()
        
        observeAdvertisements()
        
        observeViewState()
    }
    
    private func observeViewState() {
        viewModel.viewState.bind { [weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .loading:
                self.showActivityIndicator()
            case .loaded:
                break
            case .error(let error):
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    self.presentErrorAlert(message: error, retryHandler: {
                        self.viewModel.fetchAdvertisements()
                    })
                }
            case nil: break
            case .some(.none): break
            }
        }
    }
    
    private func observeAdvertisements() {
        viewModel.advertisements.bind { [weak self] _ in
            guard let self = self else { return }
            
            if self.viewModel.advertisements.value?.isEmpty == false {
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func showActivityIndicator() {
        spinner = UIActivityIndicatorView(style: .large)
        spinner.center = self.view.center
        self.view.addSubview(spinner)
        spinner.startAnimating()
    }
    
    private func hideActivityIndicator(){
        spinner.stopAnimating()
    }
}

extension UIViewController {
    func presentErrorAlert(message: String, retryHandler: (() -> Void)?) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        if let retryHandler = retryHandler {
            let refresh = UIAlertAction(title: "Повторить", style: .default, handler: { _ in
                retryHandler()
            })
            alertController.addAction(refresh)
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
