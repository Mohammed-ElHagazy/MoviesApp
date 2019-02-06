//
//  SearchViewController.swift
//  movie
//
//  Created by Muhammad on 12/2/18.
//  Copyright © 2018 Muhammad. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FirebaseAuth

class SearchViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var SearchText: UITextField!
    @IBOutlet var tableview: UITableView!
    weak var delegate: ViewController!
    var searchedMovies: [Movie] = []
    
    @IBAction func search(sender: UIButton){
        let csAllowedURL = CharacterSet(bitmapRepresentation: CharacterSet.urlPathAllowed.bitmapRepresentation)
        var searchTerm = SearchText.text!
            searchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: csAllowedURL)!
        print("Searching for \(searchTerm)")
        if searchTerm.characters.count > 2{
            retriveMovieByTerm(searchTerm: searchTerm)
        }
    }
    @IBAction func addFav(sender: UIButton) {
        print("Item \(sender.tag) are selected as a favorite")
        self.delegate.favoritMovie.append(searchedMovies[sender.tag])
    }
    
    func retriveMovieByTerm(searchTerm: String) {
        var url = "https://www.omdbapi.com/?s=\(searchTerm)&type=movie&r=json&apikey=3c54185d"
        searchedMovies.removeAll()
        Alamofire.request(url).responseData{(resData) -> Void in
            if(resData.result.value != nil){
            let swiftyJsonVar = JSON(resData.result.value!)
                    for item in swiftyJsonVar["Search"].arrayValue {
                        let id = item["imdbID"].stringValue
                        let imageUrl = item["Poster"].stringValue
                        let title = item["Title"].stringValue
                        let year = item["Year"].stringValue
                        
                        let movItem = Movie(id: id,title: title, year: year, imageUrl: imageUrl)
                        print(movItem)
                        print(movItem.id)
                        self.searchedMovies.append(movItem)
                    }
                self.tableview.reloadData()
        }
    }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieCell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
        let idx: Int = indexPath.row
        movieCell.favButton.tag = idx
        movieCell.movieTitle?.text = searchedMovies[idx].title
        movieCell.movieYear?.text = searchedMovies[idx].year
        displayMovieImage(idx, movieCell: movieCell)
        return movieCell
    }
    
    func displayMovieImage(_ row:Int, movieCell: CustomTableViewCell) {
        let url:String = (URL(string: searchedMovies[row].imageUrl)?.absoluteString)!
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error)-> Void in
            if error != nil{
                print(error!)
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data!)
                movieCell.movieImage?.image = image
            }
            }.resume()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Search Results"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func logOutAction(sender: AnyObject) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signIn")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
