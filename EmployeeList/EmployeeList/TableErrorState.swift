//
//  TableErrorState.swift
//  EmployeeList
//
//  Created by Chad Weigle on 4/2/22.
//

import UIKit

class TableErrorState: UIViewController {
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "TableErrorState", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
