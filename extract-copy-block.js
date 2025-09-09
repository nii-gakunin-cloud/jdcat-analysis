// extract-blocks.js
import fs from "fs";
import path from "path";

// 入力リストファイル
const listFile = "./htmls.txt";
const outputDir = "./forCMS";

// 出力ディレクトリを準備
if (!fs.existsSync(outputDir)) {
  fs.mkdirSync(outputDir, { recursive: true });
}

// 正規表現パターン
const startPattern = /<!--\s*(Start|ここから)\s*-->/;
const endPattern   = /<!--\s*(End|ここまで)\s*-->/;

// 入力ファイル一覧を決定
let inputFiles = [];
if (fs.existsSync(listFile)) {
  inputFiles = fs
    .readFileSync(listFile, "utf-8")
    .split(/\r?\n/)
    .map(l => l.trim())
    .filter(l => l && !l.startsWith("#"));
} else {
  // コマンドライン引数から指定
  if (process.argv.length < 3) {
    console.error("❌ htmls.txt が見つかりません。入力ファイルを直接指定してください。");
    console.error("例: node extract-blocks.js input.html");
    process.exit(1);
  }
  inputFiles = process.argv.slice(2);
}

for (const inputPath of inputFiles) {
  if (!fs.existsSync(inputPath)) {
    console.warn(`⚠️ ファイルが見つかりません: ${inputPath}`);
    continue;
  }

  const baseName = path.basename(inputPath, path.extname(inputPath));
  const lines = fs.readFileSync(inputPath, "utf-8").split(/\r?\n/);

  let inside = false;
  let buffer = [];
  let blockCount = 0;

  for (const line of lines) {
    if (!inside && startPattern.test(line)) {
      inside = true;
      buffer = [];
      continue; // 次の行から処理
    }
    if (inside && endPattern.test(line)) {
      inside = false;
      blockCount++;

      // 改行を消して1行にまとめる
      const result = buffer.join("");

      const outputPath = path.join(outputDir, `${baseName}_${blockCount}.txt`);
      fs.writeFileSync(outputPath, result, "utf-8");
      console.log(`✅ Extracted: ${inputPath} → ${outputPath}`);
      continue;
    }
    if (inside) {
      buffer.push(line.replace(/^[\s\t]+/, "")); // 行頭スペース/タブ削除
    }
  }

  if (blockCount === 0) {
    console.warn(`⚠️ 対象ブロックが見つかりませんでした: ${inputPath}`);
  }
}

console.log("🎉 全ファイルの処理が完了しました！");

