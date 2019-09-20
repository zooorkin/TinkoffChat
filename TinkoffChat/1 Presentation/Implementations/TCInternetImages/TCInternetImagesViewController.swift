//
//  TCInternetImagesViewController.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 03.05.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

class TCInternetImagesViewController: UICollectionViewController, ITCInternetImagesModelDelegate {
    
    var delegate: TCProfileViewController?
    
    // MARK: - ITCInternetImagesModelDelegate
    
    func update(dataSource: [TCInternetImagesCellModel]) {
        self.dataSource = dataSource
        DispatchQueue.main.sync {
            let indexSet = IndexSet(integer: 0)
            self.collectionView?.reloadSections(indexSet)
            self.activityIndicator.stopAnimating()
        }
    }
    
    lazy var queue = DispatchQueue(label: "com.tinkoffChat.iicontroller")
    
    func update(image: UIImage, forIndex: Int) {
        queue.sync {
            dataSource[forIndex].image = image
            let indexPath = IndexPath(row: forIndex, section: 0)
            if let collectionView = collectionView {
                DispatchQueue.main.sync {
                    if collectionView.indexPathsForVisibleItems.contains(indexPath) {
                        let indexPath = IndexPath(row: forIndex, section: 0)
                        self.collectionView?.reloadItems(at: [indexPath])
                    }
                }
            }
            usleep(2000)
        }
    }
    
    //
    
    internal let presentationAssembly: ITCPresentationAssembly
    
    internal var model: ITCInternetImagesModel
    
    internal var dataSource: [TCInternetImagesCellModel] = []
    
    // MARK: - init
    
    init(presentationAssembly: ITCPresentationAssembly, model: ITCInternetImagesModel) {
        self.presentationAssembly = presentationAssembly
        self.model = model
        super.init(nibName: TCNibName.TCInternetImages.rawValue, bundle: nil)
        self.model.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.fetchUpdate()
        adjustNavigationBar()
        let nib = UINib(nibName: TCNibName.TCInternetImagesCell.rawValue, bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: TCNibName.TCInternetImagesCell.rawValue)
        activityIndicator.color = UIColor.lightGray
        activityIndicator.center = view.center
        activityIndicator.center.y = 128
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        tinkoffAnimation.setView(view: view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TCNibName.TCInternetImagesCell.rawValue, for: indexPath) as? TCInternetImagesCell else {
            fatalError()
        }
        
        if let image = dataSource[indexPath.row].image {
            cell.set(image: image)
        } else {
            let placeholder = getPlaceholder(forIndex: indexPath.row)
            cell.set(image: placeholder)
        }
        
        return cell
    }
    
    func getPlaceholder(forIndex: Int) -> UIImage {
        switch forIndex % 5 {
        case 0: return #imageLiteral(resourceName: "placeholders.001")
        case 1: return #imageLiteral(resourceName: "placeholders.002")
        case 2: return #imageLiteral(resourceName: "placeholders.003")
        case 3: return #imageLiteral(resourceName: "placeholders.004")
        case 4: return #imageLiteral(resourceName: "placeholders.005")
        default: fatalError()
        }
    }
    
    private func adjustNavigationBar(){
        title = "Картинки"
        navigationController?.navigationBar.tintColor = UIColor.black
        if let topItem = navigationController?.navigationBar.topItem {
            let leftButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(close))
            topItem.leftBarButtonItem = leftButton
        } else {
            fatalError()
        }
    }
    
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    fileprivate let itemsPerRow: CGFloat = 3
    
    //
    
    let tinkoffAnimation = TCTinkoffAnimation()
    
    //
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tinkoffAnimation.touchesBegan(touches, with: event)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        tinkoffAnimation.touchesMoved(touches, with: event)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        tinkoffAnimation.touchesEnded(touches, with: event)
    }
    
}

extension TCInternetImagesViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
extension TCInternetImagesViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let image = dataSource[indexPath.row].image {
            delegate?.setNew(photo: image)
        }
        dismiss(animated: true, completion: nil)
    }
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        queue.async {
            if self.dataSource[indexPath.row].image == nil {
                self.model.loadImageAt(index: indexPath.row)
            }
        }
    }
    
    
}
