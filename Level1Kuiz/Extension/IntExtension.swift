//
//  IntExtension.swift
//  Level1Kuiz
//
//  Created by 백은주 on 2022/12/03.
//

import Foundation

extension Int {
    init(_ bool: Bool) {
        self = bool ? 1 : 0
    }
}
