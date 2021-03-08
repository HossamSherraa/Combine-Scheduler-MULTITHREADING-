//
//  ViewController.swift
//  Combine Scheduler
//
//  Created by Hossam on 08/03/2021.
//

import Foundation
import UIKit
import Combine
class ViewController : UIViewController , UITableViewDataSource , UITableViewDelegate {
    var images : [UIImage?] = Array.init(repeating: nil, count: 100)
    var subscription = Set<AnyCancellable>()
    let que = OperationQueue()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        if let downloadedImage = images[indexPath.row] {
            cell.configWithImage(downloadedImage)
        }
        else {
            cell.configWithImage(UIImage(systemName: "clock.fill"))
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == max(images.count - 1 , 0){
            //            loadLast(maxLength: 25)
        }
    }
    
    lazy var  tableView = UITableView(frame: view.frame)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        
        view.addSubview(tableView)
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 240
        que.qualityOfService = .background
        
        tableView.showsVerticalScrollIndicator = false
        loadLast(maxLength: 1)
        
    }
    
    
    //InsertNewRows
    /*
     1- get number Of needed Rows
     2- get number Of Current Rows
     3- For each from currentRows + Index (0 1 2 )
     append New NIL
     addOperation
     ReloadOnCompletion
     DONE
     */
    func loadLast(maxLength : Int){
        
        images.enumerated().forEach({value in
            Just(  value.offset)
                
                
                .flatMap({ _ -> URLSession.DataTaskPublisher in
                    return URLSession.shared.dataTaskPublisher(for: URL(string: "https://picsum.photos/400/400")!)
                })
                .map(\.data)
                .map({UIImage(data:$0)})
                .receive(on: DispatchQueue.main)
                .sink { (completion) in
                    print(completion)
                } receiveValue: { (image) in
                    self.images[value.offset] = image
                    self.tableView.reloadRows(at: [.init(item: value.offset, section: 0)], with: .automatic)
                }
                .store(in: &subscription)
            
            
        })
        
    }
    
}

class TableViewCell : UITableViewCell {
    var cellImage : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(cellImage)
        cellImage.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            cellImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cellImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellImage.widthAnchor.constraint(equalToConstant: 140),
            cellImage.heightAnchor.constraint(equalToConstant: 140)
            
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configWithImage(_ image : UIImage?){
        self.cellImage.image = image
    }
    
}
