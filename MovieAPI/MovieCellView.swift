//
//  MovieCellView.Swift
//
//  Created by Vijay Bhasker Reddy Bhimanapati on 5/10/17.
//  Copyright © 2017 Demo. All rights reserved.
//

import UIKit

class MovieCellView: UITableViewCell {
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    static let separatorWeight: CGFloat = 1
    static let cellIdentifier = "movieCellView"
    
    override func awakeFromNib() {
        setupView()
    }
    
    override func layoutSubviews() {
        addSeparatorToBottom()
    }
    
    // MARK: - Setup View
    
    fileprivate func setupView() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: titleLabel.font.pointSize)
    }
    
    fileprivate func addSeparatorToBottom() {
        let separator = UIView(
            frame: CGRect(
                x: 0, y: bounds.size.height - MovieCellView.separatorWeight,
                width: bounds.size.width,
                height: MovieCellView.separatorWeight
            )
        )
        
        separator.backgroundColor = UIColor.lightGray
        addSubview(separator)
    }
}
