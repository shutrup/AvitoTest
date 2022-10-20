//
//  Company.swift
//  AvitoTest
//
//  Created by Шарап Бамматов on 17.10.2022.
//

import Foundation

struct CompanyResponse: Codable {
    let company: Company
}

struct Company: Codable {
    let name: String
    let employees: [Employee]
}

struct Employee: Codable {
    let name, phoneNumber: String
    let skills: [String]

    enum CodingKeys: String, CodingKey {
        case name
        case phoneNumber = "phone_number"
        case skills
    }
}

