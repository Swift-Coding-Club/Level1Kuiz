//
//  ResultModel.swift
//  Level1Kuiz
//
//  Created by 백은주 on 2022/11/12.
//

import Foundation

// enum Rank: String {
//    case newbie = "맞춤법 더듬이"
//    case normal = "일반인"
//    case pro = "맞춤법 변태"
//    case master = "맞춤법 달인"
//    case expert = "국립국어원 직원"
// }

enum Rank {
    case newbie
    case normal
    case pro
    case master
    case expert

    init(score: Int) {
        switch score {
        case 0..<10:
            self = .newbie
        case 10..<20:
            self = .normal
        case 20..<30:
            self = .pro
        case 30..<40:
            self = .master
        default:
            self = .expert
        }
    }

    var rawValue: String {
        switch self {
        case .newbie:
            return "맞춤법 더듬이"
        case .normal:
            return "일반인"
        case .pro:
            return "맞춤법 변태"
        case .master:
            return "맞춤법 달인"
        case .expert:
            return "국립국어원 직원"
        }
    }

    func getRemainScore(score: Int) -> Int {
        switch self {
        case .newbie:
            return 10 - score
        case .normal:
            return 20 - score
        case .pro:
            return 30 - score
        case .master:
            return 40 - score
        case .expert:
            return 40
        }
    }

    func getRankByScore(with score: Int) -> Rank {
        if score >= 40 {
            return Rank.expert
        } else if score >= 30 {
            return Rank.master
        } else if score >= 20 {
            return Rank.pro
        } else if score >= 10 {
            return Rank.normal
        } else {
            return Rank.newbie
        }
    }
}
