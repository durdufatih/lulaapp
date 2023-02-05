//
//  ViewController.swift
//  lulaapp
//
//  Created by Mehmet Fatih Durdu on 20.01.2023.
//

import UIKit
import AVFoundation
import GoogleMobileAds
import AudioToolbox


enum AdIds : String {
    /** REPLACE THE VALUES BY YOUR APP AND AD IDS **/
    case appId       = "ca-app-pub-6063592974982071~6379577063" // app id
    case banner      = "ca-app-pub-6063592974982071/6694517237" // test id
    case interstitial       = "ca-app-pub-3940256099942544/4411468910"
    
}
let testDevices = [
    "XX",   //iPhone 5s
    "YY", // iPhone 6
]

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,AVAudioPlayerDelegate, GADFullScreenContentDelegate{

    
    let vModel = LUListenViewModel()
    private var interstitial: GADInterstitialAd!

    
    var customView : UIView = {
        let customView = UIView()
        customView.backgroundColor = UIColor(red: 0.32, green: 0.32, blue: 0.32, alpha: 1.00)
        customView.translatesAutoresizingMaskIntoConstraints=false
        customView.layer.cornerRadius = 8;
        customView.layer.masksToBounds = true;
        return customView
    }()
    var label :UILabel = {
        var uiLabel = UILabel()
        
        uiLabel.textColor = .white
        uiLabel.translatesAutoresizingMaskIntoConstraints = false
        uiLabel.font = UIFont(name: "Arial", size: 16)
        
        return uiLabel
    }()
    
    var startStopButton : UIButton = {
        var button = UIButton()
        button.frame = CGRect(x: 0, y: 0 , width: 40, height: 40)
        button.setImage(UIImage(systemName: "play.circle"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.translatesAutoresizingMaskIntoConstraints=false
        button.imageEdgeInsets = UIEdgeInsets(top: 40,left: 40,bottom: 40,right: 40)
        button.tintColor = .white
        
        return button
        
    }()
    
    let countLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        label.text = "0"
        return label
    }()
    
    let timerLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        label.text = "0:00"
        return label
    }()
    
    var repeatButton : UIButton = {
        var button = UIButton()
        button.frame = CGRect(x: 0, y: 0 , width: 40, height: 40)
        button.setImage(UIImage(systemName: "repeat.circle"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.translatesAutoresizingMaskIntoConstraints=false
        button.imageEdgeInsets = UIEdgeInsets(top: 40,left: 40,bottom: 40,right: 40)
        button.tintColor = .white
        
        return button
        
    }()
    
    var timeButton : UIButton = {
        var button = UIButton()
        button.frame = CGRect(x: 0, y: 0 , width: 40, height: 40)
        button.setImage(UIImage(systemName: "timer.circle"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.translatesAutoresizingMaskIntoConstraints=false
        button.imageEdgeInsets = UIEdgeInsets(top: 40,left: 40,bottom: 40,right: 40)
        button.tintColor = .white
        
        return button
        
    }()
    

    @IBOutlet weak var listCell: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        //listCell.backgroundView = nil;
        listCell.backgroundColor = UIColor.clear;
        listCell.dataSource = self
        listCell.delegate = self
        listCell.reloadData()
        
        
        
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
     func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
       print("Ad did fail to present full screen content.")
         print("Error: \(error.localizedDescription)")
     }

     /// Tells the delegate that the ad will present full screen content.
     func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
       print("Ad will present full screen content.")
         vModel.player.pause()
     }

     /// Tells the delegate that the ad dismissed full screen content.
     func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
       print("Ad did dismiss full screen content.")
         interstitial = nil
         vModel.player.play()
         
     }
    
    
    
    func addBannerViewToView(_ bannerView: GADBannerView,bottomInt:Float) {
       bannerView.translatesAutoresizingMaskIntoConstraints = false
       bannerView.tag = 200
       view.addSubview(bannerView)
        bannerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: CGFloat(bottomInt)).isActive = true
       bannerView.heightAnchor.constraint(equalToConstant: 75).isActive = true
       bannerView.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 10).isActive = true
       bannerView.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: -10).isActive = true
      }
    
    
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        vModel.getCountOfList()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! LUCollectionViewCell
        let item = vModel.getItemByGivenIndex(index: indexPath.row)
        
        cell.lulabyImage.image = UIImage(named: item.image)
        cell.lulabyTitle.text = item.shownName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        vModel.player?.stop()
        let item = vModel.getItemByGivenIndex(index: indexPath.row)
        guard let path = Bundle.main.path(forResource: item.name, ofType:"mp4") else {
           debugPrint("\(item.name) not found")
           return
        }
        
        addCustomView(lulaText: item.shownName)
        vModel.startPlayer(path: path)
        vModel.resetTimeDatas()
        updateTimerLabel()
        countLabel.text = "0"
    }
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        vModel.playPlayerByCheckTimer(flag: flag)
    }
    
    @objc func buttonPlayPauseClicked(button: UIButton)  {
        if vModel.playerPlayingCheck() {
            button.setImage(UIImage(systemName: "stop.circle"), for: .normal)
            vModel.player.pause()
            vModel.clearTimerDataIfIsRunning()
            vModel.resetTimeDatas()
            vModel.setRepeatCount(count: 0)
            updateRepeater()
            updateTimerLabel()
        }
        else{
            button.setImage(UIImage(systemName: "play.circle"), for: .normal)
            vModel.player.play()
        }
        
    }
    
    @objc func buttonTimerClicked(button: UIButton)  {
       
         
        if vModel.rangeIndex % 3 == 0{
            vModel.player.play()
            let request = GADRequest()
            GADInterstitialAd.load(withAdUnitID:AdIds.interstitial.rawValue,
                                   request: request,
                                   completionHandler: { [self] ad, error in
                if let error = error {
                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                    return
                }
                interstitial = ad
                interstitial?.fullScreenContentDelegate = self
            }
            )
            if interstitial != nil {
                let root = UIApplication.shared.windows.first?.rootViewController
                                   self.interstitial.present(fromRootViewController: root!)
            } else {
                print("Ad wasn't ready")
            }
        }
        if vModel.checkRepeatCountIsNotZero(){
            vModel.setRepeatCount(count: 0) 
            updateRepeater()
        }
        vModel.increaseTimeLength()
        updateTimerLabel()
        vModel.setTimer(timerData: Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true))
        
    }
    
    @objc func fireTimer() {
        vModel.decreaseTimer()
        updateTimerLabel()
    }
    
    @objc func buttonRepeatClicked(button: UIButton)  {
        
        if vModel.repeatCount % 3 == 0{
            let request = GADRequest()
            GADInterstitialAd.load(withAdUnitID:AdIds.interstitial.rawValue,request: request,
                completionHandler: { [self] ad, error in
                if let error = error {
                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                    return
                }
                interstitial = ad
                interstitial?.fullScreenContentDelegate = self
            }
            )
           
            if interstitial != nil {
                self.interstitial.present(fromRootViewController: self)
            } else {
                print("Ad wasn't ready")
            }
            vModel.player.play()
        }
        vModel.clearTimerDataIfIsRunning()
        vModel.resetTimeDatas()
        updateTimerLabel()
        
        vModel.repeatCountCheckAtLimitOrIncrease(limit: 10)
        updateRepeater()
    }

    
    func updateTimerLabel (){
        timerLabel.text = vModel.getTimerText()
    }
    
    func updateRepeater(){
        vModel.setNumberOfLoops()
        countLabel.text = "\(vModel.repeatCount)"
    }
    
    
    func addCustomView(lulaText:String){
        self.view.addSubview(customView)
        
        customView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: -25).isActive = true
        customView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        customView.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 5).isActive = true
        customView.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: -5).isActive = true
        self.view.addSubview(label)
        label.text = lulaText
        label.bringSubviewToFront(customView)
        label.topAnchor.constraint(equalTo: customView.topAnchor,constant: 5).isActive = true
        label.centerXAnchor.constraint(equalTo: customView.centerXAnchor).isActive = true
        self.view.addSubview(startStopButton)
        startStopButton.bringSubviewToFront(customView)
        startStopButton.heightAnchor.constraint(equalToConstant: 42).isActive = true
        startStopButton.widthAnchor.constraint(equalToConstant: 42).isActive = true
        startStopButton.topAnchor.constraint(equalTo: self.label.bottomAnchor,constant: 5).isActive = true
        startStopButton.centerXAnchor.constraint(equalTo: customView.centerXAnchor).isActive = true
        
        startStopButton.addTarget(self, action: #selector(buttonPlayPauseClicked), for: .touchUpInside)
        
        self.view.addSubview(repeatButton)
        repeatButton.bringSubviewToFront(customView)
        repeatButton.heightAnchor.constraint(equalToConstant: 42).isActive = true
        repeatButton.widthAnchor.constraint(equalToConstant: 42).isActive = true
        repeatButton.topAnchor.constraint(equalTo: self.label.bottomAnchor,constant: 5).isActive = true
        repeatButton.centerXAnchor.constraint(equalTo: customView.centerXAnchor ,constant: -60).isActive = true
        
        repeatButton.addTarget(self, action: #selector(buttonRepeatClicked), for: .touchUpInside)
        self.repeatButton.addSubview(countLabel)
        countLabel.topAnchor.constraint(equalTo: repeatButton.topAnchor,constant: 0).isActive = true
        countLabel.rightAnchor.constraint(equalTo: repeatButton.rightAnchor,constant:2).isActive = true
        //countLabel.text = String(describing: repeatCount)
        
        self.view.addSubview(timeButton)
        timeButton.bringSubviewToFront(customView)
        timeButton.heightAnchor.constraint(equalToConstant: 42).isActive = true
        timeButton.widthAnchor.constraint(equalToConstant: 42).isActive = true
        timeButton.topAnchor.constraint(equalTo: self.label.bottomAnchor,constant: 5).isActive = true
        timeButton.centerXAnchor.constraint(equalTo: customView.centerXAnchor ,constant: 60).isActive = true
        
        self.timeButton.addSubview(timerLabel)
        timerLabel.topAnchor.constraint(equalTo: timeButton.topAnchor,constant: 0).isActive = true
        timerLabel.rightAnchor.constraint(equalTo: timeButton.rightAnchor,constant:20).isActive = true
        timeButton.addTarget(self, action: #selector(buttonTimerClicked), for: .touchUpInside)
    }

}

