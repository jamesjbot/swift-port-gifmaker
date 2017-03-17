//
//  SavedGifsViewController.swift
//  GifMaker_Swift_Template
//
//  Created by James Jongsurasithiwat on 3/17/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

class SavedGifsViewController: UIViewController {
    // MARK: - IBOutlet

    @IBOutlet weak var emptyView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Constants
    let cellMargin: CGFloat = 12.0

    // MARK: - Variables

    var savedGifs: [Gif] = []


    // MARK: - Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the Image if there are gifs availabe for display
        emptyView.isHidden = (savedGifs.count != 0)
        collectionView.reloadData()
    }
}

// MARK: - Extensions

extension SavedGifsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - UICollectionViewDataSource methods

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedGifs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GifCell", for: indexPath) as! GifCell
        let gif = savedGifs[indexPath.item]
        cell.configureForGif(gif: gif)
        return cell
    }

    // MARK: - UICollectionViewDelegate methods

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    // MARK: - UICollectionViewFlowLayoutDelegate methods

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - (cellMargin * 2.0))/2.0
        return CGSize(width: width, height: width)
    }

}

// MARK: - PreviewViewControllerDelegate

extension SavedGifsViewController: PreviewViewControllerDelegate {
    func previewVC(preview: UIImage, didSaveGif gif: Gif) {
        var newGif = Gif(url: gif.url, videoURL: gif.videoURL, caption: gif.caption)
        newGif.gifData = NSData(contentsOf: newGif.url)
        savedGifs.append(newGif)
    }
}


