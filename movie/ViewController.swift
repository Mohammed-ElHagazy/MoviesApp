//
//  ViewController.swift
//  movie
//
//  Created by Muhammad on 12/1/18.
//  Copyright © 2018 Muhammad. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var mainTableView:UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritMovie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieCell = tableView.dequeueReusableCell(withIdentifier: "mainCustomCell", for: indexPath) as! CustomTableViewCell
        let idx: Int = indexPath.row
        movieCell.RemoveButton.tag = idx
        movieCell.movieTitle?.text = favoritMovie[idx].title
        movieCell.movieYear?.text = favoritMovie[idx].year
        displayMovieImage(idx, movieCell: movieCell)
        
        return movieCell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchMovieSegue"{
            let controller = segue.destination as! SearchViewController
            controller.delegate = self
        }
    }
    
    func displayMovieImage(_ row:Int, movieCell: CustomTableViewCell) {
            let url:String = (URL(string: favoritMovie[row].imageUrl)?.absoluteString)!
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
    var favoritMovie: [Movie] = []
    
    @IBAction func RemoveFromFavList(sender: UIButton) {
        favoritMovie.remove(at: sender.tag)
        mainTableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        mainTableView.reloadData()
        if favoritMovie.count == 0
        {
            let defaultURL = "https://www.omdbapi.com/?s=ice%20age&type=movie&r=json&apikey=3c54185d"
            Alamofire.request(defaultURL).responseData{(resData) -> Void in
                    if(resData.result.value != nil){
                        let swiftJsonVar = JSON(resData.result.value!)
                        for item in swiftJsonVar["Search"].arrayValue
                        {
                            let id = item["imdbID"].stringValue
                            let imageUrl = item["Poster"].stringValue
                            let title = item["Title"].stringValue
                            let year = item["Year"].stringValue
                            let movItem = Movie(id: id,title: title, year: year, imageUrl: imageUrl)
                            self.favoritMovie.append(movItem)
                        }
                        print(self.favoritMovie.count)
                        self.mainTableView.reloadData()
                    }else{
                        
                }
                }
            }
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

}

