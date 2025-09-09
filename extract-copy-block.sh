#!/bin/bash
# extract-blocks.sh
# HTMLコメント <!-- Start --> / <!-- ここから --> ... <!-- End --> / <!-- ここまで --> を抽出して 1行テキスト化

LIST="htmls.txt"
OUTDIR="forCMS"

mkdir -p "$OUTDIR"

# 入力ファイル一覧を決定
if [ -f "$LIST" ]; then
  sed -i 's/\r//' "$LIST"
  mapfile -t FILES < <(grep -vE '^\s*#' "$LIST" | grep -vE '^\s*$')
else
  if [ $# -lt 1 ]; then
    echo "❌ htmls.txt が無い場合は、ファイルを直接指定してください"
    echo "例: ./extract-blocks.sh input.html"
    exit 1
  fi
  FILES=("$@")
fi

for file in "${FILES[@]}"; do
  if [ ! -f "$file" ]; then
    echo "⚠️ ファイルが見つかりません: $file"
    continue
  fi

  base=$(basename "$file" .html)
  block=0

  awk -v base="$base" -v OUTDIR="$OUTDIR" '
    /<!--[[:space:]]*(Start|ここから)[[:space:]]*-->/ {inside=1; next}
    /<!--[[:space:]]*(End|ここまで)[[:space:]]*-->/ {
      inside=0
      block++
      if (out != "") {
        fname=sprintf("%s/%s_%d.txt", OUTDIR, base, block)
        print out > fname
        close(fname)
        out=""
        printf "✅ Extracted: %s → %s\n", FILENAME, fname > "/dev/stderr"
      }
      next
    }
    inside {
      gsub(/^[ \t]+/, "", $0)   # 行頭スペース・タブ削除
      out=out $0                 # 改行なしで連結
    }
  ' "$file"
done

echo "🎉 全ファイル処理完了！"
