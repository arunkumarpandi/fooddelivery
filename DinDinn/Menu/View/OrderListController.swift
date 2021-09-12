//
//  OrderListController.swift
//  DinDinn
//
//

import UIKit

class OrderListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let items = ["Margherita","Cheese n Corn","Spiced Chicken Sausage"]
    let rates = ["99","309","459"]
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView
            .translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: "OrderCell")
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        return tableView
    }()
    
    lazy var faButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "suitcase"), for: .normal)
        button.backgroundColor = .white
//        button.addTarget(self, action: #selector(navigateToDetail), for: .touchUpInside)
        return button
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell") as! OrderCell
        cell.menuImage.image = UIImage(named: items[indexPath.row].replacingOccurrences(of: " ", with: ""))
        cell.menuLabel.text = items[indexPath.row]
        cell.menuRate.text = rates[indexPath.row]
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
