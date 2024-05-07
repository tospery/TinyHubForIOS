//
//  SinceView.swift
//  TinyHub
//
//  Created by 杨建祥 on 2024/3/21.
//

import UIKit
import RxSwift
import RxCocoa
import BonMot
import HiIOS

class SinceView: BaseView {
    
    struct Metric {
        static let tag = 101
        static let width = (deviceWidth * 0.45).flat
        static let height = 120.f
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = Metric.height / 3.0
        tableView.tableFooterView = UIView.init()
        tableView.theme.tintColor = themeService.attribute { $0.primaryColor }
        tableView.register(cellWithClass: UITableViewCell.self)
        return tableView
    }()
    
    var index = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.tableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.tableView.frame = self.bounds
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        .init(width: Metric.width, height: Metric.height)
    }

}

extension SinceView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Since.allValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: UITableViewCell.self)
        cell.selectionStyle = .none
        if #available(iOS 14.0, *) {
            var config = cell.defaultContentConfiguration()
            config.textProperties.font = .normal(15)
            config.text = Since.allValues[indexPath.row].title
            cell.contentConfiguration = config
        } else {
            cell.textLabel?.font = .normal(15)
            cell.textLabel?.text = Since.allValues[indexPath.row].title
        }
        var line = cell.viewWithTag(Metric.tag)
        if line == nil {
            line = UIImageView.init(
                frame: .init(x: 10, y: Metric.height / 3.0 - pixelOne, width: Metric.width - 10, height: pixelOne)
            )
            line?.tag = Metric.tag
            line?.theme.backgroundColor = themeService.attribute { $0.headerColor }
            cell.addSubview(line!)
        }
        line?.isHidden = indexPath.row == 2
        cell.accessoryType = indexPath.row == self.index ? .checkmark : .none
        return cell
    }
    
}

extension SinceView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.index = indexPath.row
        tableView.reloadData()
    }
}
