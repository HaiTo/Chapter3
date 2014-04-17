# Ruby on Rails :チュートリアル
これはRoRTutorialのサンプルあぷりけーしょんです。
[*Ruby on Rails Tutorial*](http://railstutorial.jp) by [MichaelHartl](http://michaelhartl.com).  
  
  
## Chapter11(全Chapter)終了

## Training
Reply機能の実装  

  + @user_id の一意性
  + micropostに in_reply_to Columnの追加
    + rails g migration add_column_in_reply_to_to_micropost でどうでしょう
  + 入力されたMicropostを @user_id で抜き出す正規表現　/(@\w*)/i　
  + 正規表現で@をさらに抜いて、それがUsersに存在するなら、in_reply_toに挿入、かな。

* MicropostModel上に実装すべき？　コントローラーではなく。validateみたいな感じ。
* Specとしてかけねぇ……
  