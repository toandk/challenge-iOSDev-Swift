//
//  CreateNoteViewController.swift
//  NoteSwift
//
//  Created by ToanDK on 7/20/18.
//  Copyright © 2018 ToanDK. All rights reserved.
//

import Foundation
import ReactiveSwift

class CreateNoteViewController : BaseViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let viewModel = CreateNoteViewModel()
    var recorder: DTRecorder!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var photoScrollView: UIScrollView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New note"
        recorder = DTRecorder(filePath: self.viewModel.audioFilePath)
        addRightMenuButton(title: "Save", target: self, selector: #selector(saveNote))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        bindViewModel()
        addKeyboardTapGesture()
    }
    
    func bindViewModel() {
        textView.reactive.text <~ self.viewModel.note
        loadingView.reactive.isHidden <~ self.viewModel.isLoading.map { !$0 }
        loadingView.reactive.isAnimating <~ self.viewModel.isLoading
        
        textView.reactive.continuousTextValues.observeValues { [weak self] (text) in
            self?.viewModel.note.value = text
        }
        viewModel.note.producer.startWithValues { [weak self] text in
            let saveButton = self?.navigationItem.rightBarButtonItem
            saveButton?.isEnabled = text != nil && text!.count > 0
        }
    }
    
    func startRecording() {
        DTPlayer.sharedPlayer.stopPlaying()
        recorder.startRecording()
    }
    
    func stopRecording() {
        recorder.stopRecording()
    }
    
    func pickPhoto(fromCamera: Bool) {
        let imagePicker = UIImagePickerController()
        
        // Check if image access is authorized
        if (fromCamera && !UIImagePickerController.isSourceTypeAvailable(.camera)) {
            showAlert(title: "Error", message: "This device is not support Camera")
            return
        }
        if (!fromCamera && !UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            showAlert(title: "Error", message: "This device is not support photo library")
            return
        }
        imagePicker.sourceType = fromCamera ? .camera : .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func addImageToView(_ image: UIImage) {
        let imgView = UIImageView(image: image)
        let offsetX = (CGFloat)(self.viewModel.listPhoto.count) * (photoScrollView.frame.size.height + 10)
        imgView.frame = CGRect(x: offsetX, y: 0, width: photoScrollView.frame.size.height, height: photoScrollView.frame.size.height)
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        photoScrollView.addSubview(imgView)
        
        photoScrollView.contentSize = CGSize(width: offsetX + imgView.frame.size.width, height: 0)
    }
    
    func speechToText() {
        self.viewModel.speechToText().start()
    }
    
    @objc func saveNote() {
        _ = self.viewModel.saveData()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func recordAction(_ sender: UIButton) {
        recordButton.isSelected = !recordButton.isSelected;
        playButton.isEnabled = !recordButton.isSelected;
        if (recordButton.isSelected) {
            startRecording()
        }
        else {
            stopRecording()
            speechToText()
        }
    }
    
    @IBAction func playAudioAction(_ sender: UIButton) {
        DTPlayer.sharedPlayer.play(filePath: self.viewModel.audioFilePath)
    }
    
    @IBAction func addMorePhotoAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose photo", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Take photo", style: .default) { [weak self] (action) in
            self?.pickPhoto(fromCamera: true)
        }
        alert.addAction(action1)
        let action2 = UIAlertAction(title: "Choose from library", style: .default) { [weak self] (action) in
            self?.pickPhoto(fromCamera: false)
        }
        alert.addAction(action2)
        
        let action3 = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(action3)
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.addImageToView(image)
            self.viewModel.listPhoto.append(image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
