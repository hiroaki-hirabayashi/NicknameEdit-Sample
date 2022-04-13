//
//  NickNameEditViewModelMapper.swift
//  NicknameEdit-Sample
//
//  Created by Hiroaki-Hirabayashi on 2022/04/14.
//

import Foundation

final class NickNameEditViewModelMapper: ViewModelMapper {
    typealias NicknameEditModel = (nickname: String, avatar: AvatarModel?)
    typealias DomainType = UserNicknameSaveData
    typealias ViewModelType = NicknameEditModel
    private let avatarMapper = AvatarViewModelMapper()

    @available(*, deprecated, message: "利用想定無し")
    func domainToViewModel(domain: UserNicknameSaveData) -> NicknameEditModel {
        return ("", nil)
    }

    func viewModelToDomain(model: NicknameEditModel) -> UserNicknameSaveData {
        let avatar: String
        if let avatarModel = model.avatar {
            avatar = avatarMapper.viewModelToDomain(model: avatarModel)
        } else {
            // TODO: 未選択はあるか
            avatar = ""
        }
        return UserNicknameSaveData(
            nickname: model.nickname,
            avatar: avatar
        )
    }
}
