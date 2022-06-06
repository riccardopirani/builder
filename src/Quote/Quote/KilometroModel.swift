//
//  KilometroModel.swift
//  Quote
//
//  Created by riccardo on 02/05/18.
//  Copyright © 2018 ViewSoftware. All rights reserved.
//

import Foundation

//Classe che rappresenta il kilometro nel model
class KilometroModel {

    //Costruttore
    init() {

    }

    //Funzione di eliminazione dei kilometri
    func EliminaKilometri(IdDelete: Int, completion: @escaping (Bool) -> ())
    {
        DispatchQueue.global(qos: .userInteractive).async {
            let jsonrequest = JSON()
            let jsonarray: [String: Any] = ["IdDelete": IdDelete]

            jsonrequest.GetSingleValue(Router: "/kilometro/eliminakilometrocantiere", ValueArray: jsonarray, completion: { result in
                completion(result)
            })
        }
    }

    //Funzione Inserimento Kilometri
    func InserisciKilometri(Rapportino: Bool, IdCantiere: Int, IdUtente: Int, Data: String, TipoMezzo: String, Targa: String, Kilometri: Float, CostoKilometro: Float, DirittoChiamata: Float, completion: @escaping (Bool) -> ())
    {
        DispatchQueue.global(qos: .userInteractive).async {
            let jsonrequest = JSON()
            let jsonarray: [String: Any] = ["Rapportino": Rapportino, "IdCantiere": IdCantiere, "IdUtente": IdUtente, "Data": Data, "TipoMezzo": TipoMezzo, "Targa": Targa, "Kilometri": Kilometri, "CostoKilometrico": CostoKilometro, "DirittoChiamata": DirittoChiamata]

            jsonrequest.GetSingleValue(Router: "/kilometro/inseriscikilometro", ValueArray: jsonarray, completion: { result in
                completion(result)
            })
        }
    }

    //Funzione per il caricamento Kilometri Cantiere
    func CaricaKilometriCantiere(IdCantiere: Int, completion: @escaping ([KilometroStruct]) -> ())
    {
        let jsonrequest = JSON()
        let jsonarray: [String: Any] = ["IdCantiere": IdCantiere]
        jsonrequest.GetArray(Tipo: "KilometroStruct", Router: "/kilometro/caricakilometricantiere", ValueArray: jsonarray, completion: { result in
            completion(result as! [KilometroStruct])
        })
    }


}
