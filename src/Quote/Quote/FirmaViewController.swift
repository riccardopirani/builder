//
//  FirmaViewController.swift
//  Quote
//
//  Created by riccardo on 19/06/18.
//  Copyright © 2018 ViewSoftware. All rights reserved.
//

import UIKit
import Signature

class FirmaViewController: UIViewController
{
    let signatureView = HYPSignatureView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 100))

    var delegate: RapportinoDelegate?

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        self.view.addSubview(signatureView)

        let ImageReturn = UIImage(named: "return.png") as UIImage?
        let buttonReturn = UIButton()
        buttonReturn.frame = CGRect(x: (self.view.frame.width / 2), y: (UIScreen.main.bounds.size.height - 70), width: 50, height: 50)
        buttonReturn.backgroundColor = UIColor.gray
        buttonReturn.setImage(ImageReturn, for: .normal)
        buttonReturn.setTitle("Go Home", for: .normal)
        buttonReturn.addTarget(self, action: #selector(Return), for: .touchUpInside)
        self.view.addSubview(buttonReturn)

    }

    @objc func Return(sender: UIButton!) {

        //Controllo se è presente la firma
        if(signatureView.hasSignature == true) {

            let extend = Extend()
            let ImageBase64 = extend.CastUImagetoBase64(immagine: signatureView.signatureImage()!)
            delegate?.popupFirmaSelected(value: ImageBase64)
            dismiss(animated: true)

        }
        else {
            dismiss(animated: true)
        }
    }


}
