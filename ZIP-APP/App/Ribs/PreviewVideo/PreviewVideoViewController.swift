//
//  PreviewVideoViewController.swift
//  Zip
//
//  Created by đào sơn on 03/09/2022.
//
import RIBs
import RxSwift
import UIKit
import AVFoundation
import RxCocoa

protocol PreviewVideoPresentableListener: AnyObject {
    func didTapCancelButton()
    func updateCurrentVideoTime(currentTime: Double)
}

final class PreviewVideoViewController: BaseViewControler, PreviewVideoViewControllable {

    // MARK: Outlets
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var videoContentView: PlayerView!
    @IBOutlet private weak var seekBarContainerView: UIView!
    @IBOutlet private weak var seekBarView: SeekBarView!
    @IBOutlet private weak var playAndPauseButton: UIButton!
    @IBOutlet private weak var currentTimeLabel: UILabel!
    @IBOutlet private weak var totalTimeLabel: UILabel!
    @IBOutlet private weak var cancelButton: TapableView!

    // MARK: Variables
    weak var listener: PreviewVideoPresentableListener?
    private var viewModel: PreviewVideoViewModel!
    private let topGradientLayer = CAGradientLayer()
    private let bottomGradientLayer = CAGradientLayer()
    private var timeObserverToken: Any?
    private var isPlayingBefore = true

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initBasicGUI()
        addTopGradientLayer()
        addBottomGradientLayer()
        addNotificationObserver()
        configVideoContentView()
        configSeekBarView()
        configPlayAndPauseButton()
        hideAllOtherViewsWithSchedule()
    }

    deinit {
        removePeriodicTimeObserver()
    }

    override func viewWillDisappearByInteractive() {
        super.viewWillDisappearByInteractive()
        listener?.didTapCancelButton()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topGradientLayer.frame = headerView.bounds
        bottomGradientLayer.frame = seekBarContainerView.bounds
    }

    func initBasicGUI() {
        self.currentTimeLabel.text = viewModel.formatTime(time: 0.0)
    }

    func addTopGradientLayer() {
        topGradientLayer.frame = headerView.bounds
        topGradientLayer.colors = [UIColor(rgb: 0, alpha: 0.4).cgColor, UIColor(rgb: 0, alpha: 0).cgColor]
        topGradientLayer.locations = [0, 1.0]
        headerView.layer.insertSublayer(topGradientLayer, at: 0)
    }

    func addBottomGradientLayer() {
        bottomGradientLayer.frame = seekBarContainerView.bounds
        bottomGradientLayer.colors = [UIColor(rgb: 0, alpha: 0).cgColor, UIColor(rgb: 0, alpha: 0.4).cgColor]
        bottomGradientLayer.locations = [0, 1.0]
        seekBarContainerView.layer.insertSublayer(bottomGradientLayer, at: 0)
    }

    // MARK: Config
    func configVideoContentView() {
        self.viewModel.fetchAVAsset(completion: { avAsset in
            if let asset = avAsset {
                DispatchQueue.main.async {
                    self.videoContentView.replacePlayerItem(AVPlayerItem(asset: asset))
                }
            }
        })

        addPeriodicTimeObserverForVideo()
        self.videoContentView.setLayerVideoGravity(.resizeAspect)
        self.videoContentView.loopEnable = true
        self.videoContentView.delegate = self
        self.videoContentView.play()
    }

    func configSeekBarView() {
        self.seekBarView.delegate = self
    }

    func configPlayAndPauseButton() {
        self.playAndPauseButton.cornerRadius = self.playAndPauseButton.frame.height/2
        self.playAndPauseButton.tintColor = UIColor(rgb: 0xFFFFFF, alpha: 0.85)
        self.playAndPauseButton.backgroundColor = UIColor(rgb: 0xFFFFFF, alpha: 0.3)
    }

    func addPeriodicTimeObserverForVideo() {
        let time = CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        self.timeObserverToken = self.videoContentView.addTimeObserver(forInterval: time, queue: .main, using: {[weak self] time in
            self?.listener?.updateCurrentVideoTime(currentTime: time.seconds)
        })
    }

    func removePeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            self.videoContentView.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }

    func showAllOtherViewsTemporary() {
        showAllOtherViews()
        hideAllOtherViewsWithSchedule()
    }

    func hideAllOtherViewsWithSchedule() {
        perform(#selector(hideAllOtherViews), with: nil, afterDelay: 3)
    }

    @objc func hideAllOtherViews() {
        UIView.transition(with: self.playAndPauseButton, duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.playAndPauseButton.isHidden = true
                            self.seekBarContainerView.isHidden = true
                            self.cancelButton.isHidden = true
                          })
    }

    func showAllOtherViews() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        UIView.transition(with: self.playAndPauseButton, duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.playAndPauseButton.isHidden = false
                            self.seekBarContainerView.isHidden = false
                            self.cancelButton.isHidden = false
                          })
    }

    func resetHideTime() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(hideAllOtherViews), object: nil)
        hideAllOtherViewsWithSchedule()
    }

    func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActiveNotification(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)

        NotificationCenter.default.rx.notification(AVAudioSession.interruptionNotification).subscribe(onNext: { [unowned self] _ in
            self.isPlayingBefore = false
        }).disposed(by: self.disposeBag)
    }

    @objc func applicationDidBecomeActiveNotification(_ notification: Notification) {
        showAllOtherViewsTemporary()
        self.isPlayingBefore = false
    }

    // MARK: Actions
    @IBAction func cancelButtonDidTap(_ sender: Any) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.videoContentView.replacePlayerItem(nil)
        listener?.didTapCancelButton()
    }

    @IBAction func playAndPauseButtonDidTap(_ sender: UIButton) {
        self.videoContentView.isPlaying() ? self.videoContentView.pause() : self.videoContentView.play()
        self.isPlayingBefore = self.videoContentView.isPlaying()
        resetHideTime()
    }
}

// MARK: PreviewVideoPresentable
extension PreviewVideoViewController: PreviewVideoPresentable {
    func bind(viewModel: PreviewVideoViewModel) {
        self.viewModel = viewModel
        self.loadViewIfNeeded()
        self.totalTimeLabel.text = self.viewModel.durationString()
        self.seekBarView.updateSeekBarWith(currentTimeProgress: self.viewModel.seekBarProgressValue())
        self.currentTimeLabel.text = self.viewModel.currentTimeLabelValue()
    }
}

// MARK: SeekBarViewDelegate
extension PreviewVideoViewController: SeekBarViewDelegate {
    func seekBarViewDidBeganSeek(_ view: SeekBarView) {
        if self.videoContentView.isPlaying() {
            self.videoContentView.pause()
        }

        showAllOtherViews()
    }

    func seekBarViewDidEndedSeek(_ view: SeekBarView) {
        isPlayingBefore ? self.videoContentView.play() : self.videoContentView.pause()
        resetHideTime()
    }

    func seekBarView(_ view: SeekBarView, seekTimeProgress progress: Double) {
        if let duration = self.videoContentView.duration() {
            let currentTime = CMTimeGetSeconds(duration) * progress
            currentTimeLabel.text = viewModel.formatTime(time: currentTime)
            self.videoContentView.seekTo(currentTime)
        }
    }
}

// MARK: PlayerViewDelegate
extension PreviewVideoViewController: PlayerViewDelegate {
    func playerViewBeganInterruptAudioSession(_ view: PlayerView) {

    }

    func playerViewUpdatePlayingState(_ view: PlayerView, isPlaying: Bool) {
        let playAndPauseIconName = isPlaying ? "ic_pause" : "ic_play"
        playAndPauseButton.setImage(UIImage(named: playAndPauseIconName), for: .normal)
    }
}

extension PreviewVideoViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if playAndPauseButton.isHidden {
            resetHideTime()
            showAllOtherViewsTemporary()
        } else {
            let touch = touches.first!
            let location = touch.location(in: self.view)
            let isTouchInSeekBarContainerView = self.seekBarContainerView.frame.contains(location)
            if isTouchInSeekBarContainerView {
                resetHideTime()
            } else {
                hideAllOtherViews()
            }
        }
    }
}
