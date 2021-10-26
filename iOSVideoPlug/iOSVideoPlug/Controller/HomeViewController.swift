//
//  HomeViewController.swift
//  iOSVideoPlug
//
//  Created by Rahul Panzade on 02/04/19.
//  Copyright © 2019 Omni-Bridge. All rights reserved.
//

import UIKit
import Alamofire


class HomeViewController: HomeClass {
    
    // MARK:- Variables and Outlets
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var btnForAddNewVideo: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner : UIActivityIndicatorView!
    
    var isServerHasMoreDataToFetch = true
    
    // MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        baseSearchBar = searchBar
        baseTableView = tableView
        baseSpinner = spinner
        setShadowToAddNewVideoButton(button: self.btnForAddNewVideo)
        //self.segmentController.addUnderlineForSelectedSegment()
        hideKeyboardWhenTappedAround()
        initNoResultFoundView(vc: self, frame: tableView.frame)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Generals.isConnectedToNetwork() {
            uploadedVideoArray.removeAll()
            filteredUploadedVideoArray.removeAll()
            tableView.reloadData()
            fetchVideoAPI(skip: 0)
        }else{
            stopSpinner()
            Generals.presentAlert(title: NOINTERNET_TITLE, msg: NOINTERNET_MESSAGE, VC: self)
        }
    }
    
    /// Used to fet video details from server
    ///
    /// - Parameter skip: skip count
    func fetchVideoAPI(skip : Int){
        startSpinner()
        getUploadedVideoDataFromServer(skip: skip) { (dataDict) in
            let videoDataArray = dataDict.value(forKey: "data") as? NSArray ?? NSArray()
            if videoDataArray.count == 0{
                self.stopSpinner()
                self.isServerHasMoreDataToFetch = false
                return
            }
            for videoData in videoDataArray {
                //print(videoData)
                self.uploadedVideoArray.append(VideoDetails(videoData as! [String : Any]))
            }
            self.stopSpinner()
            self.isServerHasMoreDataToFetch = true
            self.tableView.reloadData()
        }
    }
    
    // MARK:- Button action methods
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        sender.changeUnderlinePosition()
    }
    
    @IBAction func addNewVideoPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "AddNewVideoSegue", sender: self)
    }
    
    @objc func downloadPressed(_ sender : UIDownloadProgressButton){
        if Generals.isConnectedToNetwork(){
            if uploadedVideoArray[sender.tag].isDownloading{
                Generals.presentAlert(title: WARNING_TITLE, msg: DOWNLOADING_IN_PROGRESS, VC: self)
                return
            }else{
                uploadedVideoArray[sender.tag].isDownloading = true
            }
            downloadVideo(with: uploadedVideoArray[sender.tag].strVideoUrl, cell: tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! TableViewCellForVideoDetails)
        }else{
            Generals.presentAlert(title: NOINTERNET_TITLE, msg: NOINTERNET_MESSAGE, VC: self)
        }
    }
    
    // MARK:- Segue action
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        backItem.tintColor = UIColor.black
        navigationItem.backBarButtonItem = backItem
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if checkSearchBarStatusActive() {
            return filteredUploadedVideoArray.count
        }
        return uploadedVideoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == uploadedVideoArray.count - 1 && isServerHasMoreDataToFetch {
            self.fetchVideoAPI(skip: uploadedVideoArray.count)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! TableViewCellForVideoDetails
        cell.btnForVideoProgress.tag = indexPath.row
        cell.btnForVideoProgress.addTarget(self, action: #selector(downloadPressed(_:)), for: UIControl.Event.touchUpInside)
        if checkSearchBarStatusActive(){
            cell.configure(videoModel: filteredUploadedVideoArray[indexPath.row])
        }else{
            cell.configure(videoModel: uploadedVideoArray[indexPath.row])
        }
        cell.imgViewForVideo.contentMode = .scaleAspectFit
        
//        let image = cell.imgViewForVideo.image!
//        //cell.imgViewForVideo.image = nil
//        cell.imgViewForVideo.image = image.combineWith(image: UIImage(named: "play")!)
        
//        if cell.imgViewForVideo.image?.pngData(). {
//            print(",mnbvc")
//        }
        
//        if cell.imgViewForVideo.image?.jpegData(compressionQuality: 1) != UIImage(named: "play")!.jpegData(compressionQuality: 1) {
//            let image = cell.imgViewForVideo.image!
//            cell.imgViewForVideo.image = nil
//            cell.imgViewForVideo.image = image.combineWith(image: UIImage(named: "play")!)
//        }
        
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchBar.text = ""
        if Generals.isConnectedToNetwork(){
            if checkSearchBarStatusActive(){
                playVideo(url:filteredUploadedVideoArray[indexPath.row].strVideoUrl)
            }else{
                playVideo(url:uploadedVideoArray[indexPath.row].strVideoUrl)
            }
        }else{
            Generals.presentAlert(title: NOINTERNET_TITLE, msg: NOINTERNET_MESSAGE, VC: self)
        }
    }
}


