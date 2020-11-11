//
//  ArticleWebView.swift
//  DailyNews
//
//  Created by Mathias Korsbäck on 2020-11-11.
//

import WebKit

class ArticleWebView: UIViewController {

  var urlString: String!

  override func viewDidLoad() {
    super.viewDidLoad()

    let webView = WKWebView(frame: view.frame)
    view.addSubview(webView)
    webView.load(URLRequest(url: URL(string: urlString)!))
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.prefersLargeTitles = false
  }
}

