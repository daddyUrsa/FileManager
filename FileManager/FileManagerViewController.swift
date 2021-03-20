//
//  FileManagerViewController.swift
//  FileManager
//
//  Created by Alexey Pavlov on 17.03.2021.
//

import UIKit

var currentFolder: URL = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)[0]

class FileManagerViewController: UIViewController {
    let fileManager = FileManagerService()
    var files = [(String, File)]()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped )
        let queue = DispatchQueue.global(qos: .utility)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .brown
        setupViews()
        files = fileManager.listFiles(in: currentFolder)
//        print(currentFolder)
//        navigationController?.navigationBar.backItem?
        let menuButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(didTapMenuButton))
        let addFileButton = UIBarButtonItem(image: #imageLiteral(resourceName: "addFile"), style: .plain, target: self, action: #selector(didTapMenuButton))
        let addFolderButton = UIBarButtonItem(image: #imageLiteral(resourceName: "addDirectory"), style: .plain, target: self, action: #selector(didTapMenuButton))
        navigationItem.leftBarButtonItem = menuButton
        navigationItem.rightBarButtonItems = [addFileButton, addFolderButton]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if navigationController?.viewControllers.count == 1 {
            navigationItem.setLeftBarButton(nil, animated: true)
        }
    }

    @objc public func didTapMenuButton() {
        navigationController?.popViewController(animated: true)
        currentFolder.deleteLastPathComponent()
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

extension FileManagerViewController: UITableViewDataSource {
    
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

extension FileManagerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newVC = FileManagerViewController()
        if files[indexPath[1]].1 == .folder {
            currentFolder.appendPathComponent(files[indexPath[1]].0)
            print(currentFolder)
            navigationController?.pushViewController(newVC, animated: true)
        } else if files[indexPath[1]].1 == .file {
            var textFile: URL = currentFolder
            textFile.appendPathComponent(files[indexPath[1]].0)
            let textFromFile = try! String(contentsOf: textFile, encoding: .utf8)
            let textViewVC = TextFileViewController()
            textViewVC.textView.text = textFromFile
            navigationController?.pushViewController(textViewVC, animated: true)
        }
        print(files[indexPath[1]].0)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] _, _, complete in
            print("Swiped")
            complete(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}
