//
//  EmployeesCell.swift
//  AvitoTest
//
//  Created by Шарап Бамматов on 18.10.2022.
//

import UIKit

class EmployeesCell: UICollectionViewCell {
    static let id = "EmployeesCell"
    private var skills: [String] = []
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "name"
        label.font = UIFont(name: "TimesNewRomanPS-BoldMT", size: 22)
        label.textColor = UIColor(hexString: "#151B32")
        return label
    }()
    
    var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "phone"
        label.font = UIFont(name: "TimesNewRomanPSMT", size: 18)
        label.textColor = UIColor(hexString: "#151B32")
        return label
    }()
    
    let skillsCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(SkillsCell.self, forCellWithReuseIdentifier: SkillsCell.id)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        initView()
        initDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        contentView.backgroundColor = .white
        contentView.addSubview(nameLabel)
        contentView.addSubview(phoneNumberLabel)
        contentView.addSubview(skillsCollectionView)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }
        
        phoneNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(16)
        }
        
        skillsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberLabel).offset(25)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(22)
        }
    }
    
    private func initDelegate() {
        skillsCollectionView.delegate = self
        skillsCollectionView.dataSource = self
    }
    
    func configure(data: Employee) {
        nameLabel.text = data.name
        phoneNumberLabel.text = data.phoneNumber
        skills = data.skills
    }
}

extension EmployeesCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90.0, height: 22.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return skills.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SkillsCell.id, for: indexPath) as! SkillsCell
        
        cell.skillLabel.text = skills[indexPath.row]
        return cell
    }
}
