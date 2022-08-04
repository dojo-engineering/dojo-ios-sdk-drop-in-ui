//
//  PaymentMethodCheckoutViewController.swift
//  dojo-ios-sdk
//
//  Created by Deniss Kaibagarovs on 04/08/2022.
//

import UIKit

protocol RootCoordinatorProtocol {
    func showPaymentMethodCheckout()
    func showCardDetailsCheckout()
    func showManagePaymentMethods()
}

class RootCoordinator: RootCoordinatorProtocol {
    
    enum ScreenType {
        case paymentMethodCheckout
        case cardDeailsCheckout
        case managePaymentMethods
    }
    
    let presentationViewController: UIViewController
    let rootNavController: UINavigationController
    let config: ConfigurationManager
    
    init (presentationViewController: UIViewController, config: ConfigurationManager) {
        self.presentationViewController = presentationViewController
        self.rootNavController = UINavigationController()
        self.config = config
    }
    
    func showPaymentMethodCheckout() {
        pushNewScreenToTheFlow(screenType: .paymentMethodCheckout, config: config)
    }
    
    func showManagePaymentMethods() {
       
    }
    
    func showCardDetailsCheckout() {
        pushNewScreenToTheFlow(screenType: .cardDeailsCheckout, config: config)
    }
}

extension RootCoordinator {
    
    func pushNewScreenToTheFlow(screenType: ScreenType, config: ConfigurationManager) {
        guard let viewController = getViewControllerFor(screenType: screenType, config: config) else {
            // return an error from the SDK?
            return
        }
        rootNavController.pushViewController(viewController, animated: true)
        if rootNavController.presentingViewController == nil {
            presentationViewController.present(rootNavController, animated: true)
        }
    }
    
    func getViewControllerFor(screenType: ScreenType, config: ConfigurationManager) -> UIViewController? {
        var controller: UIViewController?
        switch screenType {
        case .cardDeailsCheckout:
            let viewModel = CardDetailsCheckoutViewModel(config: config)
            controller = CardDetailsCheckoutViewController(viewModel: viewModel)
        case .paymentMethodCheckout:
            let viewModel = PaymentMethodCheckoutViewModel(config: config)
            controller = PaymentMethodCheckoutViewController(viewModel: viewModel, delegate: self)
        case .managePaymentMethods:
            break
        }
        return controller
    }
}

extension RootCoordinator: PaymentMethodCheckoutViewControllerDelegate {
    func navigateToManagePaymentMethods() {
        showCardDetailsCheckout()
    }
}
