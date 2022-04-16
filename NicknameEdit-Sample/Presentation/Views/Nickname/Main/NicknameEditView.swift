//
//  NicknameEditView.swift
//  NicknameEdit-Sample
//
//  Created by Hiroaki-Hirabayashi on 2022/04/14.
//

import SwiftUI

/// ニックネーム変更
struct NicknameEditView: View {
    @StateObject var nicknameViewModel = NicknameEditViewModel(
        numberPerPage: Self.numberPerPage
    )
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    @State private var isShowAlert = false
    @State private var isShowActionSheet = false
    @Binding var isModalTransition: Bool
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(spacing: 16) {
                        Text("ニックネームとプロフィール画像は、フィットネスのレッスン中に表示されます。")
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                            .fixedSize(horizontal: false, vertical: true)
                        NicknameTextField.nickname(
                            viewModel: nicknameViewModel
                        )
                        HStack {
                            Text("プロフィール画像")
                                .font(.system(size: 18).bold())
                                .foregroundColor(.black)
                            Spacer()
                        }
                        Spacer()
                            .frame(height: 12)
                        AvatarPageView(
                            viewModel: nicknameViewModel,
                            collectionColumns: Self.collectionColumns
                        )
                            .frame(height: Self.avatarListHeight)
                    }
                    .padding(.top, 24)
                    .padding(.horizontal, 16)
                    Spacer()
                }
                Divider()
                VStack {
                    Button {
                        nicknameViewModel.sendNickname { error in
                            if error == nil {
                                closeView()
                            } else {
                                // TODO: エラー処理
                                // TODO: - NGワードだったらアラート表示
                                self.isShowAlert = true
                            }
                        }
                    } label: {
                        Text("保存")
                            .font(.system(size: 18).bold())
                    }
                    .disabled(!nicknameViewModel.edited)
                    .frame(height: 48)

                }
                .padding(.horizontal, 16)
            }
            .alert(isPresented: $isShowAlert) {
                banWordAlert()
            }
            .actionSheet(isPresented: $isShowActionSheet) {
                showActionSheet()
            }
            .onDisappear {
                nicknameViewModel.edited = false
            }
            .navigationTitle("プロフィール編集")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        if nicknameViewModel.edited {
                            self.isShowActionSheet = true
                        } else {
                            closeView()
                        }
                    } label: {
                        Text("キャンセル")
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
    
    // MARK: - function
    /// アクションシート表示
    private func showActionSheet() -> ActionSheet {
        ActionSheet(
            title: Text("変更内容を破棄しますか？"),
            buttons: [
                .destructive(
                    Text("変更内容を破棄"),
                    action: {
                        // 編集前のアバターに戻す
                        nicknameViewModel.resetSelection()
                        closeView()
                    }
                ),
                .cancel(Text("キャンセル"), action: {}),
            ]
        )
    }
    
    /// NGワードアラート表示
    private func banWordAlert() -> Alert {
        Alert(
            title: Text("ニックネームに使用できない文字が含まれています"),
            message: Text("ニックネームに使用できない文字や表現が含まれています。異なる内容で再度入力してください。")
        )
    }
    
    private func closeView() {
        // 以下の理由によりviewControllerでdissmissする
        // * モーダルの下スワイプ無効の兼ね合いでiOS14.5だとpresentationModeが効かない
        // * fullScreenCoverとsheetが重なると通常のdismissアニメーションが効かない
        viewControllerHolder?.dismiss(animated: true)
    }
}

// MARK: - extension
/// アバターページ表示の表示設定
extension NicknameEditView {
    static let avatarSize: CGFloat = 103
    static let avatarHCount = 3
    static let avatarVCount = 3
    
    // アバターページ高さ設定
    static var avatarListHeight: CGFloat {
        let margin = 16
        let pageIndicatorHeight = 12
        return avatarSize * CGFloat(avatarVCount)
        + CGFloat(margin * (avatarVCount + 1) + pageIndicatorHeight)
    }
    
    static var numberPerPage: Int {
        avatarHCount * avatarVCount
    }
    
    static var collectionColumns: [GridItem] {
        // ここのspacingは横
        let item = GridItem(.flexible(minimum: 60, maximum: avatarSize), spacing: 16)
        return Array(repeating: item, count: avatarHCount)
    }
}

struct NicknameEditView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NicknameEditView(isModalTransition: .constant(false))
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
