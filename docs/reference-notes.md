# 公式仕様メモ

## `server/api`とURL

Nuxt 4は`server/`配下のファイルをサーバーハンドラーとして自動登録します。`server/api`配下のファイルには`/api`プレフィックスが付き、`server/api/tasks.patch.ts`は`PATCH /api/tasks`として登録されます。[1]

## `createError`の利用

Nuxt 4の`createError`は追加メタデータを持つエラーを作るユーティリティであり、APIルートではエラー処理を起動するために送出します。[2]

```ts
export default defineEventHandler(() => {
  throw createError({
    status: 400,
    statusText: "Invalid title"
  });
});
```

クライアントへ返すステータス文は短く保ち、追加の機械可読情報には`data`を使います。動的なユーザー入力はクライアントへ返すメッセージへ含めません。[2]

## References

[1]: https://nuxt.com/docs/4.x/directory-structure/server "Nuxt 4 — server directory"
[2]: https://nuxt.com/docs/4.x/api/utils/create-error "Nuxt 4 — createError"
