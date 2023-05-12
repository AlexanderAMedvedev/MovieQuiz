//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Александр Медведев on 07.05.2023.
//

import Foundation

struct AlertViewModel {
    let title: String
    let message: String
    let buttonText: String
    // The block to execute after the presentation of alert finishes (see `present(_:animated:completion:) for UIViewController`)
    var completion: (() -> Void)? = nil
}

