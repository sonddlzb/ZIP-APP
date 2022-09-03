//
//  SettingViewController.swift
//  Zip
//
//  Created by đào sơn on 31/08/2022.
//

import RIBs
import RxSwift
import UIKit

// MARK: Constant
private struct Const {
    static let changePasswordSize = 30.0
}

protocol SettingPresentableListener: AnyObject {
    func didTapBackButton()
    func didTapOriginalRadioButton()
    func didTapMediumRadioButton()
    func didTapSmallRadioButton()
    func createPassword()
    func deletePassword()
    func didTapChangePasswordButton()
    func getAndBindDataStorage()
}

final class SettingViewController: BaseViewControler, SettingViewControllable {

    // MARK: Outlets
    @IBOutlet private weak var rateButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var passwordLabel: UILabel!
    @IBOutlet private weak var originalRadioButton: ExtensibleTouchView!
    @IBOutlet private weak var mediumRadioButton: ExtensibleTouchView!
    @IBOutlet private weak var smallRadioButton: ExtensibleTouchView!
    @IBOutlet private weak var passwordImageView: UIImageView!
    @IBOutlet private weak var passwordContainerView: UIView!
    @IBOutlet private weak var passwordSwitch: UISwitch!
    @IBOutlet private weak var passwordContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var rateUsViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var changePasswordButton: UIButton!
    @IBOutlet private weak var storageSizeLabel: UILabel!
    @IBOutlet private weak var photoSizeLabel: UILabel!
    @IBOutlet private weak var audioSizeLabel: UILabel!
    @IBOutlet private weak var originalLabel: UILabel!
    @IBOutlet private weak var smallLabel: UILabel!
    @IBOutlet private weak var mediumLabel: UILabel!
    @IBOutlet private weak var originalImageView: UIImageView!
    @IBOutlet private weak var mediumImageView: UIImageView!
    @IBOutlet private weak var smallImageView: UIImageView!

    // MARK: Variables
    weak var listener: SettingPresentableListener?
    private var settingViewModel = SettingViewModel()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initBasicGUI()
        listener?.getAndBindDataStorage()
        configMultipleTouchToNotAllowed()
    }

    override func viewWillDisappearByInteractive() {
        super.viewWillDisappearByInteractive()
        listener?.didTapBackButton()
    }

    // MARK: - Config
    func initBasicGUI() {
        backButton.setTitle("", for: .normal)
        let attrs = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: UIColor(rgb: 0x575FCC)]
            as [NSAttributedString.Key: Any]
        let attrString = NSMutableAttributedString(string: "Rate Us", attributes: attrs)
        rateButton.setAttributedTitle(attrString, for: .normal)
        configRadioButton()
        updateRadioButton()
        configChangePasswordButton()
        updatePasswordSwitch()
    }

    func updateRadioButton() {
        self.originalImageView.image = self.settingViewModel.defaultPhotoSizeImage().originalImage
        self.originalLabel.textColor = self.settingViewModel.defaultPhotoSizeColor().originalColor
        self.originalRadioButton.tintColor = self.settingViewModel.defaultPhotoSizeColor().originalColor
        self.mediumImageView.image = self.settingViewModel.defaultPhotoSizeImage().mediumImage
        self.mediumLabel.textColor = self.settingViewModel.defaultPhotoSizeColor().mediumColor
        self.mediumRadioButton.tintColor = self.settingViewModel.defaultPhotoSizeColor().mediumColor
        self.smallImageView.image = self.settingViewModel.defaultPhotoSizeImage().smallImage
        self.smallLabel.textColor = self.settingViewModel.defaultPhotoSizeColor().smallColor
        self.smallRadioButton.tintColor = self.settingViewModel.defaultPhotoSizeColor().smallColor
    }

    func updatePasswordSwitch() {
        let isPasswordSwitchEnable = self.settingViewModel.isPasswordSwitchEnable()
        self.passwordSwitch.isOn = isPasswordSwitchEnable
        if isPasswordSwitchEnable {
            movePasswordContainerDown(offset: Const.changePasswordSize)
            changePasswordButton.isHidden = false
        }
    }

    func updateDataSizeLabels() {
        self.storageSizeLabel.text = self.settingViewModel.totalStorageSizeValue()
        self.photoSizeLabel.text = self.settingViewModel.totalPhotoSizeValue()
        self.audioSizeLabel.text = self.settingViewModel.totalAudioSizeValue()
    }

    func movePasswordContainerDown(offset: Double) {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.passwordContainerBottomConstraint.constant -= Const.changePasswordSize
            self.rateUsViewBottomConstraint.constant -= Const.changePasswordSize
            self.view.layoutIfNeeded()
        })
    }

    func movePasswordContainerUp(offset: Double) {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.passwordContainerBottomConstraint.constant += Const.changePasswordSize
            self.rateUsViewBottomConstraint.constant += Const.changePasswordSize
            self.view.layoutIfNeeded()
        })
    }

    func configChangePasswordButton() {
        changePasswordButton.contentHorizontalAlignment = .left
        changePasswordButton.contentVerticalAlignment = .top
        let attrs = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: UIColor(rgb: 0x575FCC)]
            as [NSAttributedString.Key: Any]
        let attrString = NSMutableAttributedString(string: "Change password", attributes: attrs)
        changePasswordButton.setAttributedTitle(attrString, for: .normal)
        changePasswordButton.isHidden = true
    }

    func configMultipleTouchToNotAllowed() {
        self.view.isMultipleTouchEnabled = false
        self.passwordSwitch.isExclusiveTouch = true
        changePasswordButton.isExclusiveTouch = true
    }

    func configRadioButton() {
        let originalGesture = UITapGestureRecognizer(target: self, action: #selector(originalRadioButtonDidTap))
        originalRadioButton.addGestureRecognizer(originalGesture)
        let mediumGesture = UITapGestureRecognizer(target: self, action: #selector(mediumRadioButtonDidTap))
        mediumRadioButton.addGestureRecognizer(mediumGesture)
        let smallGesture = UITapGestureRecognizer(target: self, action: #selector(smallRadioButtonDidTap))
        smallRadioButton.addGestureRecognizer(smallGesture)

        originalRadioButton.areaInteractiveInsets = UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -20)
        mediumRadioButton.areaInteractiveInsets = UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -20)
        smallRadioButton.areaInteractiveInsets = UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -20)
    }

    // MARK: Action
    @IBAction func backButtonDidTap(_ sender: Any) {
        listener?.didTapBackButton()
    }

    @objc func originalRadioButtonDidTap() {
        listener?.didTapOriginalRadioButton()
    }

    @objc func mediumRadioButtonDidTap() {
        listener?.didTapMediumRadioButton()
    }

    @objc func smallRadioButtonDidTap() {
        listener?.didTapSmallRadioButton()
    }

    @IBAction func passwordSwitchChangedValue(_ sender: UISwitch) {
        if sender.isOn {
            movePasswordContainerDown(offset: Const.changePasswordSize)
            changePasswordButton.isHidden = false
            listener?.createPassword()
        } else {
            movePasswordContainerUp(offset: Const.changePasswordSize)
            changePasswordButton.isHidden = true
            listener?.deletePassword()
        }
    }

    @IBAction func changePasswordButtonDidTap(_ sender: UIButton) {
        listener?.didTapChangePasswordButton()
    }
}

// MARK: SettingPresentable
extension SettingViewController: SettingPresentable {
    func bind(viewModel: SettingViewModel) {
        self.loadViewIfNeeded()
        self.settingViewModel = viewModel
        let isPasswordSwitchEnable = viewModel.isPasswordSwitchEnable()
        self.passwordSwitch.isOn = isPasswordSwitchEnable
        updateDataSizeLabels()
        if !isPasswordSwitchEnable && !changePasswordButton.isHidden {
            movePasswordContainerUp(offset: Const.changePasswordSize)
            changePasswordButton.isHidden = true
        }

        if isPasswordSwitchEnable && changePasswordButton.isHidden {
            movePasswordContainerDown(offset: Const.changePasswordSize)
            changePasswordButton.isHidden = false
        }

        updateRadioButton()
    }
}
