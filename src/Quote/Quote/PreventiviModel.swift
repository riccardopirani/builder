//
//  PreventiviModel.swift
//  Quote
//
//  Created by riccardo on 27/11/2019.
//  Copyright © 2019 ViewSoftware. All rights reserved.
//

import Foundation

//Classe che rappresenta i Preventivi
class PreventiviModel {

    //Costruttore
    init() {

    }

    //Funzione per il caricamento dei cantieri che non hanno il preventivo agganciato
    func CaricaCantieriSenzaPreventivoAgganciato(completion: @escaping ([PreventivoStruct]) -> ())
    {
        let jsonrequest = JSON()
        let jsonarray: [String: Any] = ["": ""]
        jsonrequest.GetArray(Tipo: "PreventivoStruct", Router: "/preventivo/caricapreventivosenzacantiere", ValueArray: jsonarray, completion: { result in
            completion(result as! [PreventivoStruct])
        })
    }
}
