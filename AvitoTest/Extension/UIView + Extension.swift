//
//  UIView + Extension.swift
//  AvitoTest
//
//  Created by Шарап Бамматов on 26.08.2023.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
