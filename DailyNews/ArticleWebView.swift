//
//  ArticleWebView.swift
//  DailyNews
//
//  Created by Mathias Korsbäck on 2020-11-11.
//

import WebKit

class ArticleWebView: UIViewController {

  var urlString: String!
  let webView = WKWebView()

  override func viewDidLoad() {
//    super.viewDidLoad()

//    view.addSubview(webView)
    view = webView
    webView.load(URLRequest(url: URL(string: urlString)!))
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.prefersLargeTitles = false
  }
}

