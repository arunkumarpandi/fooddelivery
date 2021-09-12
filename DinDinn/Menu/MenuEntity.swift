//
//  MenuEntity.swift
//  DinDinn
//
//

import Foundation
import ObjectMapper
import RxCocoa
import RxSwift



// Object Mapper
class Menu: Mappable {
    required init?(map: Map) {

    }
    
    func mapping(map: Map) {
        pizza <- map["pizza"]
        rice <- map["rice"]
        drink <- map["drinks"]
    }
    
    var pizza:[MenuItem] = []
    var rice:[MenuItem] = []
    var drink:[MenuItem] = []
}




// Object Mapper
class MenuItem: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        rate <- map["rate"]
        desc <- map["desc"]
        weight <- map["weight"]
        size <- map["size"]
        type <- map["flavour"]
    }
    
    var name: String = ""
    var rate: String = ""
    var desc: String = ""
    var weight: String = ""
    var size: String = ""
    var type: String = ""
}
