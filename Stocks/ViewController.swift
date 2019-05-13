//
//  ViewController.swift
//  Stocks
//
//  Created by Brian Memmen on 5/11/19.
//  Copyright © 2019 Brian Memmen. All rights reserved.
//

import Cocoa
import Charts
import Foundation
import SwiftyJSON
class ViewController: NSViewController,NSSearchFieldDelegate {
    
    
    @IBOutlet weak var companyLogo: NSImageView!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var search: NSSearchField!
    override func viewDidLoad() {
        super.viewDidLoad()
        stock(stock: "aapl")
        setUpChart()
        
    }
    func stock(stock:String){
        //setUpCompanyInfo(stock: stock)
        setUpLogo(stock:stock)
    }
    func setUpLogo(stock:String){
        let url = "https://api.iextrading.com/1.0/stock/"+stock+"/logo"
        URLSession.shared.dataTask(with: URLRequest(url: URL(string:url)!)){
            (returnData,e,t) in
            do{
                let returnJson = try JSON(data:returnData!)
                do{
                    let url:String = returnJson["url"].string!
                    
                    DispatchQueue.main.async {
                        do{
                            print(url)
                            let urlData = try? Data(contentsOf:URL(string: "https://storage.googleapis.com/iex/api/logos/UBER.png")!)
                            self.companyLogo.image = NSImage(data: urlData! )
                        }catch{
                            print("error setting up image")
                        }
                    }
                }catch{}
                
            }catch{
                print("error getting company logo")
            }
        }.resume()
    }
    func setUpCompanyInfo(stock:String){
        let url = "https://api.iextrading.com/1.0/stock/"+stock+"/company"
        URLSession.shared.dataTask(with: URLRequest(url: URL(string:url)!)){
            (returnData,e,t) in
            do{
                let returnJson = try JSON(data:returnData!)
                
            }catch{
                print("error getting company info")
            }
        }.resume()
    }
    @IBAction func searchStocks(_ sender: Any) {
        print(search.stringValue)
    }
    func setUpChart(){
        // Do any additional setup after loading the view.
        let ys1 = Array(1..<10).map { x in return sin(Double(x) / 2.0 / 3.141 * 1.5) }
        let ys2 = Array(1..<10).map { x in return cos(Double(x) / 2.0 / 3.141) }
        
        let yse1 = ys1.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: y) }
        let yse2 = ys2.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: y) }
        
        let data = LineChartData()
        let ds1 = LineChartDataSet(entries: yse1, label: "Hello")
        ds1.colors = [NSUIColor.red]
        data.addDataSet(ds1)
        
        let ds2 = LineChartDataSet(entries: yse2, label: "World")
        ds2.colors = [NSUIColor.blue]
        data.addDataSet(ds2)
        self.lineChartView.data = data
        
        self.lineChartView.gridBackgroundColor = NSUIColor.white
        
        self.lineChartView.chartDescription?.text = "Linechart Demo"
    }
    func JSONParseArray(string: String) -> [AnyObject]{
        if let data = string.data(using: String.Encoding.utf8){
            
            do{
                
                if let array = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)  as? [AnyObject] {
                    return array
                }
            }catch{
                
                print("error")
                //handle errors here
                
            }
        }
        return [AnyObject]()
    }
}

