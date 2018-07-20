//
//  HomeViewController.swift
//  NoteSwift
//
//  Created by ToanDK on 7/20/18.
//  Copyright © 2018 ToanDK. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: BaseViewController {
    let viewModel = HomeViewModel()
    var tableViewBinder: TableViewBinding<NoteModel>!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        LocationManager.sharedManager.askPermission()
        
        addRightMenuButton(title: "Map", target: self, selector: #selector(viewOnMapAction))
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateListNote()
    }
    
    func bindViewModel() {
        tableViewBinder = TableViewBinding(tableView: tableView, sourceSignal: viewModel.listNote.producer, cellName: "NoteTableViewCell")
        tableViewBinder.didSelectRowClosure = { [weak self] item in
            let newVC = NoteDetailViewController(note: item as! NoteModel)
            self?.navigationController?.pushViewController(newVC, animated: true)
        }
    }
    
    @objc func viewOnMapAction() {
        let vModel = MapViewModel()
        vModel.listNote = self.viewModel.listNote.value
        vModel.canShowDetail = true
        let newVC = MapViewController(nibName: "MapViewController", bundle: nil)
        newVC.viewModel = vModel
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    @IBAction func createNoteAction(_ sender: UIButton) {
        let newVC = CreateNoteViewController(nibName: "CreateNoteViewController", bundle: nil)
        self.navigationController?.pushViewController(newVC, animated: true)
    }
}
