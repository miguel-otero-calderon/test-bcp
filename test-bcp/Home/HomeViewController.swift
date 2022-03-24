//
//  ViewController.swift
//  test-bcp
//
//  Created by Miguel on 24/03/22.
//

import UIKit

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
    
    private var currentRatesDate: String?
//    private var selectedConrverion = ConversionData()
//    private var currencies:[CurrencyResponse]?
//    private let service = CurrencyService()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        event()
    }
    func setupView(){
        self.firstCurrencyAmountTextField.delegate = self
        self.secondCurrencyAmountTextField.delegate = self
        secondCurrencyAmountTextField.isEnabled = false
        secondCurrencyAmountTextField.isUserInteractionEnabled = false
    }
 
    func event(){
        service.getListCurrency() { [weak self] (result) in
            
            switch result {
            case .success(let listOf):
                self?.currencies = listOf
                print(self!.currencies)
               
                for currency in self!.currencies! {
                    
                    if currency.symbol == "USD"{
                        self?.firstCurrencyLabel.text = "\(currency.description)"
                        self?.firstCurrencyAmountTextField.text = "100"
                        self!.currentPriceLabel.text = "Compra \(currency.buy) | Venta: \(currency.sell)"
                        UserDefaults.standard.setValue(currency.rate, forKey: "rateSource")
                        
                        
                    }
                    
                    if currency.symbol == "PEN"{
                        self?.secondCurrencyLabel.text = "\(currency.description)"
                        
                    }
                    self?.operation()
                }
            case .failure(let error):
                // Something is wrong with the JSON file or the model
                print("Error processing json data: \(error)")
            }
        }
        
        
        
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(self.firstChangeCurrency(_:)))
        btnFromView.addGestureRecognizer(tap)
        
//        let tapSecond = UITapGestureRecognizer(target: self,
//                                               action: #selector(self.secondChangeCurrency(_:)))
//        btnToView.addGestureRecognizer(tapSecond)
//
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
        
        for currency in self.currencies! {
            if currency.description == currencyDestinationDescription {
                rateDestination = currency.rate
            }
            
            if currency.description == currencySourceDescription {
                rateSource = currency.rate
                currentPriceLabel.text = "Compra \(currency.buy) | Venta: \(currency.sell)"
            }
        }
        
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
        let listCurrencyViewController = storyBoard.instantiateViewController(withIdentifier: "listCurrency") as! ListCurrencyViewController
        listCurrencyViewController.delegate = self
        self.navigationController?.pushViewController(listCurrencyViewController, animated: true)
    }
    
    func operation(){
        guard let destinationCurrency = self.secondCurrencyLabel.text else { return }
        let rateSource = UserDefaults.standard.double(forKey: "rateSource")
        var rateDestination :Double = 0
        guard let myCurrencies = self.currencies else {return}
        for currency in myCurrencies {
            if currency.description == destinationCurrency {
                rateDestination = currency.rate
            }
        }
        
        guard let amountSource = Double(self.firstCurrencyAmountTextField.text!) else { return }
        
        let amount = amountSource * rateDestination / rateSource
        let rounded = amount.roundToDecimal(2)
        
        self.secondCurrencyAmountTextField.text = String(rounded)
    }
    
    
    @IBAction func startOperationButtonPressed(_ sender: Any) {
        self.operation()
    }
}
extension ViewController: ListCurrencyDelegate{
    func selectedCurrency(currency: CurrencyResponse) {
        DispatchQueue.main.async { [self] in
            
            UserDefaults.standard.setValue(currency.rate, forKey: "rateSource")
            
            self.firstCurrencyLabel.text = currency.description
            
            self.currentPriceLabel.text = "Compra \(currency.buy) | Venta: \(currency.sell)"
            self.operation()
        }
        
//        self.secondCurrencyLabel.text = currency.description

    }
    
    func getCurrencies(currencies: [CurrencyResponse]){
        self.currencies = currencies
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
