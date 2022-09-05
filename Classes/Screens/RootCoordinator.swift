//
//  PaymentMethodCheckoutViewController.swift
//  dojo-ios-sdk
//
//  Created by Deniss Kaibagarovs on 04/08/2022.
//

import UIKit

protocol RootCoordinatorDelegate {
    func userForceClosedFlow()
    func userFinishedFlow(resultCode: Int)
}

protocol RootCoordinatorProtocol {
    func beginFlow()
    func showDataLoading()
    func showPaymentMethodCheckout()
    func showCardDetailsCheckout()
    func showManagePaymentMethods()
    func showPaymentResult(resultCode: Int)
}

class RootCoordinator: RootCoordinatorProtocol {
    
    enum ScreenType {
        case dataLoading
        case paymentMethodCheckout
        case cardDeailsCheckout
        case managePaymentMethods
    }
    
    let presentationViewController: UIViewController
    let rootNavController: BaseNavigationController
    let config: ConfigurationManager
    var delegate: RootCoordinatorDelegate?
    
    init (presentationViewController: UIViewController,
          config: ConfigurationManager,
          delegate: RootCoordinatorDelegate) {
        self.presentationViewController = presentationViewController
        self.rootNavController = BaseNavigationController()
        self.rootNavController.tapToDismissEnabled = false
        self.rootNavController.panToDismissEnabled = false
        self.rootNavController.preferredSheetSizing = .fit
        self.config = config
        self.delegate = delegate
    }
    
    func beginFlow() {
        showDataLoading()
        // For Demo purposes
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showPaymentMethodCheckout()
        }
    }
    
    func showDataLoading() {
        pushNewScreenToTheFlow(screenType: .dataLoading, config: config)
    }
    
    func showPaymentMethodCheckout() {
        pushNewScreenToTheFlow(screenType: .paymentMethodCheckout, config: config)
    }
    
    func showManagePaymentMethods() {
        pushNewScreenToTheFlow(screenType: .managePaymentMethods, config: config)
    }
    
    func showCardDetailsCheckout() {
        pushNewScreenToTheFlow(screenType: .cardDeailsCheckout, config: self.config)
    }
    
    func showPaymentResult(resultCode: Int) {
        let viewModel = PaymentResultViewModel(config: config, resultCode: resultCode)
        let controller = PaymentResultViewController(viewModel: viewModel, theme: config.themeSettings, delegate: self)
        pushNewViewControllerToTheFlow(controller: controller)
    }
}

extension RootCoordinator {
    
    func pushNewScreenToTheFlow(screenType: ScreenType, config: ConfigurationManager) {
        guard let viewController = getViewControllerFor(screenType: screenType, config: config) else {
            // return an error from the SDK?
            return
        }
        pushNewViewControllerToTheFlow(controller: viewController)
    }
    
    func pushNewViewControllerToTheFlow(controller: UIViewController) {
        rootNavController.pushViewController(controller, animated: false) // TODO
        if rootNavController.presentingViewController == nil {
            presentationViewController.present(rootNavController, animated: true)
        }
    }
    
    func getViewControllerFor(screenType: ScreenType, config: ConfigurationManager) -> UIViewController? {
        var controller: UIViewController?
        switch screenType {
        case .dataLoading:
            controller = DataLoadingViewController(theme: config.themeSettings, delegate: self)
        case .cardDeailsCheckout:
            let viewModel = CardDetailsCheckoutViewModel(config: config)
            controller = CardDetailsCheckoutViewController(viewModel: viewModel, theme: config.themeSettings, delegate: self)
        case .paymentMethodCheckout:
            let viewModel = PaymentMethodCheckoutViewModel(config: config)
            controller = PaymentMethodCheckoutViewController(viewModel: viewModel, theme: config.themeSettings, delegate: self)
        case .managePaymentMethods:
            controller = ManagePaymentMethodsViewController(theme: config.themeSettings, delegate: self)
            break
        }
        return controller
    }
}

extension RootCoordinator: PaymentMethodCheckoutViewControllerDelegate {
    func navigateToManagePaymentMethods() {
        showManagePaymentMethods()
    }
}

extension RootCoordinator: ManagePaymentMethodsViewControllerDelegate {
    func onPayUsingNewCardPress() {
        showCardDetailsCheckout()
    }
}

extension RootCoordinator: CardDetailsCheckoutViewControllerDelegate {
    func navigateToPaymentResult(resultCode: Int) {
        showPaymentResult(resultCode: resultCode)
    }
}

extension RootCoordinator: PaymentResultViewControllerDelegate {
    func onDonePress(resultCode: Int) {
        rootNavController.dismiss(animated: true)
        delegate?.userFinishedFlow(resultCode: resultCode)
    }
}

extension RootCoordinator: BaseViewControllerDelegate {
    func onForceClosePress() {
        rootNavController.dismiss(animated: true)
        delegate?.userForceClosedFlow()
    }
}
