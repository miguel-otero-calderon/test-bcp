//
//  ListCurrenciesViewController.swift
//  test-bcp
//
//  Created by Miguel on 24/03/22.
//

import UIKit
protocol ListCurrenciesViewControllerDelegate {
    func selected(currency:GetCurrenciesResponse)
}
class ListCurrenciesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    public static let identifier = "ListCurrenciesViewController"
    var currencies:[GetCurrenciesResponse] = []
    var delegate: ListCurrenciesViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(
            UINib(nibName: CurrencyTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CurrencyTableViewCell.identifier)
        tableView.delegate = self
        tableView.reloadData()
    }
    
}
extension ListCurrenciesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableViewCell.identifier, for: indexPath) as? CurrencyTableViewCell
        
        let currency = currencies[indexPath.row]
        cell?.setCell(currency)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.selected(currency: currencies[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
