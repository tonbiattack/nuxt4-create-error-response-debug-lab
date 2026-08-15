# デバッグ記録: `createError`を返してHTTP 200になる

## 現象

`PATCH /api/tasks?title=%20%20%20`は、入力エラーを表す`INVALID_TITLE`を含むJSONを返します。しかし、バグ状態ではHTTPステータスが`200`です。API利用者は成功とエラーをHTTPステータスで区別できません。

| 観点 | 期待 | バグ状態での観測 |
| --- | --- | --- |
| HTTPステータス | `400` | `200` |
| エラーコード | `data.code: INVALID_TITLE` | `code: INVALID_TITLE` |
| 正常系 | `200`、トリミング済み`title` | 成功 |

## 再現

```bash
git checkout c6f27f8
npm ci
npm run test:chapter-01
```

観測する失敗は次のとおりです。

```text
AssertionError [ERR_ASSERTION]: Expected values to be strictly equal:
200 !== 400
```

同じ実行で、有効な`title`を使う正常系テストは成功します。この差により、テスト環境、ルートの登録、クエリ取得、正常レスポンス生成の問題を優先度から下げられます。

## 調査

| 順序 | 観測 | 結果 | 除外できること |
| --- | --- | --- | --- |
| 1 | HTTPステータス | 不正入力で`200` | JSON本文だけの問題ではない |
| 2 | 正常系テスト | 成功 | ルート全体や`title.trim()`の問題ではない |
| 3 | 不正入力分岐 | エラーオブジェクトを`return`している | Nuxt/H3のエラー処理が起動していない |
| 4 | Nuxt 4公式仕様 | APIルートでは`createError`を送出する | 修正方法を特定できる |

Nuxt 4の`server/api`配下では、ハンドラーが通常の値を返すと成功レスポンスとして処理されます。別のHTTPステータスを返すには、`createError`を送出してエラー処理を起動します。[1] [2]

## 根本原因

不正入力分岐は、エラーらしい本文を持つ通常のJavaScriptオブジェクトを返していました。HTTPエラーを表す`Response`や送出されたエラーではないため、H3は成功応答として直列化し、既定の`200`を維持します。

## 最小修正

不正入力分岐だけを、次のように変更します。

```ts
throw createError({
  statusCode: 400,
  statusMessage: "Invalid title",
  data: {
    code: "INVALID_TITLE"
  }
});
```

`statusMessage`は短い固定値とし、クライアント向けの機械可読な情報は`data.code`に置きます。Nuxt 4公式ドキュメントも、APIルートの`createError`には短い`statusText`と`data`の利用を案内しています。[2]

## 回帰確認

```bash
git switch main
npm ci
npm run test:chapter-01
npm test
npm run typecheck
npm run build
```

修正コミット`8d25fa2`では、不正入力テストと正常入力テストの両方が成功します。回帰テストは実装詳細ではなく、最終的な`Response`のステータスとJSON本文を検証します。

## 再発防止

APIのエラー分岐を追加・変更する際は、本文の`code`だけでなく、最終HTTPステータスをテストで固定します。また、`statusMessage`にユーザー入力、内部例外、認証情報を含めないようにします。

## References

[1]: https://nuxt.com/docs/4.x/directory-structure/server "Nuxt 4 — server directory"
[2]: https://nuxt.com/docs/4.x/api/utils/create-error "Nuxt 4 — createError"
