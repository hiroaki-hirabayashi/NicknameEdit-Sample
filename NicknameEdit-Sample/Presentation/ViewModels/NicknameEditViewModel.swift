//
//  NicknameEditViewModel.swift
//  NicknameEdit-Sample
//
//  Created by Hiroaki-Hirabayashi on 2022/04/14.
//

import Combine
import SwiftUI

final class NicknameEditViewModel: ObservableObject {
    @Published var nickname: String = ""
    @Published var isNicknameTextCountValidation = false
    /// 最大入力文字数
    static let maxCharacterLength: Int = 7
    @Published var avatars: [AvatarModel] = []
    @Published var selection: AvatarModel?
    @Published var edited: Bool = false
    @Published var isOver: Bool = false
    @Published var countMessage: String = String.localizedStringWithFormat(
        "残り%d文字", NicknameEditViewModel.maxCharacterLength
    )
    /// 1ページあたりの表示数
    let numberPerPage: Int
    
    /// 編集前の選択アバター
    private var previousSelection: AvatarModel?
//    private let userAttributeUseCase = DIContainer.commonContainer.getUserAttributeUseCase()
    
    init(numberPerPage: Int) {
        self.numberPerPage = numberPerPage
        self.avatars = AvatarModel.getTestAvatars()  // TODO: avatar list の取得
        fetchUserAttribute()
    }
    
    /// ニックネーム文字数チェック
    func checkTextCount(inputText: String) {
        // 入力文字が0 → ボタン活性 / 残り文字色 黒 ニックネームなし可にする為
        if nickname.isEmpty {
            isOver = false
            countMessage = String.localizedStringWithFormat("残り%d文字", NicknameEditViewModel.maxCharacterLength - nickname.count)
            // 入力文字が7文字以上 → ボタン非活性 / 残り文字色 赤
        } else if NicknameEditViewModel.maxCharacterLength < nickname.count {
            isOver = true
            countMessage = String.localizedStringWithFormat("%d文字", NicknameEditViewModel.maxCharacterLength - nickname.count)
            // 入力文字が7文字以内 → ボタン活性 / 残り文字色 黒
        } else {
            isOver = false
            countMessage = String.localizedStringWithFormat(
                "残り%d文字", NicknameEditViewModel.maxCharacterLength - nickname.count
            )
        }
    }
    
    /// Nickname送信
    func sendNickname(completed: @escaping (Error?) -> Void) {
        let mapper = NickNameEditViewModelMapper()
        let saveData = mapper.viewModelToDomain(
            model: (
                nickname: nickname,
                avatar: selection
            )
        )
        
//        userAttributeUseCase.saveNickname(nickname: saveData) { error in
//            ThreadUtils.runInMainThread {
//                completed(error)
//            }
//        }
    }
    
    /// ユーザー情報取得
    private func fetchUserAttribute() {
//        userAttributeUseCase.getUserAttribute { [weak self] result, error in
//            guard let self = self else { return }
//            
//            ThreadUtils.runInMainThread {
//                if error == nil {
//                    let mapper = AvatarViewModelMapper()
//                    let avatarModel = mapper.domainToViewModel(domain: result.avatar)
//                    self.nickname = result.nickname
//                    self.selection = avatarModel
//                    self.checkTextCount(inputText: self.nickname)
//                } else {
//                    // TODO: エラー処理
//                }
//            }
//        }
    }
}

// MARK: Avatar
extension NicknameEditViewModel {
    /// 対象ページのRange
    func pageRange(_ page: Int) -> Range<Int> {
        let start = page * numberPerPage
        var end = start + numberPerPage
        if end > avatars.count {
            end = avatars.count
        }
        return start..<end
    }
    
    /// ページ数
    var pageCount: Int {
        Int(ceil(Double(avatars.count / numberPerPage)))
    }
    
    /// 選択中のページ
    var selectionPage: Int {
        if let index = findAvatarIndex(selection) {
            return Int(floor(Double(index / numberPerPage)))
        } else {
            return 0
        }
    }
    
    func resetSelection() {
        selection = previousSelection
    }
    
    /// 対象アバターのIndex
    private func findAvatarIndex(_ avatar: AvatarModel?) -> Int? {
        avatars.firstIndex { $0 == avatar }
    }
}

#if DEBUG
extension NicknameEditViewModel {
    private func createTestData() {
        let avatars = AvatarModel.getTestAvatars()
        let selectIndex = 10
        let selection = avatars[selectIndex]
        self.avatars = avatars
        self.selection = selection
        self.previousSelection = selection
    }
}
#endif
