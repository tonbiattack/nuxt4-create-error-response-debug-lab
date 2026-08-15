# 設計メモ

## 目的

このプロジェクトは、Nuxt 4のサーバーAPIでエラーを表すJSONを通常の戻り値として返すと、HTTPステータスが成功のままになることを示します。対象は、不正入力に対して`return`する代わりに`throw createError(...)`を使う一つの修正です。

## 実行基盤の選択

Nuxt 4.5.2の`server/api/tasks.patch.ts`にサーバーAPIを置きます。Nuxtは`server/`配下を走査してAPIハンドラーを登録し、`server/api`配下のファイルには`/api`プレフィックスを付与します。[1] このラボでは、H3の`createApp()`と`toWebHandler()`を使い、`Request`から`Response`までを実際のHTTP境界として観測します。データベースや外部APIは使いません。

Nuxt 4.5.2はNode.js `^22.19.0 || ^24.11.0 || >=26.0.0`を公式サポート範囲に含みます。[2] CIでは最新のNode.js 22系を使い、`nuxt typecheck`、Node標準テストランナー、`nuxt build`を検証します。

## テスト境界

不正入力では、HTTPステータスが`400`であることに加え、エラー本文の`statusCode`、`statusMessage`、`data.code`を確認します。H3が将来追加し得る補助フィールド全体には依存しません。正常入力では、`200`とトリミング済みのタスクJSONを確認します。

テストはコンポーネントや実装の私的な分岐ではなく、ルートハンドラーに対するHTTPレスポンスを検証します。そのため、通常のオブジェクトを返す実装へ後退した場合も、`200 !== 400`として再現できます。

## エラー本文の設計

`statusMessage`には短い固定値を使い、アプリケーション固有の機械可読なエラーコードを`data.code`へ置きます。Nuxt 4はAPIルートで`createError`を送出することを推奨し、クライアントへ伝える`statusText`は短く保ち、`data`で追加情報を返すことを案内しています。[3] 動的なユーザー入力や機微情報をエラー本文へ含めません。

## 参考教材との関係

このリポジトリは、ユーザーが指定したNuxt 3版ラボの題材、Red → Greenの学習方法、HTTP契約をNuxt 4.5.2に対応させた別リポジトリです。既存のGit履歴は引き継がず、新しいバグ導入コミットと修正コミットを独立して記録します。

## References

[1]: https://nuxt.com/docs/4.x/directory-structure/server "Nuxt 4 — server directory"
[2]: https://www.npmjs.com/package/nuxt/v/4.5.2 "npm — nuxt 4.5.2"
[3]: https://nuxt.com/docs/4.x/api/utils/create-error "Nuxt 4 — createError"
