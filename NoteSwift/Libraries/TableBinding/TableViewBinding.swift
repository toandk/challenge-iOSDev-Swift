//
//  TableViewBinding.swift
//  NoteSwift
//
//  Created by ToanDK on 7/20/18.
//  Copyright © 2018 ToanDK. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift
import Result

typealias DidSelectRowClosure = (_ item: AnyObject) -> ()

class TableViewBinding<T: AnyObject>: NSObject {
    var tableView: UITableView
    var data: [AnyObject]!
    var sourceSignal: SignalProducer<[T], NoError>
    var cellName: String
    var templateCell: UITableViewCell?
    var dataSource: DataSource!
    
    var didSelectRowClosure: DidSelectRowClosure? {
        didSet {
            self.dataSource.didSelectRowClosure = self.didSelectRowClosure
        }
    }
    
    init(tableView: UITableView, sourceSignal: SignalProducer<[T], NoError>, cellName: String) {
        self.tableView = tableView
        self.sourceSignal = sourceSignal
        self.cellName = cellName
        
        let nib = UINib(nibName: cellName, bundle: nil)
        
        // create an instance of the template cell and register with the table view
        
        let list = nib.instantiate(withOwner: nil, options: nil)
        if list.count > 0 && list[0] is UITableViewCell {
            templateCell = list[0] as? UITableViewCell
            tableView.register(nib, forCellReuseIdentifier: cellName)
            dataSource = DataSource(data: nil, templateCell: templateCell!, cellName: cellName)
        }
        
        super.init()
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        
        _ = sourceSignal.producer.observe(on: UIScheduler()).startWithValues{ [weak self] (list) in
            self?.dataSource.data = list
            self?.tableView.reloadData()
        }
    }
    
}

class DataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    private let templateCell: UITableViewCell
    var data: [AnyObject]?
    var didSelectRowClosure: DidSelectRowClosure?
    var tableHeaderView: UIView?
    var cellName: String
    
    init(data: [AnyObject]?, templateCell: UITableViewCell, cellName: String) {
        self.data = data
        self.templateCell = templateCell
        self.cellName = cellName
        super.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellName),
            let item = data?[indexPath.row],
            let reactiveView = cell as? ReactiveView else {
                return UITableViewCell()
        }
        
        reactiveView.bindViewModel(viewModel: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let nibName = self.cellName
        var appName = NSStringFromClass(DataSource.self)
        appName = appName.components(separatedBy: ".").first!
        let name = appName + "." + nibName
        if let aClass = NSClassFromString(name) as? ReactiveView.Type {
            if aClass.cellHeight != nil {
                let item = data?[indexPath.row]
                return aClass.cellHeight!(viewModel: item)
            }
        }
        
        if let reactiveView = templateCell as? ReactiveView {
            if (reactiveView.cellHeight?() != nil) {
                let item = data?[indexPath.row]
                
                if item == nil {
                    return templateCell.frame.size.height
                }
                
                reactiveView.bindViewModel(viewModel: item!)
                templateCell.bounds = CGRect(x: 0.0, y: 0.0, width: tableView.bounds.size.width, height: templateCell.bounds.size.height)
                return reactiveView.cellHeight!()
            }
            
        }
        return templateCell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let didSelectRowClosure = self.didSelectRowClosure {
            let item = data?[indexPath.row]
            if let item = item {
                didSelectRowClosure(item)
            }
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
