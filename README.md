# できること
AtCoderのサンプルケースを自動でダウンロードし、AC or WAの判定

# 必要なコマンド
[online-judge-tools(ojコマンド)](https://github.com/online-judge-tools/oj/blob/master/docs/INSTALL.ja.md)  
[MinGW(g++)](https://www.mingw-w64.org/)

# 使い方
## バージョンの出力
```bat
./aic.bat version
```

## ヘルプの表示
```bat
./aic.bat help
```

## 新しいディレクトリの作成
```bat
./aic.bat new [abc|arc|agc|ahc] [n]
```
例えば、abcの90回を取得したければ、以下のようにしてください
```bat
./aic.bat new abc 090
```

## 実行テスト
```bat
./aic.bat test [contestID] [problemID]
```
例えば、abc090のa問題をテストしたければ、以下のようにしてください
```
./aic.bat test abc090 a
```
