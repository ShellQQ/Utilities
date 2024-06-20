//
//  TestMapDistanceViewController.swift
//  SCRM2
//
//  Created by D02020015 on 2021/2/23.
//  Copyright © 2021 DEI. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var fileURL: URL = URL(fileURLWithPath: "")

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var dropDownView: DropDownView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    private var mapOverlay: MKPolyline?
    private var mapPoints: [CLLocationCoordinate2D] = []
    
    private var mapOverlays: [MKPolyline] = []
    private var mapPointList: [[CLLocationCoordinate2D]] = []
    private var lineColors: [UIColor] = []
    
    private var keyList: [String] = []
    //private var key = Date().toDateString()
    private var key = "2021-06-08"
    private var index = 0
    private var isRegion = true
    private var infoList: [Distance_Info]? {
        return LocationManager.distanceDic[key]
    }
    private var info: Distance_Info? {
        guard let info = infoList?[index] else {
            return nil
        }
        return info
    }
    
    private var infoListNum: Int {
        if let infoList = infoList {
            return infoList.count
        }
        return 0
    }
    
    private var myAnn = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //createFolder(folderName: "Log")
        loadLocalDistanceDic(fileURL: fileURL, p: &LocationManager.distanceDic)
        print(LocationManager.distanceDic)
//        for info in LocationManager.distanceDic {
//            print("info \(info.key)")
//        }
        
        
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        print("is scroll \(mapView.isScrollEnabled)")
        print("is pitch \(mapView.isPitchEnabled)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setUserLocationAnnotation()
        setDropDownView()
        eachSecond()
        reloadTable()
        
    }
    
    func setDropDownView() {
        dropDownView.delegate = self
        
        keyList = LocationManager.distanceDic.map{ $0.key }.sorted{ $0 > $1 }
        
        dropDownView.dropDownList = keyList
        if keyList.count > 0 {
            dropDownView.index = 0
            key = keyList[0]
        }
    }
    
    func reloadTable() {
        if let infoList = infoList, infoList.count > 0 {
            tableView.reloadData()
            tableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .middle)
            tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: true)
        }
    }
    
    func eachSecond() {
        //seconds += 1
        updateDisplay()
        //updateMapOverlay()
        updateAllDayMapOverlay()
    }
    
    func updateDisplay() {
        //var displayText = ""
        
        if let allDayInfo = infoList {
            var totalDistance = 0.0
            for info in allDayInfo {
                totalDistance += info.distance
            }
            
            let distance = Double(lround(totalDistance))
            distanceLabel.text = "\(key)距離 : \(distance) M / \(distance / 1000) KM"
        }
        
//        if let info = info {
//            let distance = Double(lround(info.distance))
//            distanceLabel.text = "  距離 : \(distance) M"
//        }
    }
    
    func updateAllDayMapOverlay() {
        mapView.removeOverlays(mapOverlays)
        mapView.removeAnnotations(mapView.annotations)
        lineColors.removeAll()
        mapPointList.removeAll()
        mapOverlays.removeAll()
        
        guard let allDayInfo = infoList else { return }
        
        for info in allDayInfo {
            var points = [CLLocationCoordinate2D]()
            for coord in info.locationList {
                points.append(CLLocationCoordinate2D(latitude: coord.lat, longitude: coord.lng))
            }
           
            let polyLine = MKPolyline(coordinates: points, count: points.count)
            polyLine.title = "\(mapOverlays.count)"
            
            if index == mapOverlays.count, points.count > 0 {
                if let startCoord = points.first {
                    let startAnn = MKPointAnnotation()
                    startAnn.coordinate = CLLocationCoordinate2D(latitude: startCoord.latitude, longitude: startCoord.longitude)
                    startAnn.title = String("start")
                    mapView.addAnnotation(startAnn)
                    mapView.selectAnnotation(startAnn, animated: true)
                }
                if let endCoord = points.last {
                    let endAnn = MKPointAnnotation()
                    endAnn.coordinate = CLLocationCoordinate2D(latitude: endCoord.latitude, longitude: endCoord.longitude)
                    endAnn.title = String("end")
                    mapView.addAnnotation(endAnn)
                }
            }
            
            mapView.addOverlay(polyLine)

            lineColors.append(UIColor().randomColor())
            mapPointList.append(points)
            mapOverlays.append(polyLine)
        }
        
        if let lastLocation = mapPointList.last?.last {
            myAnn.coordinate = lastLocation
            
            if isRegion {
                let region = MKCoordinateRegion(center: lastLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
                mapView.setRegion(region, animated: true)
                mapView.setCenter(myAnn.coordinate, animated: false)
                isRegion = false
            }
        }
        
    }
    
    func updateMapOverlay() {
        mapPoints.removeAll()
        print("更新路徑")
        if let info = info {
            for coordinate in info.locationList {
             mapPoints.append(CLLocationCoordinate2D(latitude: coordinate.lat, longitude: coordinate.lng))
                //print("  -----座標 \(coordinate.lat), \(coordinate.lng)")
            }
        }
        if let _ = mapOverlay {
            mapView.removeOverlay(mapOverlay!)
        }
        mapOverlay = MKPolyline(coordinates: mapPoints, count: mapPoints.count)
        mapView.addOverlay(mapOverlay!)
        
        if let lastLocation = mapPoints.last {
            let region = MKCoordinateRegion(center: lastLocation, latitudinalMeters: 500, longitudinalMeters: 500)
            myAnn.coordinate = lastLocation
            mapView.setCenter(myAnn.coordinate, animated: false)
            mapView.setRegion(region, animated: true)
        }
    }
    
    // 設定使用者位置大頭針
    func setUserLocationAnnotation() {
        if let coordinate = mapView.userLocation.location?.coordinate{
            //myAnn = MKPointAnnotation()
            myAnn.coordinate = coordinate
            
            mapView.addAnnotation(myAnn)
            mapView.selectAnnotation(myAnn, animated: false)
            mapView.setCenter(myAnn.coordinate, animated: true)
            
            let region = MKCoordinateRegion(center: myAnn.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: false)
            //setMapRegion(mapView: mapView, coordinate: myAnn.coordinate, delta: 0.05)
            print("使用者位置 設定完畢")
            //selectedAnnotation = myAnn
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinAnnotationView: MKMarkerAnnotationView
        
        if annotation is MKUserLocation { return nil }      //使用者位置return nil，顯示藍色圈圈
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView{
            dequeuedView.annotation = annotation
            pinAnnotationView = dequeuedView
        }
        
        else {
            pinAnnotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        
        if annotation.title == "start" {
            pinAnnotationView.glyphImage = UIImage(named: "footprint")
            pinAnnotationView.markerTintColor = .systemGreen
        }
        else if annotation.title == "end" {
            pinAnnotationView.glyphImage = UIImage(named: "flag")
            pinAnnotationView.markerTintColor = .red
        }
        
        pinAnnotationView.isDraggable = false
        
        return pinAnnotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
       
        if let selIndex = Int(polyline.title ?? "0"), selIndex == index {
            print("選擇路徑")
            renderer.strokeColor = .red
            renderer.lineWidth = 8
        } else {
            renderer.strokeColor = .yellow
            renderer.lineWidth = 3
        }
        
        return renderer
    }
}

extension MapViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("table list 個數 \(infoListNum) \(key)")
        return infoListNum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "route")
        if let infoList = infoList {
            let info = infoList[indexPath.row]
            let distance = Double(lround(info.distance))    // 四捨五入
            
            cell.textLabel?.text = info.start_hour.toDateTimeString()
            cell.detailTextLabel?.text = "\(distance) M (\(distance/1000) KM)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        print("select index \(index)")
        eachSecond()
    }
}

extension MapViewController: DropDownViewDelegate {
    func dropDownView(view: UIView, selectItem item: String, selectIndex index: Int) {
        print("drop down 按下 \(item) \(index)")
        isRegion = true
        self.key = item
        self.index = 0
        eachSecond()
        tableView.reloadData()
    }
}
