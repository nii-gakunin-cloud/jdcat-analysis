// plainify.js
const fs = require("fs");
const { chromium } = require("playwright");

(async () => {
  const url = process.argv[2];
  const outFile = process.argv[3];
  if (!url || !outFile) {
    console.error("使い方: node plainify.js <URL> <出力ファイル>");
    process.exit(1);
  }

  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage();
  await page.goto(url, { waitUntil: "networkidle", timeout: 120000 });

  await page.addScriptTag({
    content: `
      (() => {
        document.querySelectorAll('style, link[rel="stylesheet"]').forEach(el => el.remove());
        document.querySelectorAll('*[style]').forEach(el => el.removeAttribute('style'));
        document.querySelectorAll('script, noscript').forEach(el => el.remove());
      })();
    `,
  });

  const bodyHTML = await page.evaluate(() => document.body.innerHTML);
  await browser.close();

  const doc = `<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>プレーンHTML版</title>
</head>
<body>
${bodyHTML}
</body>
</html>`;

  fs.writeFileSync(outFile, doc, "utf8");
})();

