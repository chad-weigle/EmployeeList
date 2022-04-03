//
//  TableLoadingState.swift
//  EmployeeList
//
//  Created by Chad Weigle on 4/2/22.
//

import UIKit

class TableLoadingState: UIViewController {
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "TableLoadingState", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
