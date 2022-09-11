//
//  DIConfiguration.swift
//  Zip
//
//

import Foundation
import Resolver

extension DIConnector {
    static func registerAllRibs() {
        DIContainer.register(RootBuildable.self) { _, args in
            return RootBuilder(dependency: args.get())
        }

        DIContainer.register(HomeBuildable.self) { _, args in
            return HomeBuilder(dependency: args.get())
        }

        DIContainer.register(OpenFolderBuildable.self) {_, args in
            return OpenFolderBuilder(dependency: args.get())
        }

        DIContainer.register(FolderDetailBuildable.self) { _, args in
            return FolderDetailBuilder(dependency: args.get())
        }

        DIContainer.register(RenameItemBuildable.self) { _, args in
            return RenameItemBuilder(dependency: args.get())
        }

        DIContainer.register(SelectDestinationBuildable.self) { _, args in
            return SelectDestinationBuilder(dependency: args.get())
        }

        DIContainer.register(CreateFolderBuildable.self) { _, args in
            return CreateFolderBuilder(dependency: args.get())
        }

        DIContainer.register(AddFilePopupBuildable.self) { _, args in
            return AddFilePopupBuilder(dependency: args.get())
        }

        DIContainer.register(SelectMediaBuildable.self) { _, args in
            return SelectMediaBuilder(dependency: args.get())
        }

        DIContainer.register(PreviewVideoBuildable.self) { _, args in
            return PreviewVideoBuilder(dependency: args.get())
        }

        DIContainer.register(PreviewImageBuildable.self) { _, args in
            return PreviewImageBuilder(dependency: args.get())
        }

        DIContainer.register(CompressBuildable.self) { _, args in
            return CompressBuilder(dependency: args.get())
        }

        DIContainer.register(ExtractBuildable.self) { _, args in
            return ExtractBuilder(dependency: args.get())
        }

        DIContainer.register(InputPasswordBuildable.self) { _, args in
            return InputPasswordBuilder(dependency: args.get())
        }

        DIContainer.register(SettingBuildable.self) { _, args in
            return SettingBuilder(dependency: args.get())
        }

        DIContainer.register(InputToCompressBuildable.self) { _, args in
                 return InputToCompressBuilder(dependency: args.get())
        }

        DIContainer.register(CompressLoadingBuildable.self) { _, args in
             return CompressLoadingBuilder(dependency: args.get())
        }

        DIContainer.register(OpenFolderBuildable.self) { _, args in
             return OpenFolderBuilder(dependency: args.get())
        }

        DIContainer.register(OpenZipBuildable.self) { _, args in
             return OpenZipBuilder(dependency: args.get())
        }

        DIContainer.register(SelectCategoryAudioBuildable.self) { _, args in
             return SelectCategoryAudioBuilder(dependency: args.get())
        }

        DIContainer.register(SelectAudioBuildable.self) { _, args in
             return SelectAudioBuilder(dependency: args.get())
        }

        DIContainer.register(CreatePasswordBuildable.self) { _, args in
             return CreatePasswordBuilder(dependency: args.get())
        }

        DIContainer.register(ChangePasswordBuildable.self) { _, args in
             return ChangePasswordBuilder(dependency: args.get())
        }

        DIContainer.register(ExtractLoadingBuildable.self) { _, args in
             return ExtractLoadingBuilder(dependency: args.get())
        }

        DIContainer.register(OpenCloudBuildable.self) { _, args in
            return OpenCloudBuilder(dependency: args.get())
        }

        DIContainer.register(AddFileFromGoogleDriveBuildable.self) { _, args in
            return AddFileFromGoogleDriveBuilder(dependency: args.get())
        }
    }
}
