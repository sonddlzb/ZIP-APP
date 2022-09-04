//
//  SelectAudioViewController.swift
//  Zip
//
//

import AVFoundation
import UIKit

import RIBs
import RxCocoa
import RxSwift
import DifferenceKit

private struct Const {
    static let cellHeight: CGFloat = 68
}

protocol SelectAudioPresentableListener: AnyObject {
    func didSelectBack()
    func didSelectPlayPlayer(item: SelectAudioItemViewModel)
    func didSelectPausePlayer()
    func didSelectItem(_ item: SelectAudioItemViewModel)
    func didSelectAll()
    func didUnselectAll()
    func didCancelSelectingMode()
    func didSelectOptionAction(_ action: OptionActionType)
}

final class SelectAudioViewController: BaseViewControler, SelectAudioViewControllable {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var containerOptionView: UIView!
    @IBOutlet private weak var optionView: OptionView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var selectAllImageView: UIImageView!
    @IBOutlet private weak var bottomContainerOptionViewConstraint: NSLayoutConstraint!

    weak var listener: SelectAudioPresentableListener?
    var viewModel: SelectAudioViewModel?
    private var player: AVAudioPlayer?
    private var needPlaying = false

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.player?.pause()
    }

    override func viewWillDisappearByInteractive() {
        super.viewWillDisappearByInteractive()
        listener?.didSelectBack()
    }

    // MARK: - Config
    private func config() {
        self.configTableView()
        self.configOptionView()
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setActive(true)
        self.configNotificationCenter()
    }

    private func configTableView() {
        self.tableView.registerCell(type: SelectAudioCell.self)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    private func configOptionView() {
        self.optionView.delegate = self
        self.optionView.bind(viewModel: OptionViewModel(options: [.compress]))
        self.bottomContainerOptionViewConstraint.constant = -300
        self.containerOptionView.superview?.layoutIfNeeded()
    }

    private func configNotificationCenter() {
        NotificationCenter.default.rx.notification(UIApplication.didEnterBackgroundNotification).subscribe { [unowned self] _ in
            if self.isDisplaying {
                listener?.didSelectPausePlayer()
            }
        }.disposed(by: self.disposeBag)

        NotificationCenter.default.rx.notification(AVAudioSession.interruptionNotification, object: AVAudioSession.sharedInstance()).subscribe(onNext: { [unowned self] notification in
            guard self.isDisplaying,
                  let interruptTypeValue = notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt,
                  let interruptType = AVAudioSession.InterruptionType(rawValue: interruptTypeValue) else {
                return
            }

            if interruptType == .began {
                self.listener?.didSelectPausePlayer()
            }
        }).disposed(by: self.disposeBag)
    }

    // MARK: - Action
    @IBAction func backButtonDidTap(_ sender: Any) {
        if viewModel?.isSelectingModeEnabled == true {
            listener?.didCancelSelectingMode()
        } else {
            listener?.didSelectBack()
        }
    }

    @IBAction func selectAllButtonDidTap(_ sender: Any) {
        if viewModel?.isSelectedAll() == true {
            listener?.didUnselectAll()
        } else {
            listener?.didSelectAll()
        }
    }
}

// MARK: - SelectAudioPresentable
extension SelectAudioViewController: SelectAudioPresentable {
    func bind(viewModel: SelectAudioViewModel, needReloadPlayer: Bool) {
        self.loadViewIfNeeded()

        let source = self.viewModel?.listItemViewModels() ?? []
        let target = viewModel.listItemViewModels()
        let changeset = StagedChangeset(source: source, target: target)
        self.viewModel = viewModel
        if changeset.isEmpty {
            self.tableView.indexPathsForVisibleRows?.forEach({ indexPath in
                let cell = self.tableView.cellForRow(at: indexPath) as? SelectAudioCell
                cell?.bindSelectedState(viewModel: viewModel.item(at: indexPath.row))
            })
        } else {
            self.tableView.reloadData()
        }

        self.titleLabel.text = viewModel.title()
        self.backButton.setImage(viewModel.imageForBackButton(), for: .normal)
        self.selectAllImageView.image = viewModel.imageForSelectAllButton()

        if needReloadPlayer {
            if let item = viewModel.playingItem,
               let assetURL = item.assetURL {
                self.player = try? AVAudioPlayer(contentsOf: assetURL)
                self.player?.numberOfLoops = -1
                self.player?.play()
            } else {
                self.player?.pause()
                self.player = nil
            }
        }

        UIView.animate(withDuration: 0.25) {
            self.bottomContainerOptionViewConstraint.constant = viewModel.hasItemSelected() ? 0 : -300
            self.tableView.contentInset.bottom = self.view.safeAreaInsets.bottom + (viewModel.hasItemSelected() ? self.containerOptionView.frame.height : 0)
            self.containerOptionView.superview?.layoutIfNeeded()
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SelectAudioViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfItems() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(type: SelectAudioCell.self, indexPath: indexPath)!
        cell.delegate = self
        cell.bind(viewModel: self.viewModel!.item(at: indexPath.row))
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? SelectAudioCell {
            if cell.viewModel.isPlaying {
                cell.startScrolling()
            }

            if let itemViewModel = self.viewModel?.item(at: indexPath.row) {
                cell.bindSelectedState(viewModel: itemViewModel)
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let itemViewModel = viewModel?.item(at: indexPath.row) {
            listener?.didSelectItem(itemViewModel)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Const.cellHeight
    }
}

// MARK: - SelectAudioCellDelegate
extension SelectAudioViewController: SelectAudioCellDelegate {
    func selectAudioCellDidSelect(_ cell: SelectAudioCell) {
        listener?.didSelectItem(cell.viewModel)
    }

    func selectAudioCell(_ cell: SelectAudioCell, didChangePlayerStatus isPlaying: Bool) {
        if !isPlaying {
            self.listener?.didSelectPausePlayer()
        } else {
            self.listener?.didSelectPlayPlayer(item: cell.viewModel)
        }
    }
}

// MARK: - OptionViewDelegate
extension SelectAudioViewController: OptionViewDelegate {
    func optionView(_ view: OptionView, didSelectAction action: OptionActionType) {
        self.listener?.didSelectPausePlayer()
        listener?.didSelectOptionAction(action)
    }
}
