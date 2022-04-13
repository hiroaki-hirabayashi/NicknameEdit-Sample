//
//  AvatarPageView.swift
//  NicknameEdit-Sample
//
//  Created by Hiroaki-Hirabayashi on 2022/04/14.
//

import SwiftUI

/// アバターリストのページ表示
///
/// ページ表示（TabViewのpagestyle）とコレクション表示（LazyVGrid）
/// で表示しています。
struct AvatarPageView: View {
    /// ページに表示するGrid指定
    let collectionColumns: [GridItem]
    
    @ObservedObject private var viewModel: NicknameEditViewModel
    @State private var page: Int
    
    init(
        viewModel: NicknameEditViewModel,
        collectionColumns: [GridItem]
    ) {
        self.viewModel = viewModel
        self.collectionColumns = collectionColumns
        self.page = viewModel.selectionPage
    }
    
    var body: some View {
        AvatarCollectionView(
            columns: collectionColumns,
            avatars: viewModel.avatars,
            selection: $viewModel.selection,
            edited: $viewModel.edited
        )
    }
}

/// アバターリストのページ内表示
struct AvatarCollectionView: View {
    var columns: [GridItem]
    var avatars: [AvatarModel]
    @Binding var selection: AvatarModel?
    /// アバターを選択したか
    @Binding var edited: Bool
    
    var body: some View {
        VStack {
            // ここのspacingは縦
            LazyVGrid(columns: columns, alignment: .center, spacing: 16) {
                ForEach(avatars, id: \.self) { avatar in
                    AvatarSelectableView(
                        avatar: avatar,
                        selected: avatar == selection,
                        action: {
                            if selection != avatar {
                                edited = true
                            }
                            selection = avatar
                        }
                    )
                }
            }
            // itemが足りないときに上詰めするため
            Spacer()
        }
    }
}

struct AvatarPageView_Previews: PreviewProvider {
    static var previews: some View {
        let item = GridItem(.flexible(minimum: 60, maximum: 105))
        let columns = Array(repeating: item, count: 3)
        ZStack {
            Color.secondary
            AvatarPageView(
                viewModel: NicknameEditViewModel(numberPerPage: 9),
                collectionColumns: columns
            )
        }
        .previewLayout(.fixed(width: 200, height: 300))
        
        ZStack {
            Color.secondary
            AvatarPageView(
                viewModel: NicknameEditViewModel(numberPerPage: 9),
                collectionColumns: columns
            )
        }
    }
}
