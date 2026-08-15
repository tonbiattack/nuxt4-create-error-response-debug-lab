# VS Codeで第01章のテストをデバッグする

この教材のテストは、TypeScriptを`dist/`へコンパイルしてからNode.js標準テストランナーで実行します。`.vscode/tasks.json`と`.vscode/launch.json`は、コンパイルを先に実行してから第01章のテストをブレークポイントで停止する構成です。

## 手順

1. VS Codeでリポジトリを開きます。
2. `test/tasks-api.test.ts`の`assert.equal(response.status, 400)`、または`server/api/tasks.patch.ts`の不正入力分岐にブレークポイントを設定します。
3. 実行とデバッグから**「第01章: Nuxt 4 APIテストをデバッグ」**を選びます。
4. 停止後に、`response.status`、`await response.json()`、不正入力分岐の戻り値または送出されるエラーを確認します。

## バグ状態を止める

```bash
git checkout c6f27f8
npm ci
```

この状態では不正入力分岐が通常のオブジェクトを返すため、`response.status`は`200`です。有効な`title`のテストは停止せず、正常に通過します。

## 修正後を止める

```bash
git switch main
npm ci
```

この状態では`throw createError(...)`が実行され、同じリクエストに対して`response.status`は`400`になります。

## よくある確認事項

| 事象 | 確認すること |
| --- | --- |
| ブレークポイントが灰色のまま | `npm run compile:test`が先に実行され、`dist/`のソースマップが作成されているか |
| 実行構成が見つからない | `.vscode/launch.json`を含めてリポジトリのルートを開いているか |
| テストを一つだけ止めたい | `npm run test:chapter-01`で章別に再現できるか |

テストの目的は、実装の内部状態ではなく最終HTTP応答を観測することです。デバッグ時も、本文だけでなく`response.status`を最初に確認してください。
