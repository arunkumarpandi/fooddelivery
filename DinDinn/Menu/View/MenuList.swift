//
//  MenuList.swift
//  DinDinn
//
//

import UIKit
import RxSwift
import RxDataSources
import ObjectMapper
import RxCocoa

class MenuList: UIViewController , UITableViewDelegate {
    private let disposeBag = DisposeBag()
    var menuItem = [MenuItem]()  {
        didSet {
            
        }
    }
    // MARK: - Properties
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView
            .translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UINib(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        // Do any additional setup after loading the view.
        let dataSource = Observable.just(menuItem)
        dataSource.bind(to: tableView.rx.items(cellIdentifier: "MenuCell", cellType: MenuCell.self)) {
            (row,model,cell) in
            cell.menuCard.dropShadow()
            cell.menuImage.image = UIImage(named: model.name.replacingOccurrences(of: " ", with: ""))
            cell.menuLabel.text = model.name
            cell.menuDesc.text = model.desc
            cell.menuWeight.text = model.weight
            
            cell.menuButton.setTitle(model.rate, for: .normal)
            cell.menuButton.setTitle("added + 1", for: .selected)
            cell.menuButton.setTitle("added + 1", for: .highlighted)
            
            cell.menuButton.setTitleColor(.white, for: .normal)
            cell.menuButton.setTitleColor(.white, for: .selected)
            cell.menuButton.setTitleColor(.white, for: .highlighted)
             
            cell.menuButton.setBackgroundColor(color: .green.withAlphaComponent(0.5), forState: .selected)
            cell.menuButton.setBackgroundColor(color: .green.withAlphaComponent(0.5), forState: .highlighted)
            cell.menuButton.setBackgroundColor(color: .black, forState: .normal)
            
            cell.menuButton.tag = row + 100
            cell.menuButton.layer.cornerRadius = 20
            cell.menuButton.addTarget(self, action: #selector(self.orderedItems(with:)), for: .touchUpInside)
           
        }.disposed(by: disposeBag)
        tableView.tableFooterView = UIView()
        
    }
    
    @objc func orderedItems(with button:UIButton)  {
        let tappedButton = view.viewWithTag(button.tag)
    }
    
   
   
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
        tableView.backgroundColor = .systemGroupedBackground
    }

}

extension UIView {
    func dropShadow() {
        layer.cornerRadius = 10
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 1
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}

extension UIButton {

    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        self.clipsToBounds = true  // add this to maintain corner radius
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }

}

