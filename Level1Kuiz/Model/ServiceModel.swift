//
//  Service.swift
//  Level1Kuiz
//
//  Created by 백은주 on 2022/10/03.
//

import Foundation

struct Response<T: Decodable>: Decodable {
    let status: Int
    let data: T
}
