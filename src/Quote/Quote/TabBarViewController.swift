//
//  TabBarViewController.swift
//  Quote
//
//  Created by riccardo on 20/03/18.
//  Copyright © 2018 ViewSoftware. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    var u: User = User()
    /* Genero L'UITabBarController creando le ViewController ed inserendole in un array! */
    override func viewDidLoad() {
        super.viewDidLoad()
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = 60
        self.tabBar.frame = tabFrame
        hideKeyboardWhenTappedAround()

        let MarcaTempoView = MarcaTempoViewController()
        MarcaTempoView.tabBarItem = UITabBarItem(title: "Marca Tempo", image: UIImage(named: "clock.png")?.scaleImage(toSize: CGSize(width: 10, height: 10)), tag: 0)

        let CantieriView = CantieriViewController()
        CantieriView.tabBarItem = UITabBarItem(title: "Cantieri", image: UIImage(named: "home.png")?.scaleImage(toSize: CGSize(width: 10, height: 10)), tag: 1)

        let ArticoliView = RicercaViewController()
        ArticoliView.tabBarItem = UITabBarItem(title: "Articoli", image: UIImage(named: "articoli.png")?.scaleImage(toSize: CGSize(width: 10, height: 10)), tag: 2)

        let UserView = UserViewController()
        UserView.tabBarItem = UITabBarItem(title: "Utente", image: UIImage(named: "user.png")?.scaleImage(toSize: CGSize(width: 10, height: 10)), tag: 3)

        let ClienteView = ClienteViewController()
        ClienteView.tabBarItem = UITabBarItem(title: "Clienti", image: UIImage(named: "risorse_umane.png")?.scaleImage(toSize: CGSize(width: 10, height: 10)), tag: 4)

        let MagazzinoView = RicercaViewController()
        MagazzinoView.Stato = "Magazzino"
        MagazzinoView.u = u
        MagazzinoView.tabBarItem = UITabBarItem(title: "Magazzino", image: UIImage(named: "warehouse.png")?.scaleImage(toSize: CGSize(width: 10, height: 10)), tag: 5)

        let viewControllerList = [MarcaTempoView, CantieriView, ArticoliView, UserView, ClienteView, MagazzinoView]
    
        self.viewControllers = viewControllerList
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
