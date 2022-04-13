//
//  NicknameTextField.swift
//  NicknameEdit-Sample
//
//  Created by Hiroaki-Hirabayashi on 2022/04/14.
//

import SwiftUI

/// ニックネーム編集フィールド
struct NicknameTextField: View {
    let label: String
    let placeholder: String
    let keyboardType: UIKeyboardType
    @ObservedObject var viewModel: NicknameEditViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 18).bold())
                .foregroundColor(.black)
            
            TextField(placeholder, text: $viewModel.nickname)
                .keyboardType(.default)
                .autocapitalization(.none)
                .padding(.vertical, 12)
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 44)
                .foregroundColor(.black)
                .background(.gray)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            viewModel.isOver
                            ? .red : .secondary,
                            lineWidth: 1
                        )
                )
                .onChange(
                    of: viewModel.nickname,
                    perform: { newValue in
                        viewModel.checkTextCount(inputText: newValue)
                        viewModel.edited = true
                    }
                )
            HStack(spacing: 0) {
                Spacer()
                Text(viewModel.countMessage)
                    .font(.system(size: 18))
                    .foregroundColor(
                        viewModel.isOver
                        ? .red
                        : .black
                    )
            }
        }
    }
}

extension NicknameTextField {
    static func nickname(
        viewModel: NicknameEditViewModel
    ) -> NicknameTextField {
        NicknameTextField(
            label: "ニックネーム",
            placeholder: "入力してください",
            keyboardType: .default,
            viewModel: viewModel
        )
    }
}

struct NicknameTextField_Previews: PreviewProvider {
    static var previews: some View {
        let background = Color.secondary
        ZStack {
            background
            NicknameTextField.nickname(
                viewModel: NicknameEditViewModel(numberPerPage: 1)
            )
        }
        .previewLayout(.fixed(width: 400, height: 120))
        
        // placeholderの表示
        ZStack {
            background
            NicknameTextField(
                label: "ニックネーム",
                placeholder: "ニックネームを入力してください。",
                keyboardType: .default,
                viewModel: NicknameEditViewModel(numberPerPage: 1)
            )
        }
        .previewLayout(.fixed(width: 400, height: 120))
        
        // placeholder 空白
        ZStack {
            background
            NicknameTextField(
                label: "ニックネーム",
                placeholder: "",
                keyboardType: .default,
                viewModel: NicknameEditViewModel(numberPerPage: 1)
            )
        }
        .previewLayout(.fixed(width: 400, height: 120))
    }
}
