//
//  ViewController.swift
//  CoreData vs Realm
//
//  Created by Faizan Memon on 20/09/22.
//

import UIKit

enum DatabaseType {
    case coreData
    case realm
}

class ViewController: UIViewController {

    @IBOutlet weak var databaseSwitch: UISwitch!
    @IBOutlet weak var createEntriesTextField: UITextField!
    @IBOutlet weak var createEntriesActionButton: UIButton!
    @IBOutlet weak var readEntriesTextField: UITextField!
    @IBOutlet weak var readEntriesActionButton: UIButton!
    @IBOutlet weak var updateEntriesTextField: UITextField!
    @IBOutlet weak var updateEntriesActionButton: UIButton!
    @IBOutlet weak var deleteEntriesActionButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!

    var viewModel: ViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        viewModel = ViewModel(delegate: self, viewContext: appDelegate.persistentContainer.viewContext)
        databaseSwitch.addTarget(
            self,
            action: #selector(switchChanged),
            for: UIControl.Event.valueChanged
        )

    }

    @IBAction func createEntriesButtonClicked(_ sender: Any) {
        viewModel.createEntries(Int(createEntriesTextField.text ?? "0") ?? 0)
        createEntriesTextField.resignFirstResponder()
        createEntriesTextField.text = ""
    }

    @IBAction func readEntriesButtonClicked(_ sender: Any) {
        viewModel.readEntries(Int(readEntriesTextField.text ?? "0") ?? 0)
        readEntriesTextField.resignFirstResponder()
        readEntriesTextField.text = ""
    }

    @IBAction func updateEntriesButtonClicked(_ sender: Any) {
        viewModel.updateEntries(Int(updateEntriesTextField.text ?? "0") ?? 0)
        updateEntriesTextField.resignFirstResponder()
        updateEntriesTextField.text = ""
    }

    @IBAction func deleteEntriesButtonClicked(_ sender: Any) {
        viewModel.deleteEntries()
    }

    @objc func switchChanged(mySwitch: UISwitch) {
        viewModel.updateSelectedDB(mySwitch.isOn ? .coreData : .realm)
    }
}


extension ViewController: ViewModelDelegate {
    func createActionCompleted(timeTaken: Int64) {
        resultLabel.text = "Create action completed in \(timeTaken.description) ms"
    }

    func readActionCompleted(timeTaken: Int64) {
        resultLabel.text = "Read action completed in \(timeTaken.description) ms"
    }

    func updateActionCompleted(timeTaken: Int64) {
        resultLabel.text = "update action completed in \(timeTaken.description) ms"
    }

    func deleteActionCompleted(timeTaken: Int64) {
        resultLabel.text = "delete action completed in \(timeTaken.description) ms"
    }
}
