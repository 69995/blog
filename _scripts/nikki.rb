# nikki/ フォルダの日記ファイルを、Jekyll の記事（_posts）に変換するスクリプト。
# GitHub Actions のビルド中に自動で動きます。
#
# 日記ファイルの書き方：
#   ファイル名  2026-10-07.md（日付だけ。拡張子 .md はあってもなくても可）
#               同じ日に2つ書くときは 2026-10-07-2.md のように末尾に何か付ける
#   1行目      「title: タイトル」と書くとタイトルになる（なくてもよい）
#   それ以降    本文（Markdown）
require "fileutils"
require "json"

src = File.join(__dir__, "..", "nikki")
dst = File.join(__dir__, "..", "_posts")
FileUtils.mkdir_p(dst)

used = Hash.new(0)
Dir.children(src).sort_by { |n| n.sub(/\.(md|markdown|txt)\z/, "") }.each do |name|
  path = File.join(src, name)
  next unless File.file?(path)
  m = name.match(/\A(\d{4})-(\d{1,2})-(\d{1,2})(.*?)(\.(md|markdown|txt))?\z/)
  unless m
    warn "skip: #{name}（ファイル名が日付で始まっていません）"
    next
  end
  y, mo, d = m[1], m[2].rjust(2, "0"), m[3].rjust(2, "0")
  text = File.read(path, encoding: "UTF-8").sub(/\A﻿/, "").gsub("\r\n", "\n")

  # 既に --- で囲んだ書き方をしている場合は、中の title: を拾う
  title = nil
  if text.start_with?("---\n") && (fm_end = text.index("\n---", 4))
    fm = text[4...fm_end]
    title = fm[/^title:\s*(.+)$/, 1]
    text = text[(fm_end + 4)..].to_s.sub(/\A\n/, "")
  elsif (t = text[/\A[ \t]*title[:：][ \t]*(.*)$/, 1])
    title = t.strip
    text = text.sub(/\A.*\n?/, "")
  end
  title = title.to_s.strip.sub(/\A["'](.*)["']\z/, '\1')

  ymd = "#{y[2..]}#{mo}#{d}"
  used[ymd] += 1
  slug = used[ymd] == 1 ? ymd : "#{ymd}-#{used[ymd]}"
  headline = title.empty? ? ymd : "#{ymd}-#{title}"

  front = {
    "title" => title.empty? ? ymd : title,
    "headline" => headline,
    "permalink" => "/#{slug}/",
    "source_file" => "nikki/#{name}",
  }
  yaml = front.map { |k, v| "#{k}: #{v.to_s.to_json}" }.join("\n")
  File.write(File.join(dst, "#{y}-#{mo}-#{d}-#{slug}.md"), "---\n#{yaml}\n---\n#{text}")
  puts "ok: #{name} -> /#{slug}/"
end
