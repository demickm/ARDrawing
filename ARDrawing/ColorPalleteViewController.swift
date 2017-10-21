//
//  ColorPalleteViewController.swift
//  ARDrawing
//
//  Created by Christian McMullin on 10/21/17.
//  Copyright © 2017 Demick McMullin. All rights reserved.
//

import UIKit

class ColorPalleteViewController: UIViewController {
    
    var selectedColor: UIColor?
    var delegate: colorPalleteDelegate?
    var viewIsShowing: Bool = false
    
    @IBAction func redButtonTapped(_ sender: UIButton) {
        
        selectColor(sender)
        
    }
    @IBAction func orangeButtonTapped(_ sender: UIButton) {
        selectColor(sender)
    }
    @IBAction func greenButtonTapped(_ sender: UIButton) {
        selectColor(sender)
    }
    @IBAction func blueButtonTapped(_ sender: UIButton) {
        selectColor(sender)
    }
    @IBAction func purpleButtonTapped(_ sender: UIButton) {
        selectColor(sender)
    }
    
    func selectColor(_ sender: UIButton) {
        guard let color = sender.backgroundColor else { return }
        viewIsShowing = false
        delegate?.selectColor(self, color: color)
    }
}

protocol colorPalleteDelegate: class {
    func selectColor(_ sender: ColorPalleteViewController, color: UIColor)
}
