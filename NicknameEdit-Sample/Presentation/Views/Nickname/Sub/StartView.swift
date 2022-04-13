//
//  StartView.swift
//  NicknameEdit-Sample
//
//  Created by Hiroaki-Hirabayashi on 2022/04/14.
//

import SwiftUI

struct StartView: View {
    @State var isNicknameEditActive = false
    var body: some View {
        Button {
            self.isNicknameEditActive = true
        } label: {
            Text("Start")
                .font(.system(size: 32))
        }
        .sheet(isPresented: $isNicknameEditActive) {
            // データ更新いれる?
        } content: {
            NicknameEditView(isModalTransition: $isNicknameEditActive)
                // モーダルの下スワイプ無効
                .interactiveDismiss(canDismissSheet: false) {
                }
        }

    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
