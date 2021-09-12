//
//  MenuView.swift
//  DinDinn
//
//

import Foundation
import UIKit
import RxSwift
import SwipeMenuViewController
import Parchment
import ImageSlideshow
import JJFloatingActionButton

// View Controller
// protocol
// reference presenter

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}

typealias MenuObject = Menu

protocol AnyView {
    var presenter: AnyPresenter? {get set}
    func update(with menu:Menu)
    func updateError(with error: String)
}

final class MenuViewController: UIViewController, AnyView, ImageSlideshowDelegate {
    var btn = UIButton(type: .custom)
    private var tabs: [String] = ["Pizza","Sushi", "Drinks",]
    var menuObj : AnyObject!
    var tabIndex = 0
    var viewControllers = [UIViewController]()
    let localSource = [BundleImageSource(imageString: "offer1"), BundleImageSource(imageString: "offer2"), BundleImageSource(imageString: "offer3"), BundleImageSource(imageString: "offer4")]
    
    
    lazy var faButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "cart"), for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(navigateToDetail), for: .touchUpInside)
        return button
    }()
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll
            .translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    @objc func navigateToDetail()  {
        self.navigationController?.isNavigationBarHidden = false
        let orderList = OrderListController()
        self.navigationController?.pushViewController(orderList, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(headerView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let view = UIWindow.key {
            view.addSubview(faButton)
            setupButton()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let view = UIWindow.key, faButton.isDescendant(of: view) {
            faButton.removeFromSuperview()
        }
    }
    
    func setupButton() {
        NSLayoutConstraint.activate([
            faButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            faButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -36),
            faButton.heightAnchor.constraint(equalToConstant: 80),
            faButton.widthAnchor.constraint(equalToConstant: 80)
            ])
        faButton.layer.cornerRadius = 40
        faButton.layer.masksToBounds = true
        faButton.layer.borderColor = UIColor.lightGray.cgColor
        faButton.layer.borderWidth = 4
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 230)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func updateError(with error: String) {
        
    }
    
    func update(with menu: Menu) {
        
        let slideshow =  ImageSlideshow(frame: headerView.bounds)
        slideshow.backgroundColor = .clear
        slideshow.slideshowInterval = 2.0
        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        slideshow.activityIndicator = DefaultActivityIndicator()
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = UIColor.white
        pageIndicator.pageIndicatorTintColor = UIColor.black
//        slideshow.pageIndicatorPosition = PageIndicatorPosition(horizontal: .left(padding: 20), vertical: .bottom)
        slideshow.pageIndicatorPosition = PageIndicatorPosition(vertical: .bottom)
        slideshow.pageIndicator = pageIndicator
        slideshow.delegate = self
        slideshow.setImageInputs(localSource)
        headerView.addSubview(slideshow)
        
        build(with: menu)
    }
    
    func build(with menu: Menu) {
        tabs.forEach { data in
            let vc = MenuList()
            vc.title = data
            if data == "Pizza" {
                vc.menuItem = menu.pizza
            } else if data == "Sushi" {
                vc.menuItem = menu.rice
            } else {
                vc.menuItem = menu.drink
            }
            viewControllers.append(vc)
        }

        let pagingViewController = PagingViewController(viewControllers: viewControllers)
        pagingViewController.dataSource = self
        pagingViewController.sizeDelegate = self
        pagingViewController.menuHorizontalAlignment = .center
        pagingViewController.indicatorColor = .clear
        pagingViewController.borderColor = .clear
        pagingViewController.indicatorOptions = .visible(
            height: 1,
            zIndex: Int.max,
            spacing: .zero,
            insets: .zero
        )
        addChild(pagingViewController)
        scrollView.addSubview(pagingViewController.view)
        view.constrainToEdges(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
    }
    
    var presenter: AnyPresenter?
}

extension MenuViewController: PagingViewControllerDataSource {
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return PagingIndexItem(index: index, title: tabs[index])
    }

    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        return viewControllers[index]
    }

    func numberOfViewControllers(in _: PagingViewController) -> Int {
        return tabs.count
    }
    
    
}

extension MenuViewController: PagingViewControllerSizeDelegate {
    // We want the size of our paging items to equal the width of the
    // city title. Parchment does not support self-sizing cells at
    // the moment, so we have to handle the calculation ourself. We
    // can access the title string by casting the paging item to a
    // PagingTitleItem, which is the PagingItem type used by
    // FixedPagingViewController.
    func pagingViewController(_ pagingViewController: PagingViewController, widthForPagingItem pagingItem: PagingItem, isSelected: Bool) -> CGFloat {
        guard let item = pagingItem as? PagingIndexItem else { return 0 }

        let insets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: pagingViewController.options.menuItemSize.height)
        let attributes = [NSAttributedString.Key.font: pagingViewController.options.font]

        let rect = item.title.boundingRect(with: size,
                                           options: .usesLineFragmentOrigin,
                                           attributes: attributes,
                                           context: nil)

        let width = ceil(rect.width) + insets.left + insets.right

        if isSelected {
            return width * 1.5
        } else {
            return width
        }
    }
}

extension ViewController: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        print("current page:", page)
    }
}






//class MenuController: UIViewController {
//    
//    var index = 0
//    let tableView: UITableView = {
//        let table = UITableView()
//        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        table.isHidden = true
//        table.delegate = nil
//        table.dataSource = nil
//        return table
//    }()
//    
//    var bag = DisposeBag()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .purple
//        view.addSubview(tableView)
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        tableView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
//    }
//    
//    func getMenu(with object: Menu) -> [MenuItem]{
//        print(">>>>> index \(index)")
//        if index == 0 {
//            print("pizza count \(object.pizza.count)")
//            return object.pizza
//        } else if  index == 1 {
//            return object.rice
//        } else if  index == 2 {
//            return object.drink
//        }
//        return [MenuItem]()
//    }
//    
//    func updateMenu(with menu: Menu) {
//        tableView.isHidden = false
//        let items = Observable.just(getMenu(with: menu))
//        items.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType:  UITableViewCell.self)) {
//            tv, tableviewitem, cell in
//            print("<<<<<<<< name \(tableviewitem.name)")
//            cell.textLabel?.text = tableviewitem.name
//        }.disposed(by: bag)
//    }
//    
//}
