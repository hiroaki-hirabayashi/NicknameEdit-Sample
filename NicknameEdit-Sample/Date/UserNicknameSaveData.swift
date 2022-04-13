//
//  UserNicknameSaveData.swift
//  NicknameEdit-Sample
//
//  Created by Hiroaki-Hirabayashi on 2022/04/14.
//

import Foundation

/// ニックネーム保存
public struct UserNicknameSaveData {
    /// ニックネーム
    public var nickname: String
    /// アバター
    public var avatar: String
    
    /// init
    /// - Parameters:
    ///   - nickname: ニックネーム
    ///   - avatar: アバター
    public init(nickname: String, avatar: String) {
        self.nickname = nickname
        self.avatar = avatar
    }
}

///// 目標歩数保存
//public struct UserStepGoalSaveData {
//    /// 目標歩数
//    public var stepGoal: StepGoal
//
//    /// init
//    /// - Parameter stepGoal: 目標歩数
//    public init(stepGoal: StepGoal) {
//        self.stepGoal = stepGoal
//}
//}
