//
//  StreamViewController.swift
//  buffup-ios
//
//  Created by Eleftherios Charitou on 14/01/2020.
//  Copyright © 2020 BuffUp. All rights reserved.
//

import AVFoundation
import BuffSDK
import UIKit

class StreamViewController: LandscapeViewController {
    @IBOutlet var exitButton: UIButton!
    @IBOutlet var buffView: BuffView!

    private var player: AVPlayer!
    private var timeObserver: Any?

    lazy var playerLayer: AVPlayerLayer = {
        let layer = AVPlayerLayer(player: player)
        layer.frame = self.view.bounds
        layer.videoGravity = .resizeAspectFill
        layer.needsDisplayOnBoundsChange = true
        return layer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showExitButton(recognizer:)))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        loadContent()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        startPlayingVideo()
        startPlayingLocalVideo()
        view.bringSubviewToFront(buffView)
    }

    private func startPlayingVideo() {
        let urlString = "https://hls-test.buffup.net/ataFootball/main.m3u8"
        if let videoURL = URL(string: urlString) {
            playVideoWithURL(url: videoURL)
        }
    }

    private func startPlayingLocalVideo() {
        guard let path = Bundle.main.path(forResource: "Buff", ofType: "mov") else {
            debugPrint("Buff.mov not found")
            return
        }

        playVideoWithURL(url: URL(fileURLWithPath: path))
    }

    func loadContent() {
        let buffSDK = BuffSDK()
//        DispatchQueue.global().async {
//            buffSDK.showBuff(by: "1", on: self.buffView)
//        }

        let timeLine = ["1": 1, "2": 20, "3": 30, "4": 50, "5": 60]

        for (id, value) in timeLine {
            let dispatchAfter = DispatchTimeInterval.seconds(value)
            DispatchQueue.global().asyncAfter(deadline: .now() + dispatchAfter) {
                buffSDK.showBuff(by: id, on: self.buffView)
            }
        }
    }

    deinit {
        cleanPlayer()
    }

    private func playVideoWithURL(url: URL) {
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)

        view.layer.addSublayer(playerLayer)
        view.contentMode = .scaleAspectFit
        player.allowsExternalPlayback = false
        #if DEBUG
            player.isMuted = true
        #endif
        player.play()
    }

    @objc
    private func showExitButton(recognizer _: UIGestureRecognizer) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        exitButton.isHidden = false
        view.bringSubviewToFront(exitButton)
        UIView.animate(withDuration: 0.3) {
            self.exitButton.alpha = 1
        }
        perform(#selector(hideExitButton), with: nil, afterDelay: 2)
    }

    @objc
    private func hideExitButton() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        exitButton.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.exitButton.alpha = 0
        }) { _ in
            self.exitButton.isHidden = true
        }
        perform(#selector(hideExitButton), with: nil, afterDelay: 3)
    }

    @IBAction func exitStream(_: Any) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        dismiss(animated: true, completion: nil)
    }

    private func cleanPlayer() {
        guard player != nil else { return }
        player.pause()
    }
}

extension StreamViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchView = touch.view, touchView.classForCoder != gestureRecognizer.view?.classForCoder {
            return false
        }
        return true
    }
}
