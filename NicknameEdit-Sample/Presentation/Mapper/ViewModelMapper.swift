//
//  ViewModelMapper.swift
//  NicknameEdit-Sample
//
//  Created by Hiroaki-Hirabayashi on 2022/04/14.
//

protocol ViewModelMapper {
    associatedtype DomainType: Any
    associatedtype ViewModelType: Any
    
    func domainToViewModel(domain: DomainType) -> ViewModelType
    func viewModelToDomain(model: ViewModelType) -> DomainType
}
