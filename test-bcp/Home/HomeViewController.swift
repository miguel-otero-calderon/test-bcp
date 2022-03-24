//
//  ViewController.swift
//  test-bcp
//
//  Created by Miguel on 24/03/22.
//

import UIKit
import Foundation

class HomeViewController: UIViewController {
    @IBOutlet weak var firstCurrencyAmountTextField: UITextField!
    @IBOutlet weak var secondCurrencyAmountTextField: UITextField!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var btnFromView: UIView!
    @IBOutlet weak var firstCurrencyLabel: UILabel!
    @IBOutlet weak var btnToView: UIView!
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
        event()
        viewModel.delegate = self
        viewModel.getCurrrencies()
    }
    func setupView(){
        self.firstCurrencyAmountTextField.delegate = self
        self.secondCurrencyAmountTextField.delegate = self
        secondCurrencyAmountTextField.isEnabled = false
        secondCurrencyAmountTextField.isUserInteractionEnabled = false
        currentPriceLabel.isHidden = true
        firstCurrencyAmountTextField.isHidden = true
        secondCurrencyAmountTextField.isHidden = true
    }
 
    func event(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.firstChangeCurrency(_:)))
        btnFromView.addGestureRecognizer(tap)
        
        let tapSecond = UITapGestureRecognizer(target: self,
                                               action: #selector(self.secondChangeCurrency(_:)))
        btnToView.addGestureRecognizer(tapSecond)

        firstCurrencyAmountTextField.addTarget(self,
                                               action: #selector(starOperation (amountTextField:)), for: .editingChanged)
        
        let tapChanges = UITapGestureRecognizer(target: self,
                                                action: #selector(self.changesCurrency(_:)))
                    changeIconView.addGestureRecognizer(tapChanges)
                
    }
    
    @objc func changesCurrency(_:UIImageView){
        
        guard let amountSource = Double(self.secondCurrencyAmountTextField.text!) else { return }
        guard let amountDestination = Double(self.firstCurrencyAmountTextField.text!) else { return }
        guard let currencySourceDescription = self.secondCurrencyLabel.text else { return }
        guard let currencyDestinationDescription = self.firstCurrencyLabel.text else { return }
        
        var rateSource:Double = 0
        var rateDestination:Double = 0
        
//        for currency in self.currencies! {
//            if currency.description == currencyDestinationDescription {
//                rateDestination = currency.rate
//            }
//
//            if currency.description == currencySourceDescription {
//                rateSource = currency.rate
//                currentPriceLabel.text = "Compra \(currency.buy) | Venta: \(currency.sell)"
//            }
//        }
        
        self.firstCurrencyAmountTextField.text = String(amountSource)
        self.secondCurrencyAmountTextField.text = String(amountDestination)
        self.firstCurrencyLabel.text = currencySourceDescription
        self.secondCurrencyLabel.text = currencyDestinationDescription
        
        UserDefaults.standard.setValue(rateSource, forKey: "rateSource")
        
        self.operation()
    }
    
    @objc func starOperation(amountTextField:UITextField){
        self.operation()
    }
    
    @objc func firstChangeCurrency(_ sesder: UITapGestureRecognizer? = nil) {
        showListCurrency()
    }
    
    @objc func secondChangeCurrency(_ sender: UITapGestureRecognizer? = nil) {
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
//        guard let destinationCurrency = self.secondCurrencyLabel.text else { return }
//        let rateSource = UserDefaults.standard.double(forKey: "rateSource")
//        var rateDestination :Double = 0
//        guard let myCurrencies = self.currencies else {return}
//        for currency in myCurrencies {
//            if currency.description == destinationCurrency {
//                rateDestination = currency.rate
//            }
//        }
        
//        guard let amountSource = Double(self.firstCurrencyAmountTextField.text!) else { return }
//
//        let amount = amountSource * rateDestination / rateSource
//        let rounded = amount.roundToDecimal(2)
//
//        self.secondCurrencyAmountTextField.text = String(rounded)
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
        currentPriceLabel.isHidden = false
        firstCurrencyAmountTextField.isHidden = false
        secondCurrencyAmountTextField.isHidden = false
        
        currentPriceLabel.text = "Compra: \(currency.buy) | Venta: \(currency.sell)"
        
        firstCurrencyAmountTextField.text = String(initValue)
        secondCurrencyAmountTextField.text = String(initValue*currency.buy)
        
        firstCurrencyLabel.text = "Dolares"
        secondCurrencyLabel.text = currency.description
        
    }
}
extension HomeViewController: ListCurrenciesViewControllerDelegate {
    func selected(currency: GetCurrenciesResponse) {
        print(currency)
    }
}
