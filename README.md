# Nuxt 4 createError Response Debug Lab

Nuxt 4のサーバーAPIで、入力エラーを表すJSONを通常の戻り値として`return`すると、HTTPステータスが`200`のままになる不具合を再現・修正するTypeScriptデバッグ教材です。Nuxt 4の`server/api`配下は自動的に`/api`プレフィックスのAPIルートとして登録され、`createError`はAPIルートのエラー処理を起動するために**送出する**用途で提供されています。[1] [2]

## APIの契約

対象のAPIは`PATCH /api/tasks`です。`title`が空白だけの場合は`400`と機械可読なエラーコードを返し、有効な`title`の場合は`200`と更新結果を返します。

| 入力 | 期待するHTTP応答 |
| --- | --- |
| `?title=   ` | `400`、`data.code: INVALID_TITLE`を持つエラーJSON |
| `?title=  設計レビュー  ` | `200`、トリミング済みのタスクJSON |

## 必要環境

Node.js **22.19.0以上**とnpmを使用します。このプロジェクトはNuxt **4.5.2**、TypeScript、H3で構成し、HTTP境界のテストはNode.js標準テストランナーで実行します。Nuxt 4.5.2の公式サポート範囲はNode.js `^22.19.0 || ^24.11.0 || >=26.0.0`です。[3]

## 実行方法

```bash
npm ci
npm run typecheck
npm test
npm run build
```

対象のRoute Handlerテストだけを実行する場合は、次のコマンドを使います。

```bash
npm run test:chapter-01
```

一連の品質ゲートを実行する場合は、次のコマンドを使います。

```bash
npm run verify
```

## バグを再現する

バグ状態は[`c6f27f8`](https://github.com/tonbiattack/nuxt4-create-error-response-debug-lab/commit/c6f27f8)です。不正な`title`に対してエラーJSONを通常の戻り値として返すため、本文に`INVALID_TITLE`があってもHTTPステータスは`200`になります。

```bash
git checkout c6f27f8
npm ci
npm run test:chapter-01
```

期待する失敗は`200 !== 400`です。有効な`title`に対する正常系テストは成功します。

## 修正後を確認する

修正は[`8d25fa2`](https://github.com/tonbiattack/nuxt4-create-error-response-debug-lab/commit/8d25fa2)です。不正入力の分岐で`throw createError(...)`を使い、Nuxt/H3のエラーハンドリングを起動します。

```bash
git switch main
npm ci
npm run typecheck
npm test
npm run build
```

## 学習資料

| 文書 | 内容 |
| --- | --- |
| [第01章のガイド](fundamentals/01-create-error-response.md) | RedからGreenまでの観測手順 |
| [デバッグ記録](docs/debugging-record.md) | 実行結果、原因、修正、制約 |
| [公式仕様メモ](docs/reference-notes.md) | Nuxt 4の`server/api`と`createError`の根拠 |
| [VS Codeデバッグ手順](docs/vscode-test-debugging.md) | テストをブレークポイントで停止する方法 |
| [設計メモ](DESIGN.md) | HTTP境界のテストとエラー本文の設計判断 |
| [対応表](coverage-matrix.md) | 実装済み・未着手テーマの一覧 |

## 参考資料

Nuxtの`server/api`が`/api`プレフィックスで登録されること、またAPIルートで`createError(...)`を送出してエラー応答を返すことは、Nuxt 4公式ドキュメントを参照してください。[1] [2]

## References

[1]: https://nuxt.com/docs/4.x/directory-structure/server "Nuxt 4 — server directory"
[2]: https://nuxt.com/docs/4.x/api/utils/create-error "Nuxt 4 — createError"
[3]: https://www.npmjs.com/package/nuxt/v/4.5.2 "npm — nuxt 4.5.2"
