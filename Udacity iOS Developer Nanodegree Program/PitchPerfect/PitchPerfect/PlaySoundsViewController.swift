//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Tongyu on 5/19/16.
//  Copyright © 2016 Tongyu Yang. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    @IBOutlet weak var SnailButton: UIButton!
    @IBOutlet weak var DarthVaderButton: UIButton!
    @IBOutlet weak var EchoButton: UIButton!
    @IBOutlet weak var RabbitButton: UIButton!
    @IBOutlet weak var ReverbButton: UIButton!
    @IBOutlet weak var ChipmunkButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var recordedAudioURL: NSURL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: NSTimer!
    
    enum ButtonType: Int {case Slow = 0, Fast, Chipmunk, Vader, Echo, Reverb}
    @IBAction func playSoundForButton(sender: UIButton) {
        switch (ButtonType(rawValue: sender.tag)!) {
        case .Slow:
            playSound(rate: 0.5)
        case .Fast:
            playSound(rate: 1.5)
        case .Chipmunk:
            playSound(pitch: 1000)
        case .Vader:
            playSound(pitch: -1000)
        case .Echo:
            playSound(echo: true)
        case .Reverb:
            playSound(reverb: true)
        }
        configureUI(.Playing)
    }
    
    @IBAction func stopButtonPressed(sender: AnyObject) {
        stopAudio()
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
    }
    
    override func viewWillAppear(animated: Bool) {
        configureUI(.NotPlaying)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }

}
