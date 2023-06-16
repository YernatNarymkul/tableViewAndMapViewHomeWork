//
//  ViewController.swift
//  tableViewAndMapViewHomeWork
//
//  Created by Ернат on 19.05.2023.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelAdress: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var person = Person()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelName.text = person.name
        labelAdress.text = person.adressName
        imageView.image = UIImage(named: person.imageName)
        
        // Новые координаты для метки на карте
        let lat:CLLocationDegrees = person.latitude
        let long:CLLocationDegrees = person.longitude
        
        // Создаем координта передавая долготу и широту
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
        
        // Создаем метку на карте
        let anotation = MKPointAnnotation()
        
        // Задаем коортинаты метке
        anotation.coordinate = location
        // Задаем название метке
        anotation.title = person.name
        // Задаем описание метке
        anotation.subtitle = person.adressName
        
        // Добавляем метку на карту
        mapView.addAnnotation(anotation)
        
        // Дельта - насколько отдалиться от координат пользователя по долготе и широте
        let latDelta:CLLocationDegrees = 0.01
        let longDelta:CLLocationDegrees = 0.01
        
        // Создаем область шириной и высотой по дельте
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        
        // Создаем регион на карте с моими координатоми в центре
        let region = MKCoordinateRegion(center: location, span: span)
        
        // Приближаем карту с анимацией в данный регион
        mapView.setRegion(region, animated: true)
    }

    @IBAction func openMap(_ sender: Any) {
        let datailVC = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        
        datailVC.person = person
        
        navigationController?.show(datailVC, sender: self)
    }
   
}


