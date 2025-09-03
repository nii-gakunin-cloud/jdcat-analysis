// plainify-remove-assets-batch.js
import fs from "fs";
import path from "path";
import * as cheerio from "cheerio";

const inputDir = "./input";   // 元のHTMLファイルを置くディレクトリ
const outputDir = "./output"; // clean版を出力するディレクトリ

// ← 残したい CSS プロパティをここで指定
const allowedStyleProps = ["border", "text-align"]; 
//const allowedStyleProps = ["border", "width", "height", "color", "background"];

if (!fs.existsSync(outputDir)) {
  fs.mkdirSync(outputDir, { recursive: true });
}

const files = fs.readdirSync(inputDir).filter(f => f.endsWith(".html"));

for (const file of files) {
  const inputPath = path.join(inputDir, file);
  const outputPath = path.join(outputDir, file);

  const html = fs.readFileSync(inputPath, "utf-8");
  const $ = cheerio.load(html);

  // 外部JSとCSSを削除
  $("script[src]").remove();
  $("link[rel='stylesheet']").remove();

  // class と id を削除
  $("*").each((_, el) => {
    $(el).removeAttr("class");
    $(el).removeAttr("id");

    // style のフィルタリング
    const style = $(el).attr("style");
    if (style) {
      const filtered = style
        .split(";")
        .map(s => s.trim())
        .filter(s =>
          allowedStyleProps.some(prop => s.toLowerCase().startsWith(prop))
        )
        .join("; ");
      if (filtered) {
        $(el).attr("style", filtered);
      } else {
        $(el).removeAttr("style");
      }
    }
  });

  fs.writeFileSync(outputPath, $.html(), "utf-8");

  console.log(`✅ Cleaned: ${inputPath} → ${outputPath}`);
}

console.log("🎉 全ファイルの処理が完了しました！");

