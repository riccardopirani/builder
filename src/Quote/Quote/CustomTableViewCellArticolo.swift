import UIKit
import Foundation

class CustomTableViewCellArticolo: UITableViewCell {

    let labCodArt = UILabel()
    let labDescrizione = UILabel()
    let labPrezzo = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        labCodArt.translatesAutoresizingMaskIntoConstraints = false
        labDescrizione.translatesAutoresizingMaskIntoConstraints = false
        labPrezzo.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(labCodArt)
        contentView.addSubview(labDescrizione)
        contentView.addSubview(labPrezzo)

        let viewsDict = [
            "CodArt": labCodArt,
            "Descrizione": labDescrizione,
            "Prezzo": labPrezzo,
        ] as [String: Any]

        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[Prezzo]-15-[Descrizione]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[CodArt]-5-[Descrizione]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[CodArt]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[Descrizione]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[Prezzo]-|", options: [], metrics: nil, views: viewsDict))

        labPrezzo.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)

            labDescrizione.adjustsFontSizeToFitWidth = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
