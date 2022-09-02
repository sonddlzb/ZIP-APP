//
//  PlayerView.swift
//  CommonUI
//
//

import AVFoundation
import UIKit

import TLLogging

@objc public protocol PlayerViewDelegate: AnyObject {
    func playerViewBeganInterruptAudioSession(_ view: PlayerView)
    @objc optional func playerViewEndInterruptAudioSession(_ view: PlayerView)
    @objc optional func playerViewDidPlayToEnd(_ view: PlayerView)

    func playerViewUpdatePlayingState(_ view: PlayerView, isPlaying: Bool)
    @objc optional func playerViewReadyToPlay(_ view: PlayerView)
    @objc optional func playerViewFailToLoad(_ view: PlayerView)
}

open class PlayerView: UIView {
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            view.style = .large
        } else {
            view.style = .whiteLarge
        }

        view.color = .lightGray
        return view
    }()

    public weak var delegate: PlayerViewDelegate?
    public var loopEnable: Bool = false
    public var pauseWhenEnterBackground: Bool = true
    public var canShowLoading: Bool = false {
        didSet {
            self.loadingIndicator.alpha = canShowLoading ? 1 : 0
        }
    }

    public var isMuted: Bool {
        get {
            return player.isMuted
        }

        set {
            player.isMuted = newValue
        }
    }

    public var isFailed: Bool = false

    public var isReadyToPlay: Bool {
        return !self.loadingIndicator.isAnimating
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initPlayer()
        registerNotifications()
        configLoading()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        initPlayer()
        registerNotifications()
        configLoading()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        self.playerLayer.frame = self.bounds
    }

    private func initPlayer() {
        self.player = AVPlayer()
        self.player.addObserver(self, forKeyPath: "rate", options: [.initial, .new], context: nil)
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerLayer.frame = self.bounds
        self.layer.insertSublayer(self.playerLayer, at: 0)
    }

    private func configLoading() {
        self.addSubview(self.loadingIndicator)
        self.loadingIndicator.isHidden = true
        self.loadingIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.loadingIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.loadingIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    deinit {
        self.player.removeObserver(self, forKeyPath: "rate")

        if let playerItem = self.player.currentItem {
            playerItem.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        }
    }

    // MARK: - Observer
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status = self.player.currentItem?.status
            if status == .readyToPlay {
                TLLogging.log("Player item ready to play \(self.player.currentItem?.description ?? "")")
                self.stopLoadingIndicator()
                self.delegate?.playerViewReadyToPlay?(self)
            }

            if status == .failed {
                TLLogging.log("Player item failed \(self.player.currentItem?.description ?? "")")
                self.delegate?.playerViewFailToLoad?(self)
                self.startLoadingIndicator()
                self.player.replaceCurrentItem(with: nil)
            }
        }
    }

    // MARK: - Notifications
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(audioSessionIterruptionNotification(_:)), name: AVAudioSession.interruptionNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(applicationEnterbackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }

    @objc func playerItemDidPlayToEnd(_ notification: Notification) {
        delegate?.playerViewDidPlayToEnd?(self)
        if self.loopEnable {
            self.player.seek(to: .zero)
            self.play()
        }
    }

    @objc func applicationEnterbackground(_ notification: Notification) {
        if self.pauseWhenEnterBackground {
            self.pause()
            self.delegate?.playerViewUpdatePlayingState(self, isPlaying: false)
        }
    }

    @objc private func audioSessionIterruptionNotification(_ notification: Notification) {
        guard let typeValue = notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt,
           let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
               return
        }

        if type == .began {
            self.pause()
            delegate?.playerViewBeganInterruptAudioSession(self)
        } else {
            delegate?.playerViewEndInterruptAudioSession?(self)
        }
    }

    // MARK: - Loading handler
    private func startLoadingIndicator() {
        self.loadingIndicator.isHidden = false
        self.loadingIndicator.startAnimating()
    }

    private func stopLoadingIndicator() {
        self.loadingIndicator.isHidden = true
        self.loadingIndicator.stopAnimating()
    }

    // MARK: - Audio session
    private func activeAudioSession() {
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
    }

    // MARK: - Public
    public func play() {
        activeAudioSession()
        self.player.play()
        self.delegate?.playerViewUpdatePlayingState(self, isPlaying: true)
    }

    public func pause() {
        self.player.pause()
        self.delegate?.playerViewUpdatePlayingState(self, isPlaying: false)
    }

    @discardableResult
    public func replacePlayerItem(_ item: AVPlayerItem?) -> Bool {
        if let oldItem = self.player.currentItem {
            if let newItem = item, comparePlayerItem(lhs: oldItem, rhs: newItem) {
                return false
            }

            oldItem.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: oldItem)
        }

        self.player.replaceCurrentItem(with: item)
        if item != nil {
            item?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.new], context: nil)
            self.startLoadingIndicator()
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidPlayToEnd(_:)), name: .AVPlayerItemDidPlayToEndTime, object: item!)
        } else {
            TLLogging.log("Player item is nil")
        }

        return true
    }

    public func seekTo(_ time: TimeInterval) {
        let cmtime = CMTime.init(seconds: time, preferredTimescale: 3600)
        self.player.seek(to: cmtime, toleranceBefore: .zero, toleranceAfter: .zero)
    }

    public func addTimeObserver(forInterval interval: CMTime, queue: DispatchQueue = .main, using: @escaping (CMTime) -> Void) -> Any {
        return self.player.addPeriodicTimeObserver(forInterval: interval, queue: queue, using: using)
    }

    public func removeTimeObserver(_ obj: Any) {
        self.player.removeTimeObserver(obj)
    }

    private func comparePlayerItem(lhs: AVPlayerItem, rhs: AVPlayerItem) -> Bool {
        guard let lhsAsset = lhs.asset as? AVURLAsset,
              let rhsAsset = rhs.asset as? AVURLAsset else {
            return false
        }

        return lhsAsset.url == rhsAsset.url
    }

    public func setLayerVideoGravity(_ value: AVLayerVideoGravity) {
        playerLayer.videoGravity = value
    }

    public func rate() -> Float {
        return player.rate
    }

    public func duration() -> CMTime? {
        return player.currentItem?.duration
    }

    public func isPlaying() -> Bool {
        return player.rate != 0
    }
}
