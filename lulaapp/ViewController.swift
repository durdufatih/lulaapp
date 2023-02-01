//
//  ViewController.swift
//  lulaapp
//
//  Created by Mehmet Fatih Durdu on 20.01.2023.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,AVAudioPlayerDelegate {

    
    let vModel = LUListenViewModel()

    
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
        }
        else{
            button.setImage(UIImage(systemName: "play.circle"), for: .normal)
            vModel.player.play()
        }
        
    }
    
    @objc func buttonTimerClicked(button: UIButton)  {
       
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
        customView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        customView.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 10).isActive = true
        customView.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: -10).isActive = true
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

