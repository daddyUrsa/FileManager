//
//  ViewController.swift
//  FileManager
//
//  Created by Alexey Pavlov on 17.03.2021.
//

import UIKit

class ViewController: UIViewController {
    let fileManager = FileManagerService()
    var files = [(String, File)]()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped )
        let queue = DispatchQueue.global(qos: .utility)
        tableView.dataSource = self
//        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .brown
        setupViews()
        fileManager.createFile(containing: "jasdvdfbdfb", to: "Documents", withName: "text.txt")
        fileManager.createFile(containing: "sdsagwegrerwgwreg", to: "Documents", withName: "text2.txt")
        fileManager.createFile(containing: "Jjskdv;;s", to: "Folder1", withName: "text3.txt")
        fileManager.createDirectory(to: "Documents", withName: "Folder1")
        files = fileManager.listFiles(in: "Documents")
    }
    
    func setupViews() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = files[indexPath.row].0
        if files[indexPath.row].1 == .folder {
            cell.imageView?.image = #imageLiteral(resourceName: "directory")
        } else if files[indexPath.row].1 == .file {
            cell.imageView?.image = #imageLiteral(resourceName: "file")
        }
        
        return cell
    }
    
    
}
