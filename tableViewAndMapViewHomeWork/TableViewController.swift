//
//  TableViewController.swift
//  tableViewAndMapViewHomeWork
//
//  Created by Ернат on 19.05.2023.

import UIKit
import MapKit

class TableViewController: UITableViewController {
    
    var arrayPerson:[Person] = []
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Запрашиваем разрешение на использование местоположения пользователя
        locationManager.requestWhenInUseAuthorization()

        arrayPerson.append(Person(name: "almaty rezidence", adressName: "ул. Ауэзова, д. 60, уг.ул Жамбыла,", imageName: "almaty rezidence", longitude: 43.2544, latitude: 76.9558))
        
        arrayPerson.append(Person(name: "bazis", adressName: "ул. Ауэзова, Проспект Аль-Фараби, 19 к2Б", imageName: "bazis", longitude: 43.240655, latitude:  76.915229))
    }
    @IBAction func addPerson(_ sender: Any) {

        arrayPerson.append(Person(name: "new name", adressName: "new adress", imageName: "avatar"))
        
        tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayPerson.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = arrayPerson[indexPath.row].name
        
        let labelAdressNames = cell.viewWithTag(1001) as! UILabel
        labelAdressNames.text = arrayPerson[indexPath.row].adressName
        
        let imageView = cell.viewWithTag(1002) as! UIImageView
        imageView.image = UIImage(named: arrayPerson[indexPath.row].imageName)
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 89
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let datailVC = storyboard?.instantiateViewController(identifier: "datailViewController") as! ViewController
        
        datailVC.person = arrayPerson[indexPath.row]
        
        navigationController?.show(datailVC, sender: nil)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            arrayPerson.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
           
        }    
    }


}
