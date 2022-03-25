//
//  ViewController.swift
//  test-bcp
//
//  Created by Miguel on 24/03/22.
//

import UIKit
import Foundation

class HomeViewController: UIViewController {
    @IBOutlet weak var firstText: UITextField!
    @IBOutlet weak var secondText: UITextField!
    @IBOutlet weak var footerLabel: UILabel!
    @IBOutlet weak var firtsView: UIView!
    @IBOutlet weak var firstCurrencyLabel: UILabel!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var secondCurrencyLabel: UILabel!
    @IBOutlet weak var exchangeCurrenciesView: UIView!
    
    var viewModel: HomeViewModelType = HomeViewModel(currrencyService: CurrencyService())
    var currencies:[GetCurrenciesResponse] = []
    var current:GetCurrenciesResponse?
    let initValue:Double = 100.00

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        settingTap()
        
        viewModel.delegate = self
        viewModel.getCurrrencies()
        firstText.becomeFirstResponder()
    }
    func settingTap() {
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.tapFirstCurrency(_:)))
        firtsView.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self,action: #selector(self.tapSecondCurrency(_:)))
        secondView.addGestureRecognizer(tap2)

        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.exchangeCurrencies(_:)))
        exchangeCurrenciesView.addGestureRecognizer(tap3)
        
        firstText.addTarget(self, action: #selector(editingChanged(amounText:)), for: .editingChanged)
    }
    func setupView() {
        self.firstText.delegate = self
        self.secondText.delegate = self
        secondText.isEnabled = false
        secondText.isUserInteractionEnabled = false
        
        footerLabel.isHidden = true
        firstText.isHidden = true
        secondText.isHidden = true
    }
    
    @objc func exchangeCurrencies(_:UIImageView){
        let money01 = firstCurrencyLabel.text
        let money02 = secondCurrencyLabel.text
        firstCurrencyLabel.text = money02
        secondCurrencyLabel.text = money01
        operation()
    }
    
    @objc func editingChanged(amounText:UITextField){
        self.operation()
    }
    
    @objc func tapFirstCurrency(_ sesder: UITapGestureRecognizer? = nil) {
        showListCurrency()
    }
    
    @objc func tapSecondCurrency(_ sender: UITapGestureRecognizer? = nil) {
        showListCurrency()
    }
    
    func showListCurrency(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: ListCurrenciesViewController.identifier) as! ListCurrenciesViewController
        vc.currencies = currencies
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func operation(){
        guard let source = firstText.text else { return }
        guard let buy = self.current?.buy else { return }
        guard let sell = self.current?.sell else { return }
        
        let value01 = Double(source) ?? 0.00
        var value02:Double = 0.00
    
        if firstCurrencyLabel.text?.uppercased() == "DOLARES" || firstCurrencyLabel.text?.uppercased() == "EURO"  {
            value02 = value01*buy
            secondCurrencyLabel.text = current?.description
        } else {
            value02 = value01/sell
            firstCurrencyLabel.text = current?.description
        }
        secondText.text = value02.toString(decimal: 2)
    }
    
    @IBAction func startOperationButtonPressed(_ sender: Any) {
        self.operation()
        Toast(duration: 0.8,
              text: "Operacion realizada",
              container: self.navigationController,
              backgroundColor: Colors.lightGreen,
              completion: {})
    }
}

extension HomeViewController :UITextFieldDelegate {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
extension HomeViewController : HomeViewModelDelegate {
    func getCurrrencies(currencies: [GetCurrenciesResponse]?, error: Error?) {
        self.currencies = []
        if let currencies = currencies {
            self.currencies = currencies
            if isViewLoaded {
                if let current = currencies.first(where: { c in c.country.uppercased() == "PERU"}) {
                    self.current = current
                    fillDataCurrency()
                }
            }
        }
        
        if let error = error {
            print(error)
        }
    }
}
extension HomeViewController {
    func fillDataCurrency() {
        guard let currency = self.current else { return }
        footerLabel.isHidden = false
        firstText.isHidden = false
        secondText.isHidden = false
        
        footerLabel.text = "Compra: \(currency.buy) | Venta: \(currency.sell)"
        
        firstText.text = String(initValue)
        firstCurrencyLabel.text = currency.description2
        secondCurrencyLabel.text = currency.description
        operation()
    }
}
extension HomeViewController: ListCurrenciesViewControllerDelegate {
    func selected(currency: GetCurrenciesResponse) {
        self.current = currency
        fillDataCurrency()
    }
}
