@echo off

rem 初期化.
chcp 65001
set /a i=1

rem コンパイル.
if "%1"=="" (
    echo ファイル名が書かれてないよ...？
    exit
)
if not exist %1 (
    echo ファイルが存在しないよ...？
    exit
)
echo コンパイル中だよ、少し待ってね!
g++ -I ../ %1 -std=c++17

rem URLが存在すれば入力例のダウンロード.
if not "%2"=="" (
    echo URLの入力例を取得中...
    rmdir /s /q test
    oj d %2 > nul
)

rem test/sample-{n}.inが存在しなくなるまでループ.
:loop
if not exist "test\sample-%i%.in" goto end

rem 仕切り
echo --------------------------------

rem 実行結果を.resultファイルに格納.
cat test/sample-%i%.in | a.exe > test/sample-%i%.result

rem ファイルの一致の確認.
cd test
fc.exe /w sample-%i%.out sample-%i%.result > nul
if errorlevel 1 (
    echo [41m[1m[97m WA [0m
) else (
    echo [42m[1m[97m AC [0m
)
echo test/sample-%i%.outとtest/sample-%i%.resultを見比べてね!
cd ..

rem ループ.
set /a i+=1
goto loop
:end

rem 終了.
echo テストが完了しました!