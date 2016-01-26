//
//  ViewController.swift
//  avontell.com Blog Editor
//
//  Created by Aaron on 1/19/16.
//  Copyright © 2016 avontell.com. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    //MARK: Views
    @IBOutlet var titleField: NSTextField!
    @IBOutlet var subtitleField: NSTextField!
    @IBOutlet var classField: NSTextField!
    @IBOutlet var tagsField: NSTextField!
    @IBOutlet var authorField: NSTextField!
    @IBOutlet var authorUrlField: NSTextField!
    @IBOutlet var contentField: NSTextField!
    @IBOutlet var datePicker: NSDatePicker!
    @IBOutlet var statusLabel: NSTextField!
    
    //MARK: Overridden functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        datePicker.dateValue = NSDate()
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    //MARK: Custom functions
    @IBAction func onSubmit(sender: AnyObject) {
        
        self.statusLabel.stringValue = "Submitting post...";
        
        // Parse tags
        let tagsText = self.tagsField.stringValue.stringByReplacingOccurrencesOfString(" ", withString: "");
        let tagsArray = tagsText.componentsSeparatedByString(",");
        
        // Parse content
        let contentText = self.contentField.stringValue;
        //var contextText = contentText.stringByReplacingOccurrencesOfString("\", withString: "\'");
        
        //Parse date
        let date = datePicker.dateValue;
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        let dateText = "\(month)/\(day)/\(year)";
        
        //Send data
        
        var fields: [String] = ["title", "subtitle", "class", "author", "authorurl", "date", "tags", "content"];
        
        var data = fields[0] + "=" + titleField.stringValue + "&" + fields[1] + "=" + subtitleField.stringValue + "&";
        data += fields[2] + "=" + classField.stringValue + "&" + fields[3] + "=" + authorField.stringValue + "&";
        data += fields[4] + "=" + authorUrlField.stringValue + "&" + fields[5] + "=";
        data += dateText + "&";
        data += fields[6] + "=" + tagsArray.description;
        data += "&" + fields[7] + "=" + contentText;
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://www.avontell.com/api/posts/")!)
        request.HTTPMethod = "POST"
        let postString = data;
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding);
            if(responseString!.containsString("true")){
                self.statusLabel.stringValue = "Post submitted successfully!";
            }
            else{
                self.statusLabel.stringValue = "Post was not submitted: \(responseString)";
            };
            print("responseString = \(responseString)")
        }
        task.resume()
        
    }
    
    func loadPreviousPosts() {
        
        
        
    }
    


}

