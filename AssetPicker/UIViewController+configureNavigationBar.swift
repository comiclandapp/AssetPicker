//
//  UIViewController+configureNavigationBar.swift
//  InAppSettingsApp
//
//  Created by Antonio Montes on 3/24/20.
//  Copyright © 2020 Antonio Montes. All rights reserved.
//

import UIKit

extension UIViewController {

    public func configureNavigationBar(largeTitleColor: UIColor,
                                       backgroundColor: UIColor,
                                       tintColor: UIColor,
                                       prefersLargeTitles: Bool = true) {

        let navBarAppearance = UINavigationBarAppearance()

        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: largeTitleColor]
        navBarAppearance.titleTextAttributes = [.foregroundColor: largeTitleColor]
        navBarAppearance.backgroundColor = backgroundColor
        navBarAppearance.shadowColor = nil

        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.compactAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance

        navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = tintColor
    }
}
