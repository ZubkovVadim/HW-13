//
//  ViewController.swift
//  AVFoundation_Audio
//
//  Created by Niki Pavlove on 18.02.2021.
//

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    var names = [
        "TestVideo1",
        "TestVideo2",
        "TestVideo3"
    ]
    
    private lazy var streamURL1 =
        URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_adv_example_hevc/master.m3u8")!
    
    private lazy var streamURL2 = URL(string: "https://devstreaming-cdn.apple.com/videos/wwdc/2021/10183/5/C850E07A-1E66-4641-9742-DE0DE2E3E29B/cmaf.m3u8")!
    
    private lazy var streamURL3 = URL(string: "https://devstreaming-cdn.apple.com/videos/wwdc/2021/10308/18/BA664ADF-042F-4084-8565-61FC83578C92/cmaf.m3u8")!
    
   
    lazy var arrayURL: [URL] = [streamURL1, streamURL2, streamURL3]

    var player = AVAudioPlayer()
    var toggleState = 1
    var songs:[String] = ["Queen", "Ed Sheeran", "The Beatles", "Coldplay", "Nirvana"]
    var thisSong = 0
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var playBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        nameLabel.text = songs [thisSong]
        do {
            player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Queen", ofType: "mp3")!))
            player.prepareToPlay()
        }
        catch {
            print(error)
        }
        
        
    }
    @IBAction func playButton(_ sender: AnyObject) {
        if toggleState == 1 {
            player.play()
            toggleState = 2
            playBtn.setImage(UIImage(systemName:"pause.fill"),for: .normal)
        } else {
            player.pause()
            toggleState = 1
            playBtn.setImage(UIImage(systemName:"play.fill"),for: .normal)
        }
    }
    
    
    @IBAction func stopButton(_ sender: Any) {
        player.stop()
        player.currentTime = 0
        toggleState = 1
        playBtn.setImage(UIImage(systemName:"play.fill"),for: .normal)
    }
    
    @IBAction func nextButton(_ sender: Any) {
        if thisSong < songs.count-1  {
            next(thisOne: songs[thisSong+1])
            nameLabel.text = songs [thisSong]
            player.play()
            playBtn.setImage(UIImage(systemName:"pause.fill"),for: .normal)
        }
        else {
            next(thisOne: songs[0])
            thisSong = 0
            nameLabel.text = songs [thisSong]
            player.play()
            playBtn.setImage(UIImage(systemName:"pause.fill"),for: .normal)
        }
    }
    @IBAction func prevButton(_ sender: Any) {
        if thisSong == 0 {
            prev(thisOne: songs[4])
            thisSong = 4
            nameLabel.text = songs [thisSong]
            player.play()
            playBtn.setImage(UIImage(systemName:"pause.fill"),for: .normal)
        }
        else {
            prev(thisOne: songs[thisSong-1])
            nameLabel.text = songs [thisSong]
            player.play()
            playBtn.setImage(UIImage(systemName:"pause.fill"),for: .normal)
        }
    }
    
    func next(thisOne: String){
        do {
            player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: thisOne, ofType: "mp3")!))
            thisSong += 1
            player.prepareToPlay()
        }
        catch {
            print(error)
        }
    }
    func prev(thisOne: String) {
        do {
            player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: thisOne, ofType: "mp3")!))
            thisSong -= 1
            player.prepareToPlay()
        }
        catch {
            print(error)
        }
    }
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let player = AVPlayer(url: arrayURL[indexPath.row])
        let controller = AVPlayerViewController()
        controller.player = player
        present(controller, animated: true) {
            player.play()
        }
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }
}



