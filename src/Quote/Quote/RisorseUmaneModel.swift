//
//  RisorseUmaneModel.swift
//  Quote
//
//  Created by riccardo on 12/04/18.
//  Copyright © 2018 ViewSoftware. All rights reserved.
//

import Foundation

//Classe Risorse Umane
class RisorseUmaneModel: UserModel {

    //Costruttore
    override init() {
    }
    
    //Eliminazione Risorsa Umana da Cantiere
    func EliminazioneRisorsaUmanaCantiere(IdRisorsaUmana: Int, completion: @escaping (Bool) -> ())
    {
        DispatchQueue.global(qos: .userInteractive).async {
            let jsonrequest = JSON()
            let jsonarray: [String: Any] = ["IdRisorsaUmana": IdRisorsaUmana]
            jsonrequest.GetSingleValue(Router: "/RisorseUmane/eliminarisorsacantiere", ValueArray: jsonarray, completion: { result in
                completion(result)
            })
        }
    }

    //Inserimento Risorsa Umana dentro cantiere
    func InserimentoRisorsaUmana(IdTipologia: Int, RisorsaRapportino: Bool, IdCantiere: Int, IdUtenteInserimento: Int, IdUtente: Int, Data: String, OreInizio: String, Orefine: String, Pausa: String, Descrizione: String, completion: @escaping (Bool) -> ())
    {
        DispatchQueue.global(qos: .userInteractive).async {
            let jsonrequest = JSON()
            let jsonarray: [String: Any] = ["IdTipologia": IdTipologia, "Rapportino": RisorsaRapportino, "IdCantiere": IdCantiere, "IdUtenteInserimento": IdUtenteInserimento, "IdUtente": IdUtente, "OreInizio": OreInizio, "OreFine": Orefine, "Pausa": Pausa, "Data": Data, "Descrizione": Descrizione]

            jsonrequest.GetSingleValue(Router: "/RisorseUmane/InserimentoRisorsa", ValueArray: jsonarray, completion: { result in
                completion(result)
            })
        }
    }

    //Caricamento risorse umane presenti nel cantiere
    func CaricaRisorseCantiere(IdCantiere: Int, completion: @escaping ([RisorsaUmanaStruct]) -> ()) {

        DispatchQueue.global(qos: .userInteractive).async {
            let jsonrequest = JSON()
            let jsonarray: [String: Any] = ["IdCantiere": IdCantiere]
            jsonrequest.GetArray(Tipo: "RisorsaUmanaStruct", Router: "/RisorseUmane/CaricaRisorseCantiere", ValueArray: jsonarray, completion: { result in
                completion(result as! [RisorsaUmanaStruct])
            })
        }
    }

}
