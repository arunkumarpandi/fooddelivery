//
//  MenuInteractor.swift
//  DinDinn
//
//

import Foundation
import Moya

//object
// protocol
//ref to presenter

// API CALL
// API URL


enum MenuService {
    case readMenu
}

extension MenuService : TargetType {
    var baseURL: URL {
        return URL(string: Constants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .readMenu:
            return "/menu/db"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .readMenu:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .readMenu:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Typer" : "application/json"]
    }
}

protocol AnyInteractor {
    var presenter: AnyPresenter? {get set}
    func getMenu()
}

class MenuInteractor: AnyInteractor {
    let menuProvider = MoyaProvider<MenuService>()
    
    func getMenu() {
        menuProvider.request(.readMenu) { result in
            switch result {
            case .success(let response):
                let json = try! JSONSerialization.jsonObject(with: response.data, options: [])
                let menu = Menu(JSON: json as! [String : Any])
                self.presenter?.interactorFetchMenu(with: .success(menu!))
            case .failure(let error):
                print("Get Menu Web service error \(error)")
                self.presenter?.interactorFetchMenu(with: .failure(error))
            }
        }
    }
    
    var presenter: AnyPresenter?
    
}
