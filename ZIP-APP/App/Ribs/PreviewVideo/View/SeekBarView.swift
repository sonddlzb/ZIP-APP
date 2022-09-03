//
//  SeekBarView.swift
//  Zip
//
//  Created by đào sơn on 08/07/2022.
//

import UIKit

protocol SeekBarViewDelegate: AnyObject {
    func seekBarView(_ view: SeekBarView, seekTimeProgress progress: Double)
    func seekBarViewDidBeganSeek(_ view: SeekBarView)
    func seekBarViewDidEndedSeek(_ view: SeekBarView)
}

private struct Const {
    static let timeViewWidth: CGFloat = 4.0
    static let circleViewRadius: CGFloat = 8.0
}

class SeekBarView: UIView {

    // MARK: Variables
    private var timeNotFillView: UIView = {
        let view = UIView()
        return view
    }()

    private var timeFillView: UIView = {
        let view = UIView()
        return view
    }()

    private var circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()

    private var timeFillViewTrailingConstraint: NSLayoutConstraint!
    weak var delegate: SeekBarViewDelegate?

    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    private func commonInit() {
        self.config()
        self.configTimeFillView()
        self.configTimeNotFillView()
        self.configDraggableCircularView()
    }

    // MARK: Config
    func config() {
        self.addSubview(timeNotFillView)
        self.addSubview(timeFillView)
        self.addSubview(circleView)

        self.translatesAutoresizingMaskIntoConstraints = false
        timeNotFillView.translatesAutoresizingMaskIntoConstraints = false
        timeFillView.translatesAutoresizingMaskIntoConstraints = false
        circleView.translatesAutoresizingMaskIntoConstraints = false

        timeFillViewTrailingConstraint = timeFillView.trailingAnchor.constraint(equalTo: self.leadingAnchor)
        NSLayoutConstraint.activate([
            timeNotFillView.topAnchor.constraint(equalTo: self.centerYAnchor, constant: -Const.timeViewWidth/2),
            timeNotFillView.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: Const.timeViewWidth/2),
            timeNotFillView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Const.circleViewRadius),
            timeNotFillView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Const.circleViewRadius),

            circleView.topAnchor.constraint(equalTo: self.centerYAnchor, constant: -Const.circleViewRadius),
            circleView.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: Const.circleViewRadius),
            circleView.leadingAnchor.constraint(equalTo: timeFillView.trailingAnchor, constant: -Const.circleViewRadius),
            circleView.trailingAnchor.constraint(equalTo: timeFillView.trailingAnchor, constant: Const.circleViewRadius),

            timeFillView.topAnchor.constraint(equalTo: timeNotFillView.topAnchor),
            timeFillView.bottomAnchor.constraint(equalTo: timeNotFillView.bottomAnchor),
            timeFillView.leadingAnchor.constraint(equalTo: self.leadingAnchor),

            timeFillViewTrailingConstraint
        ])
    }

    func configTimeNotFillView() {
        self.timeNotFillView.backgroundColor = UIColor(rgb: 0xAFAFAF, alpha: 0.79)
        self.timeNotFillView.cornerRadius = 2
    }

    func configTimeFillView() {
        self.timeFillView.backgroundColor = .white
        self.timeFillView.cornerRadius = 2
    }

    func configDraggableCircularView() {
        self.circleView.backgroundColor = .white
        circleView.layer.cornerRadius = Const.circleViewRadius
    }

    func updateSeekBarWith(currentTimeProgress: Double) {
        self.timeFillViewTrailingConstraint.constant = currentTimeProgress * self.timeNotFillView.bounds.width
        self.layoutIfNeeded()
    }

    // MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        delegate?.seekBarViewDidBeganSeek(self)
        if let touch = touches.first {
            self.handleSeeking(touch: touch)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let touch = touches.first {
            self.handleSeeking(touch: touch)
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        delegate?.seekBarViewDidEndedSeek(self)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        delegate?.seekBarViewDidEndedSeek(self)
    }

    // Handle touches to seek
    private func handleSeeking(touch: UITouch) {
        let position = touch.location(in: self)
        self.timeFillViewTrailingConstraint.constant = position.x
        self.layoutIfNeeded()
        delegate?.seekBarView(self, seekTimeProgress: position.x/self.timeNotFillView.bounds.width)
    }
}
