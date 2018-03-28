//
//  WarningsViewController.swift
//  ownCloud
//
//  Created by Pablo Carrascal on 14/03/2018.
//  Copyright © 2018 ownCloud GmbH. All rights reserved.
//

import UIKit
import ownCloudSDK
import ownCloudUI

class IssuesViewController: UIViewController {

    internal let issuesTableView: UITableView = UITableView()
    public let bottomContainer: UIView = UIView()
    private var issues: [OCConnectionIssue] = []
    private var tableHeighConstraint: NSLayoutConstraint?
    private var headerTitle: String?
    private var completionHandler: (() -> Void)?

    private var modalPresentationVC: UIViewControllerTransitioningDelegate?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupTransitions()
    }

    init(issues: [OCConnectionIssue]?, headerTitle: String?, completionHandler: (() -> Void)? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.headerTitle = headerTitle
        self.completionHandler = completionHandler
        if issues != nil {
            self.issues = issues!
        }
        self.setupTransitions()
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)

        if let completionHandler = completionHandler {
            completionHandler()
        }
    }

    private func setupTransitions() {
        self.modalPresentationStyle = .custom
        let transitioningDLG = IssuesTransitioningDelegate()
        self.modalPresentationVC = transitioningDLG
        self.transitioningDelegate = transitioningDLG
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        issuesTableView.delegate = self
        issuesTableView.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bottomContainer)

        bottomContainer.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        bottomContainer.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        bottomContainer.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        bottomContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        bottomContainer.contentHuggingPriority(for: .vertical)

        issuesTableView.translatesAutoresizingMaskIntoConstraints = false
        issuesTableView.layer.cornerRadius = 10
        issuesTableView.backgroundColor = UIColor(hex: 0xF2F2F2)
        issuesTableView.bounces = false
        issuesTableView.showsVerticalScrollIndicator = false

        self.view.addSubview(issuesTableView)

        issuesTableView.bottomAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: -20).isActive = true
        issuesTableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        issuesTableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        issuesTableView.topAnchor.constraint(greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        tableHeighConstraint = issuesTableView.heightAnchor.constraint(equalToConstant: issuesTableView.contentSize.height)
        tableHeighConstraint?.isActive = true

        issuesTableView.tableHeaderView?.backgroundColor = UIColor.white
    }

    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tableHeighConstraint?.constant =  self.issuesTableView.contentSize.height
    }

    func addBottomContainerElements(elements: [UIView]) {
        for element in elements {
            self.bottomContainer.addSubview(element)
        }
    }

    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension IssuesViewController: UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        guard self.headerTitle != nil else {
            return 0
        }

        return 40
    }
}

extension IssuesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.backgroundColor = .white
        cell.textLabel?.attributedText = NSAttributedString(string: self.headerTitle!, attributes: [.font : UIFont.systemFont(ofSize: 20, weight: .semibold)])

        let separatorView: UIView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = UIColor(hex: 0x04040F)
        cell.addSubview(separatorView)
        separatorView.heightAnchor.constraint(equalToConstant: 0.25).isActive = true
        separatorView.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 0).isActive = true
        separatorView.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: 0).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: 0).isActive = true

        cell.layoutSubviews()

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return issues.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let issue: OCConnectionIssue = issues[indexPath.row]

        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.accessoryView?.backgroundColor = .blue

        var color: UIColor = .black

        switch issue.level {
        case .warning:
            color = UIColor(hex: 0xF2994A)
        case .informal:
            color = UIColor(hex: 0x27AE60)
        case .error:
            color = UIColor(hex: 0xEB5757)
        }

        cell.textLabel?.attributedText = NSAttributedString(string: issue.localizedTitle, attributes: [
            .foregroundColor : color,
            .font : UIFont.systemFont(ofSize: 18, weight: .semibold)
            ])

        cell.detailTextLabel?.attributedText = NSAttributedString(string: issue.localizedDescription, attributes: [
                .foregroundColor : UIColor(hex: 0x4F4F4F),
                .font : UIFont.systemFont(ofSize: 15, weight: .regular)
            ])
        cell.detailTextLabel?.numberOfLines = 0
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let issue: OCConnectionIssue = issues[indexPath.row]

        if issue.type == .certificate {
            OCCertificateDetailsViewNode .certificateDetailsViewNodes(for: issue.certificate, withValidationCompletionHandler: { (certificateNodes) in
                let certDetails: NSAttributedString = OCCertificateDetailsViewNode .attributedString(withCertificateDetails: certificateNodes)
                DispatchQueue.main.async {
                    let issuesVC = CertificateViewController(certificateDescription: certDetails)
                    issuesVC.modalPresentationStyle = .overCurrentContext
                    self.present(issuesVC, animated: true, completion: nil)
                }
            })
        }
    }
}

internal class IssuesTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return IssuesPresentationAnimator()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return IssuesDismissalAnimator()
    }
}