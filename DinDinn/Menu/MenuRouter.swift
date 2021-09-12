//
//  MenuRouter.swift
//  DinDinn
//
//

import Foundation
import UIKit

typealias EntryPoint = AnyView & UIViewController

// Object
// Entry Point

protocol AnyRouter {
    var entry: EntryPoint? {get}
    static func start() -> AnyRouter
}

class MenuRouter: AnyRouter {
    var entry: EntryPoint?
    static func start() -> AnyRouter {
        let router = MenuRouter()
        //Assign VIP
        var view: AnyView = MenuViewController()
        var interactor: AnyInteractor = MenuInteractor()
        var presenter: AnyPresenter = MenuPresenter()
        view.presenter = presenter
        interactor.presenter = presenter
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        router.entry = view as? EntryPoint
        return router
    }
}
