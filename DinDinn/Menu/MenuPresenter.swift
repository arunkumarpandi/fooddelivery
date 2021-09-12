//
//  MenuPresenter.swift
//  DinDinn
//
//

import Foundation

// Object
//protocol
//ref to interactor, router, view


protocol AnyPresenter {
    var router: AnyRouter? {get set}
    var interactor: AnyInteractor? {get set}
    var view: AnyView? {get set}
    
    func interactorFetchMenu(with result: Result<Menu, Error>)
}

class MenuPresenter: AnyPresenter {
    
    func interactorFetchMenu(with result: Result<Menu, Error>) {
        switch result {
        case .success(let menu):
            view?.update(with: menu)
        case .failure(let error):
            view?.updateError(with: error.localizedDescription)
        }
    }
    
    var interactor: AnyInteractor? {
        didSet {
            interactor?.getMenu()
        }
    }
    
    var view: AnyView?
    
    var router: AnyRouter?
     
    
}
