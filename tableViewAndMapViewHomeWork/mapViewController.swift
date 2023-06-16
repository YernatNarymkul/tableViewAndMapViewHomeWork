//
//  mapViewController.swift
//  tableViewAndMapViewHomeWork
//
//  Created by Ернат on 19.05.2023.
//


import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapview: MKMapView!
    
    var person = Person()
    
    let locationManager = CLLocationManager()
    
    var userLocation = CLLocation()
    
    var isDirectionCalculated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapview.delegate = self
        
        // delegate нужен для функции didUpdateLocations, которая вызывается при обновлении местоположения (для этого прописали CLLocationManagerDelegate выше)
        locationManager.delegate = self
        
        // Запускаем слежку за пользователем
        locationManager.startUpdatingLocation()
        
        // Do any additional setup after loading the view.
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
        //anotation.subtitle = person.address
        
        // Добавляем метку на карту
        mapview.addAnnotation(anotation)
        
        // Дельта - насколько отдалиться от координат пользователя по долготе и широте
        let latDelta:CLLocationDegrees = 0.01
        let longDelta:CLLocationDegrees = 0.01
        
        // Создаем область шириной и высотой по дельте
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        
        // Создаем регион на карте с моими координатоми в центре
        let region = MKCoordinateRegion(center: location, span: span)
        
        // Приближаем карту с анимацией в данный регион
        mapview.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // Настраиваем линию
        let renderer = MKPolylineRenderer(overlay: overlay)
        // Цвет красный
        renderer.strokeColor = UIColor.blue
        // Ширина линии
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    // Вызывается каждый раз при изменении местоположения нашего пользователя
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        userLocation = locations[0]
        
        if !isDirectionCalculated {
            showDirection()
            isDirectionCalculated = true
        }
    }
    
    func showDirection() {
        
        // Новые координаты для метки на карте
        let lat:CLLocationDegrees = person.latitude
        let long:CLLocationDegrees = person.longitude
        
        // Routing - построение маршрута
        // 1 Координаты начальной точки А и точки B
        let sourceLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        let destinationLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        // 2 упаковка в Placemark
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        // 3 упаковка в MapItem
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // 4 Запрос на построение маршрута
        let directionRequest = MKDirections.Request()
        // указываем точку А, то есть нашего пользователя
        directionRequest.source = sourceMapItem
        // указываем точку B, то есть метку на карте
        directionRequest.destination = destinationMapItem
        // выбираем на чем будем ехать - на машине
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        // 5 Запускаем просчет маршрута
        directions.calculate {
            (response, error) -> Void in
            
            // Если будет ошибка с маршрутом
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            // Берем первый машрут
            let route = response.routes[0]
            // Рисуем на карте линию маршрута (polyline)
            self.mapview.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            // Приближаем карту с анимацией в регион всего маршрута
            let rect = route.polyline.boundingMapRect
            self.mapview.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    
}
