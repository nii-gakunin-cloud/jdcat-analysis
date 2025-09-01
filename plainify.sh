#!/usr/bin/env bash
# plainify.sh
# URLリスト (urls.txt) をもとにプレーンHTMLをまとめて生成

set -euo pipefail

LIST_FILE="urls.txt"
OUTDIR="./output"
mkdir -p "$OUTDIR"

if [ ! -f "$LIST_FILE" ]; then
  echo "URLリスト $LIST_FILE が見つかりません"
  exit 1
fi

while IFS= read -r URL; do
  # 空行や # で始まる行はスキップ
  [[ -z "$URL" || "$URL" =~ ^# ]] && continue

  # 出力ファイル名をURLから生成（ドメイン以下を_で置換）
  SAFE_NAME=$(echo "$URL" | sed -E 's#https?://##; s#[^a-zA-Z0-9]+#_#g')
  OUTFILE="$OUTDIR/${SAFE_NAME}.html"

  echo "変換中: $URL → $OUTFILE"
  node plainify.js "$URL" "$OUTFILE"
done < "$LIST_FILE"

echo " 全ページ処理完了 (出力先: $OUTDIR)"
