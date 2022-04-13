//
//  ViewControllerHolder.swift
//  NicknameEdit-Sample
//
//  Created by Hiroaki-Hirabayashi on 2022/04/14.
//

import SwiftUI
// Viewを全面に横からPush表示させるため
struct ViewControllerHolder {
    weak var value: UIViewController?
}

struct ViewControllerKey: EnvironmentKey {
    static var defaultValue: ViewControllerHolder {
        return ViewControllerHolder(value: UIApplication.shared.windows.first?.rootViewController)
    }
}

extension EnvironmentValues {
    var viewController: UIViewController? {
        get { return self[ViewControllerKey.self].value }
        set { self[ViewControllerKey.self].value = newValue }
    }
}

extension UIViewController {
    /// Viewをモーダル表示させる
    func present<Content: View>(
        style: UIModalPresentationStyle = .automatic, @ViewBuilder builder: () -> Content
    ) {
        let toPresent = UIHostingController(rootView: AnyView(EmptyView()))
        toPresent.modalPresentationStyle = style
        toPresent.rootView = AnyView(
            builder()
                .environment(\.viewController, toPresent)
        )
        self.presentController(toPresent)
    }

    /// 表示
    private func presentController(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        // 表示方向
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window?.layer.add(transition, forKey: kCATransition)
        present(viewControllerToPresent, animated: false)
    }

    /// 戻る
    func dismissController() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        // 戻る方向
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window?.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false)
    }
}
