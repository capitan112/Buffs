//
//  CircularTimer.swift
//  BuffSDK
//
//  Created by Eleftherios Charitou on 05/02/2020.
//  Copyright © 2020 BuffUp. All rights reserved.
//

import UIKit

@IBDesignable
class CircularTimer: UIView {
    private let timeLeftShapeLayer = CAShapeLayer()
    private let bgShapeLayer = CAShapeLayer()
    private var timeLabel = UILabel()
    private var duration: TimeInterval = 0
    private var timer: Timer?
    private var endTime: Date?
    private let strokeIt = CABasicAnimation(keyPath: "strokeEnd")

    private let MinimumTimeToStartPulsing: TimeInterval = 6
    private let MinimumTimeToSpeedUpPulsing: TimeInterval = 4

    @IBInspectable var bgColor: UIColor = .white {
        didSet {
            bgShapeLayer.strokeColor = bgColor.cgColor
        }
    }

    @IBInspectable var timerColor: UIColor = .red {
        didSet {
            timeLeftShapeLayer.strokeColor = timerColor.cgColor
        }
    }

    @IBInspectable var timerWidth: CGFloat = 0
    @IBInspectable var textColor: UIColor = .white

    private func drawBgShape(_ rect: CGRect) {
        bgShapeLayer.removeFromSuperlayer()
        bgShapeLayer.path = getCircularPath(rect)
        bgShapeLayer.strokeColor = bgColor.cgColor
        bgShapeLayer.fillColor = UIColor.clear.cgColor
        bgShapeLayer.lineWidth = timerWidth
        layer.addSublayer(bgShapeLayer)
    }

    private func drawTimeLeftShape(_ rect: CGRect) {
        timeLeftShapeLayer.removeFromSuperlayer()
        timeLeftShapeLayer.path = getCircularPath(rect)
        timeLeftShapeLayer.strokeColor = timerColor.cgColor
        timeLeftShapeLayer.fillColor = UIColor.clear.cgColor
        timeLeftShapeLayer.lineWidth = timerWidth
        timeLeftShapeLayer.isHidden = true
        layer.addSublayer(timeLeftShapeLayer)
    }

    private func addTimeLabel(_ rect: CGRect) {
        timeLabel.removeFromSuperview()
        timeLabel = UILabel(frame: CGRect(x: rect.midX, y: rect.midY, width: 30, height: 30))
        timeLabel.textAlignment = .center
        timeLabel.center = CGPoint(x: rect.midX, y: rect.midY)
        timeLabel.font = UIFont(name: "Gibson-SemiBold", size: 12)!
        timeLabel.textColor = textColor
        addSubview(timeLabel)
    }

    private func getCircularPath(_ rect: CGRect) -> CGPath {
        return UIBezierPath(arcCenter: CGPoint(x: rect.midX, y: rect.midY), radius: rect.size.height / 2, startAngle: deg2rad(-90), endAngle: deg2rad(270), clockwise: true).cgPath
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawBgShape(rect)
        drawTimeLeftShape(rect)
        addTimeLabel(rect)
        strokeIt.fromValue = 0
        strokeIt.toValue = 1
    }

    private func deg2rad(_ number: Double) -> CGFloat {
        return CGFloat(number) * .pi / 180
    }

    func resetTimer() {
        stopTimer()
        timeLeftShapeLayer.isHidden = true
    }

    func stopTimer() {
        timeLeftShapeLayer.removeAnimation(forKey: "stroke")
        layer.removeAnimation(forKey: "pulse")
        timer?.invalidate()
        timer = nil
    }

    func startTimer(_ duration: TimeInterval) {
        self.duration = duration
        strokeIt.duration = duration
        timeLeftShapeLayer.add(strokeIt, forKey: "stroke")
        timeLeftShapeLayer.isHidden = false
        timeLabel.text = String(format: "%02d", Int(duration))
        endTime = Date().addingTimeInterval(duration)
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }

    @objc
    private func updateTime() {
        if duration > 0 {
            duration = endTime?.timeIntervalSinceNow ?? 0
            timeLabel.text = String(format: "%02d", Int(duration))
            updatePulsingForTime(duration)
        } else {
            resetTimer()
        }
    }

    private func updatePulsingForTime(_ time: TimeInterval) {
        layer.removeAnimation(forKey: "pulse")
        if time >= MinimumTimeToSpeedUpPulsing, time <= MinimumTimeToStartPulsing {
            startPulsingWithDuration(0.5)
        } else if time > 0, time < MinimumTimeToSpeedUpPulsing {
            startPulsingWithDuration(0.25)
        }
    }

    private func startPulsingWithDuration(_ duration: TimeInterval) {
        guard layer.animation(forKey: "pulse") == nil else {
            return
        }

        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = duration
        pulseAnimation.fromValue = NSNumber(value: 1)
        pulseAnimation.toValue = NSNumber(value: 0.9)
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.isRemovedOnCompletion = true
        pulseAnimation.repeatCount = Float(1 / duration)
        layer.transform = CATransform3DIdentity
        layer.add(pulseAnimation, forKey: "pulse")
    }
}
