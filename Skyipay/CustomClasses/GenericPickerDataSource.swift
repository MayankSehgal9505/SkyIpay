/*
* GenericPickerDataSource.swift
* Created on 14/12/20.
*
* Copyright (c) 2018, NETGEAR, Inc.
* 350 East Plumeria, San Jose California, 95134, U.S.A.
* All rights reserved.
*
*
* This software is the confidential and proprietary information of
* NETGEAR, Inc. ("Confidential Information"). You shall not
* disclose such Confidential Information and shall use it only in
* accordance with the terms of the license agreement you entered into
* with NETGEAR.
*
* @author VVDN
*
*/
import Foundation
import UIKit
protocol GenericPickerDataSourceDelegate: AnyObject {
    func selected(item: String)
}

class GenericPickerDataSource: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {

    public var items: [String]
    weak var delegate: GenericPickerDataSourceDelegate?

    public init(withItems items: Array<String>) {
        self.items = items
    }
    //MARK:- UIPickerViewDataSource Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
  
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    //MARK:- UIPickerViewDelegate Methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // if row is less than items count then only call seelected meethod
        if row < items.count {
            delegate?.selected(item: items[row])
        }
    }
}
