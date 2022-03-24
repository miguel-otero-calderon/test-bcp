//
//  CurrencyTableViewCell.swift
//  test-bcp
//
//  Created by Miguel on 24/03/22.
//

import UIKit
import Kingfisher

class CurrencyTableViewCell: UITableViewCell {

    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var convertionLabel: UILabel!
    public static let identifier = "CurrencyTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setCell(_ currency: GetCurrenciesResponse) {
        self.countryNameLabel.text = currency.country
        if let url =  URL(string: currency.image) {
            self.countryImage.kf.setImage(with: url)
        } else {
            self.countryImage.image = UIImage(named: "noImageAvailable")
        }

        self.convertionLabel.text = "1 EUR = \(currency.rate) \(currency.symbol)"
    }
}
