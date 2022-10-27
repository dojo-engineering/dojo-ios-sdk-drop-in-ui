//
//  BaseNavigationController.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 18/08/2022.
//

import UIKit

class BaseNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    var heightConstraint: NSLayoutConstraint?
    var defaultHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        heightConstraint = self.view.heightAnchor.constraint(equalToConstant: 350)
        NSLayoutConstraint.activate([
            self.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            self.view.widthAnchor.constraint(equalToConstant: 500),
            heightConstraint!, //TODO
        ])
    }

    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        // Remove title form back button
        let item = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
        
        if let _ = viewController as? PaymentMethodCheckoutViewController {
            if let defaultHeight = defaultHeight {
                heightConstraint?.constant = defaultHeight + safeAreaBottomHeight
            } else {
                heightConstraint?.constant = 286 + safeAreaBottomHeight
            }
        }

        if let _ = viewController as? ManagePaymentMethodsViewController {
            heightConstraint?.constant = UIScreen.main.bounds.height - 60
        }

        if let _ = viewController as? CardDetailsCheckoutViewController {
            heightConstraint?.constant = UIScreen.main.bounds.height - 60
        }
        
        if let _ = viewController as? PaymentResultViewController {
            heightConstraint?.constant = 616 + safeAreaBottomHeight
        }
        
        UIView.setAnimationsEnabled(false)
    }
    
    var safeAreaBottomHeight: CGFloat {
        UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
        UIView.setAnimationsEnabled(true)
    }
    
    enum PreferredSheetSizing: CGFloat {
        case fit = 0 // Fit, based on the view's constraints
        case small = 0.25
        case medium = 0.5
        case large = 0.75
        case fill = 1
    }

    lazy var bottomSheetTransitioningDelegate = BottomSheetTransitioningDelegate(
        preferredSheetTopInset: preferredSheetTopInset,
        preferredSheetCornerRadius: preferredSheetCornerRadius,
        preferredSheetSizingFactor: preferredSheetSizing.rawValue,
        preferredSheetBackdropColor: preferredSheetBackdropColor
    )

    override var additionalSafeAreaInsets: UIEdgeInsets {
        get {
            .init(
                top: super.additionalSafeAreaInsets.top + preferredSheetCornerRadius/2,
                left: super.additionalSafeAreaInsets.left,
                bottom: super.additionalSafeAreaInsets.bottom,
                right: super.additionalSafeAreaInsets.right
            )
        }
        set {
            super.additionalSafeAreaInsets = newValue
        }
    }

    override var modalPresentationStyle: UIModalPresentationStyle {
        get {
            .custom
        }
        set { }
    }

    override var transitioningDelegate: UIViewControllerTransitioningDelegate? {
        get {
            bottomSheetTransitioningDelegate
        }
        set { }
    }

    var preferredSheetTopInset: CGFloat = 24 {
        didSet {
            bottomSheetTransitioningDelegate.preferredSheetTopInset = preferredSheetTopInset
        }
    }

    var preferredSheetCornerRadius: CGFloat = 8 {
        didSet {
            bottomSheetTransitioningDelegate.preferredSheetCornerRadius = preferredSheetCornerRadius
        }
    }

    var preferredSheetSizing: PreferredSheetSizing = .medium {
        didSet {
            bottomSheetTransitioningDelegate.preferredSheetSizingFactor = preferredSheetSizing.rawValue
        }
    }

    var preferredSheetBackdropColor: UIColor = .black.withAlphaComponent(0.6) {
        didSet {
            bottomSheetTransitioningDelegate.preferredSheetBackdropColor = preferredSheetBackdropColor
        }
    }

    var tapToDismissEnabled: Bool = true {
        didSet {
            bottomSheetTransitioningDelegate.tapToDismissEnabled = tapToDismissEnabled
        }
    }

    var panToDismissEnabled: Bool = true {
        didSet {
            bottomSheetTransitioningDelegate.panToDismissEnabled = panToDismissEnabled
        }
    }
}
