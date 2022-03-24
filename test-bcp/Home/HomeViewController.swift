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
    @IBOutlet weak var changeIconView: UIView!
    @IBOutlet weak var changeIconImage: UIImageView!
    
    var viewModel: HomeViewModelType = HomeViewModel(currrencyService: CurrencyService())
    var currencies:[GetCurrenciesResponse] = []
    var current:GetCurrenciesResponse?
    let initValue:Double = 100.00
    
    private var currentRatesDate: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        settingTap()
        
        viewModel.delegate = self
        viewModel.getCurrrencies()
    }
    func settingTap() {
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.tapFirstCurrency(_:)))
        firtsView.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self,action: #selector(self.tapSecondCurrency(_:)))
        secondView.addGestureRecognizer(tap2)

        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.changesCurrency(_:)))
        changeIconView.addGestureRecognizer(tap3)
        
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
    
    @objc func changesCurrency(_:UIImageView){
        
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
        guard let destinationCurrency = self.secondCurrencyLabel.text else { return }
        let rateSource = UserDefaults.standard.double(forKey: "rateSource")
        var rateDestination :Double = 0
        let myCurrencies = self.currencies
        for currency in myCurrencies {
            if currency.description == destinationCurrency {
                rateDestination = currency.rate
            }
        }
        
        guard let amountSource = Double(self.firstText.text!) else { return }

        let amount = amountSource * rateDestination / rateSource
        let rounded = amount.roundToDecimal(2)

        self.secondText.text = String(rounded)
    }
    
    
    @IBAction func startOperationButtonPressed(_ sender: Any) {
        self.operation()
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
        secondText.text = String(initValue*currency.buy)
        
        firstCurrencyLabel.text = "Dolares"
        secondCurrencyLabel.text = currency.description
        
    }
}
extension HomeViewController: ListCurrenciesViewControllerDelegate {
    func selected(currency: GetCurrenciesResponse) {
        print(currency)
    }
}
