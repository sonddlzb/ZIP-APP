//
//  AddFileFromGoogleDriveInteractor.swift
//  Zip
//
//

import GoogleAPIClientForREST
import GoogleSignIn
import RIBs
import RxSwift
import TLLogging

private struct Const {
    static let clientID = "1078221558246-lr568tkkvem4scg07kkeedvt0b3k78ec.apps.googleusercontent.com"
}

protocol AddFileFromGoogleDriveRouting: Routing {
    var viewController: AddFileFromGoogleDriveViewControllable { get }
    func routeToOpenCloud(cloudItem: CloudItem, parentId: String?)
    func dismissOpenCloud()
}

protocol AddFileFromGoogleDriveListener: AnyObject {
    func addFileFromGoogleDriveWantToDismiss()
    func addFileFromGoogleDriveDidDownloadSuccessfully()
}

final class AddFileFromGoogleDriveInteractor: Interactor, AddFileFromGoogleDriveInteractable {

    weak var router: AddFileFromGoogleDriveRouting?
    weak var listener: AddFileFromGoogleDriveListener?

    init(downloadFolderURL: URL) {
        GoogleDriveService.shared.downloadFolderURL = downloadFolderURL
        super.init()
    }

    override func didBecomeActive() {
        super.didBecomeActive()

        let gidSignInCallBack: (GIDGoogleUser?, Error?) -> Void = { [weak self] _, error in
            if let error = error {
                TLLogging.log("Google sign in error: \(error)")
                if (error as NSError).code == -15 {
                    NotificationBannerView.show("Your system time is incorrect", icon: .warning)
                }

                self?.listener?.addFileFromGoogleDriveWantToDismiss()
                return
            }

            self?.router?.routeToOpenCloud(cloudItem: GoogleDriveItem(), parentId: nil)
        }

        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn(completion: gidSignInCallBack)
            return
        }

        if let viewController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.topViewController() {
            let configuration = GIDConfiguration(clientID: Const.clientID)
            let scopes = [kGTLRAuthScopeDrive, kGTLRAuthScopeDriveFile, kGTLRAuthScopeDriveReadonly]
            GIDSignIn.sharedInstance.signIn(withPresenting: viewController, hint: nil, additionalScopes: scopes)
        }
    }

    override func willResignActive() {
        super.willResignActive()
    }
}
