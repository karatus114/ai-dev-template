指定されたファイル・機能をわかりやすく説明します。

## 手順

### 1. 対象を確認する

ユーザーから、以下のいずれかを確認してください：

- **ファイルパス**: 特定のファイルを説明
- **機能名**: 特定の機能を説明
- **コードスニペット**: 特定のコードを説明

### 2. コードを読み込む

対象のファイル・コードを読み込んでください。

### 3. 関連ファイルを確認する（必要に応じて）

- インポートされているファイル
- 呼び出されている関数・クラス
- 関連するテストファイル

### 4. わかりやすく説明する

以下の形式で説明してください：

## 出力形式

```markdown
# [ファイル名/機能名] の説明

## 概要

[このファイル/機能が何をするのか、1-2文で説明]

## 役割

[このファイル/機能の責務、目的]

## 処理の流れ

1. [ステップ1]
2. [ステップ2]
3. [ステップ3]
...

## 主要な関数・クラス

### [関数名/クラス名]

**役割**: [何をする関数/クラスか]

**パラメータ**:
- `param1` (型): 説明
- `param2` (型): 説明

**戻り値**:
- 型: 説明

**例**:
\`\`\`typescript
// 使用例
const result = functionName(param1, param2);
\`\`\`

## 使用している技術

- [技術1]: 役割
- [技術2]: 役割

## 依存関係

- [ファイル1]: 役割
- [ファイル2]: 役割

## 注意点

- [注意点1]
- [注意点2]

## 関連ファイル

- [ファイル1]: 役割
- [ファイル2]: 役割
```

## 例

### 例1: UserService.ts の説明

```markdown
# UserService.ts の説明

## 概要

ユーザー管理のビジネスロジックを担当するServiceクラスです。
ユーザーの作成、取得、更新、削除の処理を実装しています。

## 役割

- ユーザーの作成・更新・削除のビジネスロジック
- 入力検証
- パスワードのハッシュ化
- Repository層との橋渡し

## 処理の流れ

### ユーザー作成（create メソッド）

1. 入力データをバリデーション（Zodスキーマ使用）
2. メールアドレスの重複チェック
3. パスワードをbcryptでハッシュ化
4. Repository経由でデータベースに保存
5. 作成されたユーザーを返す

### ユーザー取得（findById メソッド）

1. IDでユーザーを検索
2. 見つからない場合はNotFoundErrorをスロー
3. 見つかった場合はユーザーを返す

## 主要な関数・クラス

### UserService クラス

**役割**: ユーザー管理のビジネスロジックを実装

#### create メソッド

**役割**: 新しいユーザーを作成する

**パラメータ**:
- `userData` (CreateUserDto): ユーザー作成データ
  - `email` (string): メールアドレス
  - `password` (string): パスワード（平文）
  - `name` (string): 名前

**戻り値**:
- `Promise<User>`: 作成されたユーザー

**エラー**:
- `ValidationError`: 入力データが不正な場合
- `ConflictError`: メールアドレスが既に存在する場合

**例**:
\`\`\`typescript
const userService = new UserService();
const user = await userService.create({
  email: 'test@example.com',
  password: 'Password123',
  name: 'John Doe',
});
\`\`\`

#### findById メソッド

**役割**: IDでユーザーを取得する

**パラメータ**:
- `id` (string): ユーザーID

**戻り値**:
- `Promise<User>`: ユーザー

**エラー**:
- `NotFoundError`: ユーザーが見つからない場合

**例**:
\`\`\`typescript
const user = await userService.findById('12345');
\`\`\`

## 使用している技術

- **bcrypt**: パスワードのハッシュ化
- **Zod**: 入力検証
- **TypeORM**: データベースアクセス（Repository経由）

## 依存関係

- **UserRepository**: データベースアクセスを担当
- **ValidationError, ConflictError, NotFoundError**: カスタムエラークラス

## レイヤー構成

このファイルは **Service層** に属しています。

\`\`\`
Controller層
    ↓
Service層 ← このファイル
    ↓
Repository層
    ↓
Database
\`\`\`

## セキュリティ対策

- ✅ 入力検証（Zod）
- ✅ パスワードのハッシュ化（bcrypt）
- ✅ エラーハンドリング

## テスト

テストファイル: `src/services/__tests__/UserService.test.ts`

- 正常系: ユーザー作成が成功する
- 異常系: 無効なメールアドレスでエラー
- 異常系: 重複メールアドレスでエラー
- 境界値: パスワード8文字でユーザー作成成功

## 注意点

- パスワードは必ずハッシュ化されて保存されます（平文では保存されません）
- メールアドレスの重複チェックは、ユニークインデックスでも保証されています
- 論理削除されたユーザーは検索対象に含まれません

## 関連ファイル

- `src/repositories/UserRepository.ts`: データベースアクセス
- `src/controllers/UserController.ts`: HTTPリクエストの処理
- `src/types/user.ts`: 型定義
- `src/errors/index.ts`: エラークラス

## 改善案

- [ ] ユーザー作成時にウェルカムメール送信を追加
- [ ] パスワード強度チェックを強化
- [ ] ログ出力を追加（LOGGING.md参照）
```

## 注意

- 専門用語は適切に説明してください
- 初心者にもわかりやすい説明を心がけてください
- コード例を含めてください
- 関連するドキュメントへのリンクを含めてください

## Context7の使用

技術の最新情報を確認するため、必要に応じてContext7を使用してください。

例：
```
Context7でbcryptの使い方を確認
Context7でZodの最新のバリデーション方法を確認
```

## 参考資料

- [docs/ARCHITECTURE.md](../docs/ARCHITECTURE.md) - レイヤー構成
- [docs/CODING_RULES.md](../docs/CODING_RULES.md) - コード規約
- [docs/SECURITY.md](../docs/SECURITY.md) - セキュリティ設計
