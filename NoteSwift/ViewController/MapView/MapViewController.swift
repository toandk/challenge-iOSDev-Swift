//
//  MapViewController.swift
//  NoteSwift
//
//  Created by ToanDK on 7/20/18.
//  Copyright © 2018 ToanDK. All rights reserved.
//

import Foundation
import GoogleMaps

class MapViewController: BaseViewController, GMSMapViewDelegate {
    var viewModel: MapViewModel!
    
    @IBOutlet weak var myMapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Map"
        
        myMapView.delegate = self
        drawMap()
    }
    
    func centerMap(coordinate: CLLocationCoordinate2D) {
        if (coordinate.latitude == 0 && coordinate.longitude == 0) {
            return
        }
        myMapView.camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: AppConstants.DEFAULT_ZOOM_FACTOR)
    }
    
    func drawMap() {
        myMapView.clear()
        var bounds = GMSCoordinateBounds()
        for i in 0..<self.viewModel.listNote.count {
            let note = viewModel.listNote[i]
            let location = CLLocationCoordinate2DMake(note.latitude, note.longitude)
            let marker = GMSMarker(position: location)
            marker.title = note.text
            marker.map = myMapView
            marker.userData = i
            bounds = bounds.includingCoordinate(marker.position)
        }
        myMapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if self.viewModel.canShowDetail {
            if let index = marker.userData as? Int {
                let note = self.viewModel.listNote[index]
                let newVC = NoteDetailViewController(note: note)
                self.navigationController?.pushViewController(newVC, animated: true)
            }
        }
    }
}
