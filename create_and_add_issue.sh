#!/bin/bash

# スクリプトが失敗した場合に即座に終了
set -e

# 変数の設定
TITLE="新しいIssueのタイトル"  # 適切なタイトルを設定してください
BODY_FILE="gh-issue.md"  # チェックリストの内容を記載したファイル
ASSIGNEE="masaengineer"
PROJECT_NUMBER=2
OWNER="masaengineer"  # オーナー名を明示的に設定

# Issueを作成し、番号を取得
ISSUE_NUMBER=$(gh issue create \
  --title "$TITLE" \
  --body-file "$BODY_FILE" \
  --assignee "$ASSIGNEE")

# デバッグ用にIssue番号を表示
echo "取得したIssue番号: $ISSUE_NUMBER"

# 作成されたIssueのURLを構築
ISSUE_URL="https://github.com/$OWNER/parts-sync/issues/${ISSUE_NUMBER##*/}"

# 取得したIssueのURLを表示
echo "作成されたIssueのURL: $ISSUE_URL"

# ITEM_IDを取得する部分でjqコマンドが見つからないエラーが発生しています。
# jqがインストールされていることを確認してください。
# もしインストールされていない場合は、以下のコマンドを実行してください。
# sudo apt-get install jq  # Debian系のLinuxの場合
brew install jq          # macOSの場合

# 認証トークンに必要なスコープが不足しているエラーが発生しています。
# 認証トークンを更新するために、以下のコマンドを実行してください。
gh auth refresh -s read:project

# プロジェクトにIssueを追加（オーナーを明示的に指定）
ITEM_ID=$(gh project item-add "$PROJECT_NUMBER" --owner "$OWNER" --url "$ISSUE_URL" --format json | jq -r '.id')

# ストーリーポイントフィールドを更新
gh api graphql -f query='
  mutation {
    updateProjectV2ItemFieldValue(
      input: {
        projectId: "'$PROJECT_NUMBER'"
        itemId: "'$ITEM_ID'"
        fieldId: "STORY_POINTS_FIELD_ID"  # GitHubプロジェクトの実際のフィールドIDに置き換えてください
        value: {
          number: '$STORY_POINTS'
        }
      }
    ) {
      projectV2Item {
        id
      }
    }
  }'

# 成功メッセージ
echo "Issueをプロジェクト番号 $PROJECT_NUMBER に追加し、ストーリーポイントを設定しました。"
