//
//  NoteDetailViewController.swift
//  NoteSwift
//
//  Created by ToanDK on 7/20/18.
//  Copyright © 2018 ToanDK. All rights reserved.
//

import Foundation
import UIKit

class NoteDetailViewController: BaseViewController {
    var note: NoteModel!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var photoScrollView: UIScrollView!
    
    init(note: NoteModel) {
        super.init(nibName: "NoteDetailViewController", bundle: nil)
        self.note = note
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.title = "Note detail"
        setupUI()
    }
    
    func setupUI() {
        noteLabel.text = note.text
        for i in 0..<note.listPhoto.count {
            let filePath = FileHelper.filePath(name: note.listPhoto[i].fileName)
            let imgView = UIImageView(image: UIImage(contentsOfFile: filePath))
            let offsetX: CGFloat = (CGFloat)(i) * (photoScrollView.frame.size.height + 10)
            imgView.frame = CGRect(x: offsetX, y: 0.0, width: photoScrollView.frame.size.height, height: photoScrollView.frame.size.height)
            imgView.contentMode = .scaleAspectFill
            imgView.clipsToBounds = true
            photoScrollView.addSubview(imgView)
        }
        photoScrollView.contentSize = CGSize(width: (CGFloat)(note.listPhoto.count) * (photoScrollView.frame.size.height + 10), height: 0)
    }
    
    @IBAction func playAudioAction(_ sender: UIButton) {
        DTPlayer.sharedPlayer.play(filePath: note.getAudioFilePath())
    }
    
    @IBAction func viewOnMapAction(_ sender: UIButton) {
        let vModel = MapViewModel()
        vModel.listNote = [note]
        vModel.canShowDetail = false
        let newVC = MapViewController(nibName: "MapViewController", bundle: nil)
        newVC.viewModel = vModel
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        let fileUrl = URL(fileURLWithPath: note.getAudioFilePath())
        var activityItems: [Any] = [note.text, fileUrl]
        for i in 0..<note.listPhoto.count {
            let photoPath = FileHelper.filePath(name: note.listPhoto[i].fileName)
            if let image = UIImage(contentsOfFile: photoPath) {
                activityItems.append(image)
            }
        }
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
}
