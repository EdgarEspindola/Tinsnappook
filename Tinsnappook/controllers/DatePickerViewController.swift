//
//  DatePickerViewController.swift
//  Tinsnappook
//
//  Created by Usuario on 11/05/18.
//  Copyright © 2018 edgarespindola. All rights reserved.
//  Email: edgareduardoespindola@gmail.com
//

import UIKit

class DatePickerViewController: UIViewController {
    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func dateSelected(_ sender: UIButton) {
        let birthDate = datePicker.date
        let dateFormatter = FactoryFormatterDate.shorStyleWithHour()
        navigationController?.popViewController(animated: true)
        if let vc = navigationController?.topViewController as? ProfileUser {
            vc.loadBirthDate(date: dateFormatter.string(from: birthDate))
        }
    }
}
