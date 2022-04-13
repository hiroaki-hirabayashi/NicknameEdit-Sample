//
//  AvatarViewModelMapper.swift
//  NicknameEdit-Sample
//
//  Created by Hiroaki-Hirabayashi on 2022/04/14.
//

import Foundation

final class AvatarViewModelMapper: ViewModelMapper {
    typealias DomainType = String  // TODO: Stirng or Avatar struct
    typealias ViewModelType = AvatarModel

    func domainToViewModel(domain: String) -> AvatarModel {
        // TODO: 仮
        return AvatarModel(
            id: domain,
            url: domain
        )
    }

    func viewModelToDomain(model: AvatarModel) -> String {
        // TODO: 仮
        return model.id
    }
}
