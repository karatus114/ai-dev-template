# コード規約・命名規則

このドキュメントでは、プロジェクト全体で統一すべきコード規約と命名規則を定義します。

---

## 命名規則

**[`/init-project` を実行して技術スタックに応じた命名規則が設定されます]**

### 基本原則

- **明確で分かりやすい名前をつける**
- **略語は避ける**（一般的なものを除く）
- **英語で命名する**（コメントは日本語可）
- **意図が伝わる名前にする**

### 言語別の命名規則（プレースホルダー）

#### TypeScript / JavaScript

**[`/init-project` で設定されます]**

#### Python

**[`/init-project` で設定されます]**

#### その他

**[`/init-project` で設定されます]**

---

## ディレクトリ構成

**[`/init-project` を実行してディレクトリ構成が設定されます]**

### 基本原則

- **機能ごとにディレクトリを分ける**
- **レイヤーごとにディレクトリを分ける**（Controller, Service, Repository）
- **共通機能は別ディレクトリにまとめる**

---

## コメントルール

### 基本方針

- **コードを見れば分かることは書かない**
- **なぜそうするのか（Why）を書く**
- **複雑なロジックには必ず説明を追加**

### 良いコメントの例

```typescript
// ❌ 悪い例：何をしているかだけ書いている
// ユーザーIDを取得する
const userId = getUserId();

// ✅ 良い例：なぜそうするのかを書いている
// セッションの有効期限が切れている場合があるため、
// 毎回最新のユーザーIDを取得する
const userId = getUserId();
```

```python
# ❌ 悪い例
# リストをループする
for item in items:
    process(item)

# ✅ 良い例
# 順序を保証する必要があるため、並列処理は使用しない
for item in items:
    process(item)
```

### 関数・クラスのドキュメンテーション

複雑な関数やクラスには、以下の情報を含めるドキュメントコメントを追加してください。

**TypeScript/JavaScript**:

```typescript
/**
 * ユーザーの権限をチェックし、アクセス可否を判定する
 *
 * @param userId - チェック対象のユーザーID
 * @param resourceId - アクセスしようとしているリソースID
 * @returns アクセス可能な場合はtrue
 * @throws {UnauthorizedError} ユーザーが認証されていない場合
 * @throws {ForbiddenError} 権限がない場合
 */
async function checkPermission(userId: string, resourceId: string): Promise<boolean> {
  // ...
}
```

**Python**:

```python
def check_permission(user_id: str, resource_id: str) -> bool:
    """
    ユーザーの権限をチェックし、アクセス可否を判定する

    Args:
        user_id: チェック対象のユーザーID
        resource_id: アクセスしようとしているリソースID

    Returns:
        アクセス可能な場合はTrue

    Raises:
        UnauthorizedError: ユーザーが認証されていない場合
        ForbiddenError: 権限がない場合
    """
    # ...
```

### TODOコメント

TODOコメントには、必ずIssue番号を含めてください。

```typescript
// TODO(#123): パフォーマンス改善 - キャッシュを導入する
```

```python
# TODO(#456): セキュリティ強化 - レート制限を追加する
```

---

## インポート順序

インポートは以下の順序で記述し、各グループの間に空行を入れてください。

### TypeScript / JavaScript

```typescript
// 1. 標準ライブラリ（Node.js組み込みモジュール）
import fs from 'fs';
import path from 'path';

// 2. サードパーティライブラリ
import express from 'express';
import { z } from 'zod';

// 3. プロジェクト内モジュール（絶対パス）
import { UserService } from '@/services/UserService';
import { AuthMiddleware } from '@/middlewares/AuthMiddleware';

// 4. 相対パスのインポート
import { validateUser } from './validators';
import type { User } from './types';
```

### Python

```python
# 1. 標準ライブラリ
import os
import sys
from typing import List, Optional

# 2. サードパーティライブラリ
import fastapi
from pydantic import BaseModel

# 3. プロジェクト内モジュール
from app.services.user_service import UserService
from app.models.user import User
```

---

## コードフォーマット

### 自動フォーマッターの使用

以下のツールを使用してコードを自動フォーマットしてください。

**[`/init-project` で技術スタックに応じたフォーマッターが設定されます]**

### インデント

- **スペース使用** - タブは使用しない
- **インデント幅**: 2スペース（JavaScript/TypeScript）、4スペース（Python）

### 行の長さ

- **最大80〜100文字**を推奨
- 長い行は適切に分割する

### 空行

- 関数と関数の間に1行
- クラスとクラスの間に2行
- ロジックのまとまりごとに1行

---

## ファイル構成

### 1ファイル1責務

- 1つのファイルには1つのクラス、または関連する関数群のみを配置
- ファイルサイズは300行以下を推奨

### ファイル名

**[`/init-project` で技術スタックに応じたファイル名規則が設定されます]**

---

## エラーハンドリング

詳細は [ARCHITECTURE.md](ARCHITECTURE.md) を参照してください。

### 基本原則

- **予期されるエラーは必ずハンドリングする**
- **エラーメッセージには機密情報を含めない**
- **エラーログを必ず出力する**（[LOGGING.md](LOGGING.md) 参照）

### 例

```typescript
try {
  const user = await userService.findById(userId);
  if (!user) {
    throw new NotFoundError('User not found');
  }
  return user;
} catch (error) {
  logger.error('Failed to fetch user', {
    event: 'user_fetch_failed',
    user_id: userId,
    error_type: error.constructor.name,
    error_message: error.message,
  });
  throw error;
}
```

---

## 禁止事項

### コーディング

- ❌ **ハードコードされた機密情報**（APIキー、パスワード、トークン等）
- ❌ **console.log() の本番環境への残留**（開発時のみ使用可）
- ❌ **未使用のインポート・変数**
- ❌ **any型の多用**（TypeScript）
- ❌ **広範囲すぎるtry-catch**

### 命名

- ❌ **意味不明な略語**（tmp, dat, flg など）
- ❌ **1文字の変数名**（ループカウンタのi, j以外）
- ❌ **誤解を招く名前**

---

## ベストプラクティス

### 定数の使用

マジックナンバーやマジックストリングは避け、定数として定義する。

```typescript
// ❌ 悪い例
if (user.status === 1) { ... }

// ✅ 良い例
const USER_STATUS_ACTIVE = 1;
if (user.status === USER_STATUS_ACTIVE) { ... }
```

### 早期リターン

ネストを減らすため、早期リターンを使用する。

```typescript
// ❌ 悪い例
function processUser(user) {
  if (user) {
    if (user.isActive) {
      if (user.hasPermission) {
        // 処理
      }
    }
  }
}

// ✅ 良い例
function processUser(user) {
  if (!user) return;
  if (!user.isActive) return;
  if (!user.hasPermission) return;

  // 処理
}
```

### 関数の単一責任

1つの関数は1つのことだけを行う。

```typescript
// ❌ 悪い例
function processUserAndSendEmail(user) {
  validateUser(user);
  saveUser(user);
  sendEmail(user.email);
  logActivity(user);
}

// ✅ 良い例
function processUser(user) {
  validateUser(user);
  saveUser(user);
}

function notifyUser(user) {
  sendEmail(user.email);
  logActivity(user);
}
```

---

## リンター・フォーマッター設定

**[`/init-project` で技術スタックに応じた設定ファイルが生成されます]**

---

## 参考資料

- [ARCHITECTURE.md](ARCHITECTURE.md) - 設計方針
- [SECURITY.md](SECURITY.md) - セキュリティ対策
- [TESTING.md](TESTING.md) - テスト方針

---

## 更新履歴

- **[日付]**: `/init-project` でプロジェクト初期化
