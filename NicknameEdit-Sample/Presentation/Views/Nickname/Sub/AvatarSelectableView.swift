//
//  AvatarSelectableView.swift
//  NicknameEdit-Sample
//
//  Created by Hiroaki-Hirabayashi on 2022/04/14.
//

import SwiftUI

/// 選択用アバター表示
struct AvatarSelectableView: View {
    let avatar: AvatarModel
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            AsyncImageDownloader(
                url: avatar.url,
                type: .assets,
                placeholderImage: "mypage_avatar_notfound"
            )
            .scaledToFit()
            .clipShape(Circle())
            .modifier(SelectedModifier(condition: selected))
        }
    }

    // 選択中表示
    struct SelectedModifier: ViewModifier {
        let condition: Bool

        func body(content: Content) -> some View {
            if condition {
                content
                    .overlay(
                        ZStack {
                            Circle().strokeBorder(.yellow, lineWidth: 4)
                            Image("nickname_check")
                                .resizable()
                                .frame(width: 28, height: 28)
                                .offset(x: -37, y: -35)
                        }
                    )
            } else {
                content
            }
        }
    }
}

extension AvatarSelectableView {
    init(_ avatar: AvatarModel) {
        self.init(
            avatar: avatar,
            selected: false,
            action: {}
        )
    }
}

struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarSelectableView(
            avatar: AvatarModel("http://localhost/"),
            selected: true,
            action: {}
        )
        .previewLayout(.fixed(width: 105, height: 105))

        // download
        AvatarSelectableView(AvatarModel("https://dummyimage.com/150x150/000/fff"))
            .previewLayout(.fixed(width: 105, height: 105))

        // scale
        AvatarSelectableView(AvatarModel("http://localhost/"))
            .previewLayout(.fixed(width: 60, height: 60))

        // scale
        AvatarSelectableView(AvatarModel("http://localhost/"))
            .previewLayout(.fixed(width: 200, height: 200))
    }
}
