//
//  BaseDataSource.swift
//  gust
//
//  Created by Joseph Gorecki on 5/21/20.
//  Copyright © 2020 HarborDev. All rights reserved.
//

import Foundation
import UIKit

protocol BaseDataSourceDelegate: AnyObject {
    
    func didSelectTableWithObject(obj: Any, path: IndexPath)
    
}

typealias cellBlock = (UITableViewCell, Any) -> Void

class BaseDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var arr: [Any]?
    var cellBlock: cellBlock
    weak var delegate: BaseDataSourceDelegate?
    
    init(cellableCell:@escaping cellBlock) {
        self.cellBlock = cellableCell
    }
    
    // MARK: - table call backs to protocol
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = self.delegate else {
            return
        }
        
        let object: Any = arr?[indexPath.row] as Any
        delegate.didSelectTableWithObject(obj: object, path: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let object: Any = arr?[indexPath.row] as Any
        
        self.cellBlock(cell, object)
        
        return cell
    }
    
}
