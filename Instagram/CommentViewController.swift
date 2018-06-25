//
//  CommntViewController.swift
//  Instagram
//
//  Created by mayuka on 2018/06/19.
//  Copyright © 2018年 miriaria0427. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

class CommentViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentText: UITextField!
    
    var postData:PostData!
    
    //投稿ボタンが押された時の処理
    @IBAction func hundlePostButton(_ sender: Any) {
        
        //テキストボックスにコメントが入力されているかチェック(空文字入力されている時は空文字を削除する)
        if let displayComment = commentText.text?.trimmingCharacters(in: .whitespaces){
            //コメントが入力されていない時はHUDを出して何もしない
            if displayComment.isEmpty {
                SVProgressHUD.showError(withStatus: "コメントを入力して下さい")
                return
            }
            // 表示名を取得する
            let name = Auth.auth().currentUser?.displayName
            //配列の要素に追加する
            postData?.comment.append(["name":name!,"comment":displayComment])
            
            // 投稿したcommentをFirebaseに保存する
            let postRef = Database.database().reference().child(Const.PostPath).child((postData?.id!)!)
            let postComment = ["comment": postData.comment]
            postRef.updateChildValues(postComment)
            //コメント投稿完了
            SVProgressHUD.showSuccess(withStatus: "コメントを投稿しました")
            //画面を閉じる
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //キャンセルボタンが押された時の処理
    @IBAction func hundleCancelButton(_ sender: Any) {
        // 画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    // データの数（＝セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let postComment = postData.comment
        print(postComment.count)
        return postComment.count
    }
    
    // 各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用可能な cell を得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //postDataの登録がある場合、データの内容をセルのテキストに登録する
        if([postData?.comment] != [[]]){
            //print([[postData?.comment]])
            cell.textLabel?.text = postData?.comment[indexPath.row]["name"]
            cell.detailTextLabel?.text = postData?.comment[indexPath.row]["comment"]
        }
        return cell
    }
    
    @objc func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
