# Git履歴

このリポジトリは、`main`を常にGreenの状態に保ちつつ、バグ状態と最小修正を別コミットとして残します。

| コミット | 種別 | 学習上の意味 |
| --- | --- | --- |
| `cc00582` | 初期構成 | Nuxt 4.5.2、Node.js要件、最小アプリケーションを用意する |
| `c6f27f8` | バグ導入 | 入力エラーJSONを通常の戻り値として返し、HTTP `200`になる状態を再現する |
| `8d25fa2` | 修正 | `throw createError(...)`に置き換え、HTTP `400`と`data.code`を返す |
| この文書コミット | 教材資料 | 章ガイド、観測記録、検証スクリプト、CIを追加する |

バグ状態を観測するには次を実行します。

```bash
git checkout c6f27f8
npm ci
npm run test:chapter-01
```

完成状態へ戻るには次を実行します。

```bash
git switch main
npm ci
npm run verify
```
