# blog

ha_watanabeのブログ

## 公開URL

https://69995.github.io/blog/

（リポジトリの「Settings」→「Pages」で、Branch を「main」「/ (root)」にして公開しています）

## 記事を書く

`_posts` フォルダの中に、次の名前で新しいファイルを作ります。

```
2026-10-07-なにか英数字.md
```

- 先頭の日付が記事の日付になり、タイトルの頭に `261007-` の形で付きます
- 日付のあとの部分はURLになるので、英数字とハイフンにしておくと安全です

ファイルの中身はこう書きます。

```
---
title: 記事のタイトル
---
ここから本文。Markdownで書けます。
```

GitHub の画面なら、`_posts` フォルダを開いて「Add file」→「Create new file」から書いて「Commit changes」を押すだけで公開されます（反映まで1〜2分）。

## 記事を直す・消す

`_posts` の中のファイルを開いて、鉛筆アイコンで編集、または「…」→「Delete file」。

## 色を変える

`assets/style.css` の先頭にある `--ink`（文字色）と `--bg`（背景色）を書き換えます。

## フォントについて

本文のドット文字は「東雲ゴシック12」（パブリックドメイン）の JF ドットフォント版を、jsDelivr（npm パッケージ @fontpkg/jf-dot-shinonome-gothic-12）から読み込んでいます。
