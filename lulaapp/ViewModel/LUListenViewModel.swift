//
//  LUListenViewModel.swift
//  lulaapp
//
//  Created by Mehmet Fatih Durdu on 1.02.2023.
//

import Foundation
import AVFAudio


final class LUListenViewModel{
    
    public var listenData:[ListenModel] = [
        ListenModel(name: "baa-baa-black-sheep", image: "cartoon2", shownName: "Ba Black Sheep"),
        ListenModel(name: "Baby-lullaby-music", image: "cartoon1", shownName: "Baby Lullaby Music"),
        ListenModel(name: "hush-little-baby", image: "cartoon3", shownName: "Hush Little Baby"),
        ListenModel(name: "lavenders-blue", image: "cartoon2", shownName: "Lavenders"),
        ListenModel(name: "mozart-minuet", image: "cartoon1", shownName: "Mozart Minuet"),
        ListenModel(name: "mozart-piano-Sonata", image: "cartoon3", shownName: "Mozart Piano Sonata"),
        ListenModel(name: "mozart-serenade", image: "cartoon2", shownName: "Mozart Serenade"),
        ListenModel(name: "twinkle-twinkle-little-star", image: "cartoon1", shownName: "Twinkle Little Star"),
    ]
    public var rangeOfTime = [0.0,300.0,600.0,900.0,1200.0,1500.0,1800.0,2100.0,2400.0,2700.0,3000.0]
    public var rangeIndex = 0
    public var player: AVAudioPlayer!
    public var repeatCount = 0
    public var timeLenght = 0.0
    public var timer: Timer?
    
    public func getCountOfList() -> Int {
        return listenData.count
    }
    
    
    public func getItemByGivenIndex(index: Int) -> ListenModel {
        return listenData[index]
    }
    
    public func startPlayer(path:String){
        player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
        player.numberOfLoops = 0
        
        player.play()
    }
    
    public func playerPlayingCheck() -> Bool {
        return player.isPlaying && player.duration != 0
    }
    
    public func getRangeByIndex()-> Double{
        return rangeOfTime[rangeIndex]
    }
    
    public func increaseRangeIndex(){
        if rangeIndex + 1 == 10 {
            rangeIndex=0
        }
        else{
            rangeIndex = rangeIndex+1
        }
    }
    
    public func resetTimeDatas(){
        rangeIndex = 0
        timeLenght = rangeOfTime[rangeIndex]
        timer?.invalidate()
        timer = nil
        
    }
    
    
    public func setRepeatCount(count:Int){
        self.repeatCount = count
    }
    
    public func repeatCountCheckAtLimitOrIncrease(limit:Int){
        if repeatCount == limit {
            repeatCount = 0
        }else{
            repeatCount = repeatCount + 1
        }
        
    }
    
    public func setNumberOfLoops(){
        player.numberOfLoops = repeatCount
    }
    
    public func checkRepeatCountIsNotZero() -> Bool{
        return repeatCount != 0
    }
    
    public func increaseTimeLength(){
        increaseRangeIndex()
        timeLenght = rangeOfTime[rangeIndex]
    }
    
    public func checkTimeLengthIsZero()->Bool{
        return timeLenght == 0.0
    }
    
    public func setTimeLength(length:Double){
        timeLenght = length
    }
    
    public func decreaseTimer(){
        timeLenght = timeLenght-1
        if timeLenght != 0 && !playerPlayingCheck(){
            player.play()
        }
        
        if timeLenght == 0 {
            player.stop()
            timer?.invalidate()
            timer = nil
        }
    }
    
    public func playPlayerByCheckTimer(flag:Bool){
        if flag{
            if timer != nil{
                player.play()
            }
        }
    }
    
    public func setTimer(timerData:Timer?){
        timer?.invalidate()
        timer = timerData
    }
    
    public func getTimerText() -> String{
        let minutes = (timeLenght / 60).rounded(.down)
        let seconds = timeLenght.truncatingRemainder(dividingBy: 60).rounded()
        return String(format: "%02.f:%02.f", minutes,seconds)
    }
    
    public func clearTimerDataIfIsRunning(){
        if !checkTimeLengthIsZero(){
            setTimeLength(length: 0.0)
            setTimer(timerData: nil)
        }
    }

}
