//
//  ArticleWebViewController.swift
//  DailyNews
//
//  Created by Mathias Korsbäck on 2020-11-11.
//

import WebKit

class ArticleWebViewController: UIViewController {

  var urlString: String!
  let webView = WKWebView()

  override func viewDidLoad() {
//    super.viewDidLoad()

//    view.addSubview(webView)
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
    view = webView
    webView.load(URLRequest(url: URL(string: urlString)!))
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.prefersLargeTitles = false
  }

  @objc private func share() {
    if let url = URL(string: urlString) {
      let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
      present(activityVC, animated: true, completion: nil)
    }
  }

}
