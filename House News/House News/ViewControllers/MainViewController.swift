//
//  MainViewController.swift
//  House News
//
//  Created by Joseph Min on 6/17/16.
//
//

import UIKit

class MainViewController: TemplateViewController, NSXMLParserDelegate {
    
    var xmlParser: NSXMLParser!
    var zwsid = "X1-ZWz1fbpriem497_47pen";
    var addressTextField: TextField!
    var cityTextField: TextField!
    var stateTextField: TextField!
    var houseImageView: UIImageView!
    var housePriceTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Address
        addressTextField = TextField(frame: CGRect(x: 40, y: 110, width: 140, height: 30))
        addressTextField.placeholder = "Address"
        self.view.addSubview(addressTextField)
        
        // City
        cityTextField = TextField(frame: CGRect(x: addressTextField.frame.maxX + 5, y: addressTextField.frame.minY, width: 70, height: addressTextField.frame.height))
        cityTextField.placeholder = "City"
        self.view.addSubview(cityTextField)
        
        // State
        stateTextField = TextField(frame: CGRect(x: cityTextField.frame.maxX + 5, y: addressTextField.frame.minY, width: 70, height: addressTextField.frame.height))
        stateTextField.placeholder = "State"
        self.view.addSubview(stateTextField)
        
        // House Image
        let imageName = "hamster.jpg"
        let image = UIImage(named: imageName)
        houseImageView = UIImageView(image: image!)
        let scale = (image!.size.width)/(self.view.frame.width - 2*(addressTextField.frame.minX))
        houseImageView.frame = CGRect(x: addressTextField.frame.minX, y: addressTextField.frame.maxY + 20, width: image!.size.width/scale, height: image!.size.height/scale)
        self.view.addSubview(houseImageView)
        
        // Search Button
        let searchButton = UIButton(type: UIButtonType.System) as UIButton
        searchButton.frame = CGRectMake((self.view.frame.width - 100)/2, houseImageView.frame.maxY + 30, 100, 30)
        searchButton.setTitle("Search", forState: UIControlState.Normal)
        searchButton.addTarget(self, action: #selector(findHouse), forControlEvents: .TouchUpInside)
        self.view.addSubview(searchButton)
        
        // Price
        housePriceTextView = UITextView(frame: CGRect(x: (self.view.frame.width - 100)/2, y: searchButton.frame.maxY + 50, width: 100, height: 30))
        housePriceTextView.textAlignment = .Center
        self.view.addSubview(housePriceTextView)
        
//        let address = "2+Hawthorne+Pl&citystatezip=Boston%2C+MA"
//        getPropertyInfo(address)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func findHouse(sender: UIButton!) {
        let address = self.addressTextField.text!
        let city = self.cityTextField.text!
        let state = self.stateTextField.text!
        let formatedAddress = formatAddress(address, city: city, state: state);
        getPropertyInfo(formatedAddress)
    }
    
    func formatAddress(address: String, city: String, state: String) -> String {
        var formatedAddress = ""
        var addressArr = address.characters.split{$0 == " "}.map(String.init)
        if addressArr.count > 0 {
            formatedAddress.appendContentsOf(addressArr[0])
            for i in 1...(addressArr.count-1) {
                formatedAddress.appendContentsOf("+")
                formatedAddress.appendContentsOf(addressArr[i])
            }
        }
        formatedAddress.appendContentsOf("&citystatezip=")
        formatedAddress.appendContentsOf(city)
        formatedAddress.appendContentsOf("%2C+")
        formatedAddress.appendContentsOf(state)
        return formatedAddress;
    }
    
    func getPropertyInfo(address: String) {
        let url_string = "http://www.zillow.com/webservice/GetDeepSearchResults.htm?zws-id=\(zwsid)&address=\(address)"
//        print(url_string)
        let url = NSURL(string: url_string)!
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            
            if (error == nil) {
                let dataString = String(data: data!, encoding: NSUTF8StringEncoding)
                let xmldict = XMLDictionaryParser.init()
                let dict:NSDictionary = xmldict.dictionaryWithString(dataString)
//                print(dict["response"])
//                self.housePriceTextView.text = "$2500"
//                self.housePriceTextView.text = String(((((dict["response"]!)["results"]!)!["result"]!)![0]["lastSoldPrice"]!)!["__text"])
                dispatch_async(dispatch_get_main_queue(), {
                    let price:NSDictionary = dict["response"]?["results"] as! NSDictionary
                    print(price)
                    let zestimate:NSDictionary = price["result"]?["zestimate"] as! NSDictionary
                    print(zestimate)
                    self.housePriceTextView.text = "$" + (zestimate["amount"]?["__text"] as! String)
                })
                
            }
        }
        task.resume()
        
    }
}