# 学習目次

| 章 | 題材 | ガイド | 実装 | テスト | Git履歴 |
| --- | --- | --- | --- | --- | --- |
| 第01章 | エラーJSONを`return`してHTTP `200`になる問題 | [ガイド](fundamentals/01-create-error-response.md) | [`server/api/tasks.patch.ts`](server/api/tasks.patch.ts) | [`test/tasks-api.test.ts`](test/tasks-api.test.ts) | `c6f27f8` → `8d25fa2` |

第01章は、Nuxt 4のサーバーAPIで不正入力に対して通常のオブジェクトを返すと、成功応答の`200`になる状態から始めます。`throw createError(...)`へ置き換え、HTTP `400`と`data.code`を回帰テストで固定します。[1]

## References

[1]: https://nuxt.com/docs/4.x/api/utils/create-error "Nuxt 4 — createError"
