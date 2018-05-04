//
//  PasscodeViewController.swift
//  ownCloud
//
//  Created by Javier Gonzalez on 03/05/2018.
//  Copyright © 2018 ownCloud GmbH. All rights reserved.
//

import UIKit

enum PasscodeMode {
    case addPasscodeFirstStep
    case addPasscodeSecondStep
    case unlockPasscode
    case deletePasscode
}

class PasscodeViewController: UIViewController, Themeable {

    var passcodeFromFirstStep: String?
    var passcodeMode: PasscodeMode?

    @IBOutlet weak var messageLabel: UILabel?
    @IBOutlet weak var passcodeValueTextField: UITextField?

    @IBOutlet weak var number0Button: ThemeButton?
    @IBOutlet weak var number1Button: ThemeButton?
    @IBOutlet weak var number2Button: ThemeButton?
    @IBOutlet weak var number3Button: ThemeButton?
    @IBOutlet weak var number4Button: ThemeButton?
    @IBOutlet weak var number5Button: ThemeButton?
    @IBOutlet weak var number6Button: ThemeButton?
    @IBOutlet weak var number7Button: ThemeButton?
    @IBOutlet weak var number8Button: ThemeButton?
    @IBOutlet weak var number9Button: ThemeButton?

    @IBOutlet weak var cancelButton: ThemeButton?

    init(mode: PasscodeMode, passcodeFromFirstStep: String?) {
        super.init(nibName: "PasscodeViewController", bundle: nil)
        self.passcodeFromFirstStep = passcodeFromFirstStep
        self.passcodeMode = mode
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        Theme.shared.register(client: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }

    override func viewDidLoad() {
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        self.loadInterface()

        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Interface

    func loadInterface() {
        switch self.passcodeMode {
        case .addPasscodeFirstStep?:
            self.messageLabel?.text = "Insert your code".localized

        case .addPasscodeSecondStep?:
            self.messageLabel?.text = "Reinsert your code".localized

        case .unlockPasscode?:
            self.messageLabel?.text = "Insert your code".localized

        case .deletePasscode?:
            self.messageLabel?.text = "Delete code".localized

        default:
            break
        }
    }

    // MARK: - Actions

    @IBAction func cancelButton(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func numberButton(sender: UIButton) {
        if let passcodeValue = self.passcodeValueTextField?.text {
            self.passcodeValueTextField?.text = passcodeValue + String(sender.tag)
        } else {
            self.passcodeValueTextField?.text = String(sender.tag)
        }
    }

    // MARK: - Themeing

    func applyThemeCollection(theme: Theme, collection: ThemeCollection, event: ThemeEvent) {

        self.view.backgroundColor = collection.tableBackgroundColor

        self.messageLabel?.applyThemeCollection(collection)
        self.passcodeValueTextField?.applyThemeCollection(collection)

        self.number0Button?.themeColorCollection = collection.neutralColors
        self.number1Button?.themeColorCollection = collection.neutralColors
        self.number2Button?.themeColorCollection = collection.neutralColors
        self.number3Button?.themeColorCollection = collection.neutralColors
        self.number4Button?.themeColorCollection = collection.neutralColors
        self.number5Button?.themeColorCollection = collection.neutralColors
        self.number6Button?.themeColorCollection = collection.neutralColors
        self.number7Button?.themeColorCollection = collection.neutralColors
        self.number8Button?.themeColorCollection = collection.neutralColors
        self.number9Button?.themeColorCollection = collection.neutralColors

        self.cancelButton?.themeColorCollection = collection.neutralColors
    }
}