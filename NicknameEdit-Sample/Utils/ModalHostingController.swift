//
//  ModalHostingController.swift
//  NicknameEdit-Sample
//
//  Created by Hiroaki-Hirabayashi on 2022/04/14.
//

import SwiftUI

/// モーダルを制御する
class ModalHostingController<Content: View>: UIHostingController<Content>,
                                             UIAdaptivePresentationControllerDelegate {
    var canDismissSheet = true
    var onDismissalAttempt: (() -> Void)?
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        
        parent?.presentationController?.delegate = self
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController)
    -> Bool {
        canDismissSheet
    }
    
    func presentationControllerDidAttemptToDismiss(
        _ presentationController: UIPresentationController
    ) {
        onDismissalAttempt?()
    }
}

struct ModalView<T: View>: UIViewControllerRepresentable {
    let view: T
    let canDismissSheet: Bool
    let onDismissalAttempt: (() -> Void)?
    
    func makeUIViewController(context: Context) -> ModalHostingController<AnyView> {
        let controller = ModalHostingController(rootView: AnyView(EmptyView()))
        controller.rootView = AnyView(view.environment(\.viewController, controller))
        
        controller.canDismissSheet = canDismissSheet
        controller.onDismissalAttempt = onDismissalAttempt
        
        return controller
    }
    
    func updateUIViewController(
        _ uiViewController: ModalHostingController<AnyView>, context: Context
    ) {
        uiViewController.rootView = AnyView(view.environment(\.viewController, uiViewController))
        
        uiViewController.canDismissSheet = canDismissSheet
        uiViewController.onDismissalAttempt = onDismissalAttempt
    }
}

extension View {
    /// モーダルの下スワイプ無効
    func interactiveDismiss(canDismissSheet: Bool, onDismissalAttempt: (() -> Void)? = nil)
    -> some View {
        ModalView(
            view: self,
            canDismissSheet: canDismissSheet,
            onDismissalAttempt: onDismissalAttempt
        )
            .edgesIgnoringSafeArea(.all)
    }
}
