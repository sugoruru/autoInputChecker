@echo off
chcp 65001 > nul

if "%1"=="test" goto test
if "%1"=="version" goto version
if "%1"=="help" goto help
if "%1"=="new" goto new
exit

rem バージョン
:version
echo α1.0.0
exit




rem ヘルプ
:help
echo usage: aic.bat {version, help, test, new}
exit




rem ディレクトリの作成.
:new
rem 初期化.
set alphabet=abcdefghijklmnopqrstuvwxyz
set /a i=0
set checkContestName=FALSE

rem abc,arc,agc,ahc以外の言葉を禁止.
if %2==abc set checkContestName=TRUE
if %2==arc set checkContestName=TRUE
if %2==agc set checkContestName=TRUE
if %2==ahc set checkContestName=TRUE
if %checkContestName%==FALSE (
    echo %2は使えないよ!
    exit
)

rem コンテストのhttpステータスの取得.
FOR /F %%i in ('curl.exe -s -k -I -L -o nul -w "%%{http_code}" "https://atcoder.jp/contests/%2%3/tasks"') DO SET http_code=%%i
if not %http_code%==200 (
    echo コンテストが開始していないか存在しないよ!
    exit
)

rem 新しいフォルダの作成.
if exist %2%3 rmdir /s /q %2%3
md %2%3

rem loop.
:new-loop

rem Aからいくつの問題があるか.
call set str=%%alphabet:~%i%,1%%
FOR /F %%a in ('curl.exe -s -k -I -L -o nul -w "%%{http_code}" "https://atcoder.jp/contests/%2%3/tasks/%2%3_%str%"') DO SET http_code=%%a
if not %http_code%==200 goto new-end

rem 問題フォルダの作成.
md %2%3\%str%
type nul > %2%3\%str%\main.cpp

rem テストケースの取得.
echo %2%3の%str%問題のテストケースを取得中...
cd %2%3\%str%
oj d https://atcoder.jp/contests/%2%3/tasks/%2%3_%str% > nul
cd ..\..\

set /a i+=1
goto new-loop

:new-end
echo 終了しました!
exit

rem テスト.
:test
rem 初期化.
set /a i=1
set /a is_all_ac=1
setlocal enabledelayedexpansion

rem コンパイル.
if not exist %2\%3\main.cpp (
    echo フォルダが存在しないよ!
    exit
)
echo コンパイル中だよ、少し待ってね!
g++ -I ../ %2\%3\main.cpp -std=c++17 -o %2\%3\main

rem もしtestディレクトリが存在しなければ入力例のダウンロード.
if not exist %2\%3\test\ (
    echo 入力例のダウンロード中...
    cd %2\%3\
    oj d https://atcoder.jp/contests/%2/tasks/%2_%3 > nul
    cd ..\..\
)

rem test/sample-{n}.inが存在しなくなるまでループ.
:test-loop
if not exist %2\%3\test\sample-%i%.in goto test-end

rem 仕切り.
echo --------------------------------
echo sample-%i%

rem 実行結果を.resultファイルに格納.
type %2\%3\test\sample-%i%.in | %2\%3\main.exe > %2\%3\test\sample-%i%.result

rem ファイルの一致の確認.
cd %2\%3\test\
fc.exe /w sample-%i%.out sample-%i%.result > nul
if errorlevel 1 (
    echo [41m[1m[97m WA [0m
    echo;
    echo [91m[1manswer[0m:
    for /f %%a in (sample-%i%.out) do (
        echo %%a
    )
    echo;
    echo [91m[1myour result[0m:
    for /f %%a in (sample-%i%.result) do (
        echo %%a
    )
    set /a is_all_ac=0
) else (
    echo [42m[1m[97m AC [0m
)
cd ..\..\..\

rem ループ.
set /a i+=1
goto test-loop

:test-end
echo テストが完了しました!

rem 自動提出機能.
if %is_all_ac%==1 (
    choice /C:YN /M:"提出しますか？"
    if !errorlevel!==1 (
        oj login https://atcoder.jp
        oj s https://atcoder.jp/contests/%2/tasks/%2_%3 %2\%3\main.cpp
    )
)

exit
