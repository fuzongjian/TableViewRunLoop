//
//  CustomCell.swift
//  TableViewRunLoop
//
//  Created by deltalpha on 2020/5/19.
//  Copyright © 2020 付宗建. All rights reserved.
//

import UIKit
let PADDING:CGFloat = 10
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
class CustomCell: UITableViewCell {
    lazy var imageView1 = { return UIImageView() }()
    lazy var imageView2 = { return UIImageView() }()
    lazy var imageView3 = { return UIImageView() }()
    let itemW = (SCREEN_WIDTH - PADDING*4) / 3
    let itemH:CGFloat = 90
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    func configUI() -> Void {
        self.contentView.addSubview(imageView1)
        self.contentView.addSubview(imageView2)
        self.contentView.addSubview(imageView3)
    }
    override func layoutSubviews() {
        superview?.layoutSubviews()
        imageView1.frame = CGRect(x: PADDING, y: 5, width: itemW, height: itemH)
        imageView2.frame = CGRect(x: PADDING*2 + itemW, y: 5, width: itemW, height: itemH)
        imageView3.frame = CGRect(x: PADDING*3 + itemW*2, y: 5, width: itemW, height: itemH)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
