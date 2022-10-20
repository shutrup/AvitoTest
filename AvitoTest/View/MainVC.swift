//
//  MainVC.swift
//  AvitoTest
//
//  Created by Шарап Бамматов on 17.10.2022.
//

import UIKit
import SnapKit

class MainVC: UIViewController {
    
    let employeesCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(EmployeesCell.self, forCellWithReuseIdentifier: EmployeesCell.id)
        return collectionView
    }()
    
    private var viewModel: MainViewModelProtocol!
    
    override func viewDidLoad() {
        viewModel = MainViewModel()
        isCheckedInternet()
        super.viewDidLoad()
        initView()
        initDelegate()
    }
    
    func initView() {
        title = "Employees"
        view.backgroundColor = .white
        view.addSubview(employeesCollectionView)
        
        employeesCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(view.frame.height)
        }
    }
    
    func initDelegate() {
        employeesCollectionView.delegate = self
        employeesCollectionView.dataSource = self
    }
    
    func fetchData() {
        viewModel.fetchData { [weak self] in
            guard let self = self else { return }
            self.employeesCollectionView.reloadData()
        }
    }
    
    func isCheckedInternet() {
        if NetworkMonitor.shared.isConnected {
            fetchData()
        } else {
            showAlert()
            viewModel.deleteSavedEmployees()
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Connection problems!!", message: "you don't have internet connection", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Reconnect", style: .default, handler: { [weak self] action in
            guard let self = self else {return}
            self.viewDidLoad()
        }))
        alert.addAction(UIAlertAction(title: "Offline", style: .cancel))
        
        present(alert, animated: true)
    }
}

extension MainVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if NetworkMonitor.shared.isConnected {
            return viewModel.employees.count
        } else {
            return viewModel.getSavedEmployees().count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmployeesCell.id, for: indexPath) as! EmployeesCell
        
        if NetworkMonitor.shared.isConnected {
            let data = viewModel.alphabeticalSorting(viewModel.employees)[indexPath.row]
            cell.configure(data: data)
        } else {
            let data = viewModel.alphabeticalSorting(viewModel.getSavedEmployees())[indexPath.row]
            cell.configure(data: data)
        }
        
        return cell
    }
}

