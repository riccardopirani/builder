
import Foundation

/**
 * @brief  La classe Risorsa Umana Rappresenta una generalizzazione di User
 * 
 * @author: uml 
 * 
 * 
 */

struct RisorsaUmanaStruct: Codable {
    var IdRisorseUmane: Int
    var IdUtenteInserimento: Int
    var InseritoDA: String
    var ExtraPreventivo: Int
    var Risorsa: String
    var Data: String
    var Descrizione: String
    var TotaleOre: String
}

public class RisorsaUmana: User {

    private var CantiereInterno: Cantiere!
    private var UserInserimento: User!
    private var OreInizio: String!
    private var OreFine: String!
    private var Pausa: String!
    private var Data: String!
    private var Descrizione: String!
    private var RisorsaRapportino: Bool!
    private var IdRisorsaUmana: Int = 0
    private var IdTipologia: Int = 0

    init(IdRisorsaUmana: Int, CantiereInterno: Cantiere) {
        super.init()
        self.IdRisorsaUmana = IdRisorsaUmana
        self.CantiereInterno = CantiereInterno
    }

    init(CantiereInterno: Cantiere) {
        super.init()
        self.CantiereInterno = CantiereInterno
    }

    func SetDescrizione(Descrizione: String) {
        self.Descrizione = Descrizione
    }
    func SetData(Data: String) {
        self.Data = Data
    }

    func SetOreInizio(OreInizio: String) {
        self.OreInizio = OreInizio
    }

    func SetOreFine(OreFine: String) {
        self.OreFine = OreFine
    }

    func SetOrePausa(Pausa: String) {
        self.Pausa = Pausa
    }

    func SetRisorsaRapporto(RisorsaRapportino: Bool) {
        self.RisorsaRapportino = RisorsaRapportino
    }

    func SetIdTipologia(IdTipologia: Int) {
        self.IdTipologia = IdTipologia
    }
    func InserisciRisorsa(completion: @escaping (Bool) -> Void) {

        let rm = RisorseUmaneModel()
        rm.InserimentoRisorsaUmana(IdTipologia: self.IdTipologia, RisorsaRapportino: RisorsaRapportino, IdCantiere: self.CantiereInterno.GetIdCantiere(), IdUtenteInserimento: Int(GetIdUtenteLogin()), IdUtente: self.GetIdUtente(), Data: self.Data!, OreInizio: self.OreInizio!, Orefine: self.OreFine!, Pausa: self.Pausa!, Descrizione: self.Descrizione!, completion: {
                result in
                completion(result)
            })
    }
    func CaricaRisorseUmaneCantiere(completion: @escaping ([RisorsaUmanaStruct]) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            let rm = RisorseUmaneModel()
            rm.CaricaRisorseCantiere(IdCantiere: self.CantiereInterno.GetIdCantiere(), completion:
                    {
                        result in
                        completion(result)
                })
        }
    }

    func EliminaRisorsaCantiere(completion: @escaping (Bool) -> Void) {

        DispatchQueue.global(qos: .userInteractive).async {
            let rmodel = RisorseUmaneModel()
            rmodel.EliminazioneRisorsaUmanaCantiere(IdRisorsaUmana: self.IdRisorsaUmana, completion: {
                result in
                completion(result)
            })
        }
    }

}
