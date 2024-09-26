//
//  AssetPickerVC.swift
//  TestAssetPicker
//
//  Created by Chris Larsen on 9/14/19.
//  Copyright © 2019 Unknown. All rights reserved.
//
// https://developer.apple.com/documentation/photokit/selecting_photos_and_videos_in_ios

import UIKit
import PhotosUI
import AVKit

class AssetPickerVC: UIViewController {

    private var selection = [String: PHPickerResult]()
    private var selectedAssetIdentifiers = [String]()
    private var selectedAssetIdentifierIterator: IndexingIterator<[String]>?
    private var currentAssetIdentifier: String?

    let cl_tintColor = UIColor(named: "tintColor")!

    /// - Tag: PresentPicker
    private func presentPicker(filter: PHPickerFilter?) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())

        // Set the filter type according to the user’s selection.
        configuration.filter = filter
        // Set the mode to avoid transcoding, if possible, if your app supports arbitrary image/video encodings.
        configuration.preferredAssetRepresentationMode = .current
        // Set the selection behavior to respect the user’s selection order.
        configuration.selection = .ordered
        // Set the selection limit to enable multiselection.
        configuration.selectionLimit = 1
        // Set the preselected asset identifiers with the identifiers that the app tracks.
        configuration.preselectedAssetIdentifiers = selectedAssetIdentifiers
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        displayNext()
    }

    lazy var helloLabel: UILabel = {
        let helloLabel = UILabel()
        helloLabel.translatesAutoresizingMaskIntoConstraints = false
        helloLabel.textColor = .systemBackground
        return helloLabel
    }()

    lazy var pickAssetBtnItem: UIBarButtonItem = {
        var image = UIImage(systemName: "photo")
        image = image?.withTintColor(cl_tintColor)
        let btn = UIButton(type: .custom)
        btn.with(image!)
        btn.addTarget(self, action: #selector(pickAssetBtnTapped), for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInternalViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureNavigationBar(largeTitleColor: .systemBackground,
                               backgroundColor: cl_tintColor,
                               tintColor: .systemBackground,
                               prefersLargeTitles: false)
        configureButtons()
    }

    fileprivate func setupInternalViews() {

        UIScrollView.appearance().contentInsetAdjustmentBehavior = .automatic

        navigationItem.titleView = getNavbarLabel("ASSETPICKER")
        view.backgroundColor = .cyan

        helloLabel.text = "Hello, asset picker world!"
        view.addSubview(helloLabel)
        activateConstraints(view: view, label: helloLabel)
    }

    fileprivate func configureButtons() {
        navigationItem.rightBarButtonItems = [pickAssetBtnItem] as? [UIBarButtonItem]
    }

    fileprivate func activateConstraints(view: UIView,
                                         label: UILabel) {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    @objc func pickAssetBtnTapped() {
        presentPicker(filter: PHPickerFilter.images)
    }

    fileprivate func getNavbarLabel(_ text: String) -> UILabel? {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        let customFont = UIFont(name: "comixloud", size: 12)
        label.font = customFont

        label.textAlignment = .center
        label.textColor = .systemBackground
        label.backgroundColor = .clear
        label.numberOfLines = 1
        label.text = text

        label.heightAnchor.constraint(equalToConstant: 44).isActive = true

        return label
    }
}

private extension AssetPickerVC {

    func displayNext() {

        guard let assetIdentifier = selectedAssetIdentifierIterator?.next() else { return }
        currentAssetIdentifier = assetIdentifier
        DispatchQueue.main.async {
            self.handleCompletion(assetIdentifier: assetIdentifier)
        }
    }

    func handleCompletion(assetIdentifier: String) {

        guard currentAssetIdentifier == assetIdentifier else { return }

        debugPrint(currentAssetIdentifier!)
        helloLabel.text = currentAssetIdentifier
    }
}

extension AssetPickerVC: PHPickerViewControllerDelegate {

    /// - Tag: ParsePickerResults
    func picker(_ picker: PHPickerViewController,
                didFinishPicking results: [PHPickerResult]) {

        dismiss(animated: true)

        let existingSelection = self.selection
        var newSelection = [String: PHPickerResult]()
        for result in results {
            let identifier = result.assetIdentifier!
            newSelection[identifier] = existingSelection[identifier] ?? result
        }

        // Track the selection in case the user deselects it later.
        selection = newSelection
        selectedAssetIdentifiers = results.map(\.assetIdentifier!)
        selectedAssetIdentifierIterator = selectedAssetIdentifiers.makeIterator()

        displayNext()
    }
}
