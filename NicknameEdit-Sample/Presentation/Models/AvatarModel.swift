//
//  AvatarModel.swift
//  NicknameEdit-Sample
//
//  Created by Hiroaki-Hirabayashi on 2022/04/14.
//

import SwiftUI

/// Avatarモデル
struct AvatarModel: Hashable {
    let id: String
    let url: String
}

// 仮実装
#if DEBUG
    extension AvatarModel {
        static var manageNum = 0
        init(_ url: String) {
            self.url = url
            Self.manageNum += 1
            self.id = String(Self.manageNum)
        }
        
        // アバター選択を9つ表示する
        static func getTestAvatars() -> [AvatarModel] {
            var avatars: [AvatarModel] = []
            for _ in 0..<9 {
                avatars.append(AvatarModel(""))
            }
            avatars.shuffle()
            return avatars
        }
    }
#endif
