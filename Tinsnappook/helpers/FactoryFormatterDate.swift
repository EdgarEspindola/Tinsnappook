//
//  FactoryFormatterDate.swift
//  Tinsnappook
//
//  Created by Usuario on 11/05/18.
//  Copyright © 2018 edgarespindola. All rights reserved.
//  Email: edgareduardoespindola@gmail.com
//

import UIKit

class FactoryFormatterDate {
    
    static func shorStyleWithHour() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        return dateFormatter
    }    
}
