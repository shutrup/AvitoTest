//
//  MainViewModel.swift
//  AvitoTest
//
//  Created by Шарап Бамматов on 17.10.2022.
//

import Foundation

protocol MainViewModelProtocol {
    var employees: [Employee] { get set }
    func getSavedEmployees() -> [Employee]
    func fetchData(completion: @escaping () -> ())
    func alphabeticalSorting(_ data: [Employee]) -> [Employee]
    func deleteSavedEmployees()
}

final class MainViewModel: MainViewModelProtocol {
    let employeesKey: String = "employees"
    var employees: [Employee] = [] {
        didSet {
            saveEmployees()
        }
    }
    
    var networkService: NetworkServiceProtocol!
    var mainVC: MainVC
    
    init() {
        self.networkService = NetworkService()
        self.mainVC = MainVC()
    }
    
    func fetchData(completion: @escaping () -> ()) {
        networkService.getTrendingMovies { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.employees = data
                    completion()
                case .failure(let error):
                    print(error)
                }
            }
            self.deleteSavedEmployees()
        }
    }
    
    func saveEmployees() {
        if let encodedData = try? JSONEncoder().encode(employees) {
            UserDefaults.standard.set(encodedData, forKey:  employeesKey)
        }
    }
    
    func getSavedEmployees() -> [Employee] {
        guard
            let data = UserDefaults.standard.data(forKey: employeesKey),
            let savedItems = try? JSONDecoder().decode([Employee].self, from: data)
        else {return [Employee(name: "", phoneNumber: "", skills: [""])]}
    
        return savedItems
    }
    
    func deleteSavedEmployees() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 3600.0) {
            dictionary.keys.forEach { key in
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    func alphabeticalSorting(_ data: [Employee]) -> [Employee] {
        let sortedArray = data.sorted(by: { (name1, name2) -> Bool in
            let Obj1_Name = name1.name
            let Obj2_Name = name2.name
            return (Obj1_Name.localizedCaseInsensitiveCompare(Obj2_Name) == .orderedAscending)
         })
        return sortedArray
    }
}
