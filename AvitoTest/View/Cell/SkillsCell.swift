//
//  SkillsCell.swift
//  AvitoTest
//
//  Created by Шарап Бамматов on 18.10.2022.
//

import UIKit
import SnapKit

class SkillsCell: UICollectionViewCell {
    static let id = "SkillsCell"
    
    var skillLabel: UILabel = {
        let label = UILabel()
        label.text = "IOS"
        label.font = UIFont(name: "TimesNewRomanPSMT", size: 16)
        label.textColor = UIColor(hexString: "#516FD4")
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(skillLabel)
        
        skillLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
