yahooボックスの一括ダウンロードスクリプトです

こちらを思いっきり参考にさせていただいています
http://lp6m.hatenablog.com/entry/2016/08/12/184232


で、使い方なのですが、まず用意するのは２つです
・Chrome
・Rubyをつかえる環境

# chromeの用意
Chromeを開いて
https://webkaru.net/dev/google-chrome-extension-editthiscookie/
を入れましょう

# クッキーの表示とソースコードへの反映
https://box.yahoo.co.jp/user/viewer
にアクセスした後、右上のクッキーマークを押してください

こんな感じになるはず
https://2.bp.blogspot.com/-tOl34RX05fc/WlIbwnmNYVI/AAAAAAAAEk8/PU-1onZzHy0wDBANE7PMsMV72jXN5TXCACLcBGAs/s1600/unnamed.png

この「値」のパラメータを
https://github.com/hatano0x06/yahoobox_donwloader/blob/master/yahoo_box.rb#L31-L56
に入れてください

:nameを間違えないようにしてください

# sidとかの表示と反映
まず、デベロッパーツールを開いてください
https://1.bp.blogspot.com/-H_5i-FHbGjA/WlIbwtwjx7I/AAAAAAAAElE/hjiAp_UVc78ex07jZmbV1UpVexiooxVuQCLcBGAs/s1600/unnamed2.png
で、次に
sourceのviewerのこちらの該当箇所を開いてください
https://4.bp.blogspot.com/-3Bmj7-VejDA/WlIbwtFwvHI/AAAAAAAAElA/OXw8RdV3F6krnDhAE1QtqvZLjNaZbm82QCLcBGAs/s1600/unnamed3.png

中身は
```
var PARMS = {'sid':"",'uniqid':"",'viewtype':"",'listformat':"",'query':"",'status':"",'rt':"0",'rf':"", 'tmp':"jhasdfgjkasdgf"},
    User  = {'sid':"box-l-jhasdfgjkasdgf-1001", 'uniqid':"jhasdfgjkasdgf-b87b-4e74-a54c-jhasdfgjkasdgf"},
    INIT  = {'guid':"jhasdfgjkasdgf",'bcrumb':"jhasdfgjkasdgf==",'browser':"Chrome",'version':"0.0",'slideshow':"supported", 
             'appid':'jhasdfgjkasdgf--',
             'tmp':"1515329770"};

```

ここの
Userのsidをソースコードのsidに
Userのuniqidをソースコードのtopuniqidに
INITのbcrumbをソースコードのcrumbに
INITのappidをソースコードのappidに
反映してください
https://github.com/hatano0x06/yahoobox_donwloader/blob/master/yahoo_box.rb#L19-L22


##　実行
あとは
$ ruby ファイル名
で実行されます

終わるまで星座待機
