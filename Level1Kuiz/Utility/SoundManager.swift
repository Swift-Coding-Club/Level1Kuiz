//
//  SoundManager.swift
//  Level1Kuiz
//
//  Created by Claude on 2025/11/24.
//

import AVFoundation
import UIKit

class SoundManager {
    static let shared = SoundManager()

    private init() {}

    func playCorrectSound() {
        guard UserDataManager.shared.soundEnabled else { return }
        // 시스템 사운드 사용 (성공 소리)
        AudioServicesPlaySystemSound(1004)
    }

    func playWrongSound() {
        guard UserDataManager.shared.soundEnabled else { return }
        // 시스템 사운드 사용 (오류 소리)
        AudioServicesPlaySystemSound(1053)
    }

    func playComboSound() {
        guard UserDataManager.shared.soundEnabled else { return }
        // 시스템 사운드 사용 (알림 소리)
        AudioServicesPlaySystemSound(1054)
    }

    func playLevelUpSound() {
        guard UserDataManager.shared.soundEnabled else { return }
        // 시스템 사운드 사용 (성취 소리)
        AudioServicesPlaySystemSound(1075)
    }

    func playButtonTapSound() {
        guard UserDataManager.shared.soundEnabled else { return }
        // 햅틱 피드백
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    func playTimeWarningSound() {
        guard UserDataManager.shared.soundEnabled else { return }
        // 경고 햅틱
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }

    func playGameOverSound() {
        guard UserDataManager.shared.soundEnabled else { return }
        // 시스템 사운드 사용 (실패 소리)
        AudioServicesPlaySystemSound(1006)
    }
}
