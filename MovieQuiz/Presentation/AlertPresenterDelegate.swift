//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Александр Медведев on 07.05.2023.
//

import Foundation
import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func showAlert(alert: UIAlertController, completion: (() -> Void)?)
}
