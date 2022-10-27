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
    func showManagePaymentMethods(_ selectedPaymentMethod: PaymentMethodItem?)
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
    var config: ConfigurationManager
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
    }
    
    func showDataLoading() {
        pushNewScreenToTheFlow(screenType: .dataLoading, config: config)
    }
    
    func showPaymentMethodCheckout() {
        pushNewScreenToTheFlow(screenType: .paymentMethodCheckout, config: config)
    }
    
    func showManagePaymentMethods(_ selectedPaymentMethod: PaymentMethodItem? = nil) {
        let viewModel = ManagePaymentMethodsViewModel(config: config, selectedPaymentMethod: selectedPaymentMethod)
        let controller = ManagePaymentMethodsViewController(viewModel: viewModel, theme: config.themeSettings, delegate: self)
        pushNewViewControllerToTheFlow(controller: controller)
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
            let viewModel = DataLoadingViewModel(paymentIntentId: config.paymentIntentId, customerSecret: config.customerSecret, demoDelay: config.demoDelay)
            controller = DataLoadingViewController(viewModel: viewModel, theme: config.themeSettings, delegate: self)
        case .cardDeailsCheckout:
            let viewModel = CardDetailsCheckoutViewModel(config: config)
            controller = CardDetailsCheckoutViewController(viewModel: viewModel, theme: config.themeSettings, delegate: self)
        case .paymentMethodCheckout:
            let viewModel = PaymentMethodCheckoutViewModel(config: config)
            controller = PaymentMethodCheckoutViewController(viewModel: viewModel, theme: config.themeSettings, delegate: self)
        case .managePaymentMethods:
            let viewModel = ManagePaymentMethodsViewModel(config: config)
            controller = ManagePaymentMethodsViewController(viewModel: viewModel, theme: config.themeSettings, delegate: self)
        }
        return controller
    }
    
    func propagateConfigChanges() {
        // Propagate changes to all view controllers
        rootNavController.viewControllers.forEach({
            if let controller = $0 as? BaseUIViewController {
                controller.viewModel?.paymentIntent = config.paymentIntent
                controller.theme = config.themeSettings
                controller.setUpDesign()
            }
        })
    }
}

extension RootCoordinator: PaymentMethodCheckoutViewControllerDelegate {
    func navigateToCardCheckout() {
        showCardDetailsCheckout()
    }
    
    func navigateToManagePaymentMethods(_ selectedPaymentMethod: PaymentMethodItem) {
        showManagePaymentMethods(selectedPaymentMethod)
    }
}

extension RootCoordinator: ManagePaymentMethodsViewControllerDelegate {
    func onPayUsingPaymentMethod(_ item: PaymentMethodItem) {
        rootNavController.viewControllers.forEach({
            if let controller = $0 as? PaymentMethodCheckoutViewController {
                controller.paymentMethodSelected(item)
            }
        })
        rootNavController.popViewController(animated: false)
    }
    
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
    
    func onPaymentIntentRefreshSucess(paymentIntent: PaymentIntent) {
        config.paymentIntent = paymentIntent
        propagateConfigChanges()
       
        rootNavController.popViewController(animated: false) //TODO: make a method for navigating back
    }
}

extension RootCoordinator: BaseViewControllerDelegate {
    func onForceClosePress() {
        rootNavController.dismiss(animated: true)
        delegate?.userForceClosedFlow()
    }
}

extension RootCoordinator: DataLoadingViewControllerDelegate {
    func paymentIntentDownloaded(_ paymentIntent: PaymentIntent) {
        config.paymentIntent = paymentIntent
        propagateConfigChanges()
        if paymentIntent.status == "Captured" { //TODO:
            showPaymentResult(resultCode: 0)
        } else {
            showPaymentMethodCheckout()
        }
    }
    
    func errorLoadingPaymentIntent(error: Error) {
        rootNavController.dismiss(animated: true) //TODO: repeats in a few places
        delegate?.userFinishedFlow(resultCode: (error as NSError).code)
    }
}
