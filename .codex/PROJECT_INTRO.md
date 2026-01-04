# PROJECT_INTRO

## プロジェクト概要
FamilyTimeRank は、家族全員が同じ情報を見る「可視化アプリ」です。制限・監視ではなく、SNS 利用時間の共有を通じて会話のきっかけを作ることを目的とします。

## フォルダ構成
- PJ のフォルダ: ~/dev/iphone/FamilyTimeRank
- PJ の Wiki: ~/dev/iphone/FamilyTimeRank.wiki

## 参照ドキュメント（Wiki）
- 画面一覧: ~/dev/iphone/FamilyTimeRank.wiki/画面一覧.md
- 画面フロー: ~/dev/iphone/FamilyTimeRank.wiki/画面フロー.md
- アーキテクチャ構成設計: ~/dev/iphone/FamilyTimeRank.wiki/アーキテクチャ構成設計.md

## 技術方針
- SwiftUI + MVVM
- Clean Architecture ベースの構成
- Domain / Data / Presentation を分離し、依存方向を明確にする

## 現在の進行状況（抜粋）
- Fake データで Home 画面表示を目指す（ScreenTime/サーバー未使用）
- FamilyRepositoryFake を用意し、家族名・メンバー4人を固定で返す

## 連携メモ
- 新規参加メンバー（AI codex 2号）は、まず Wiki を確認して画面/フロー/設計方針を把握すること
- 実装は段階的に進める（大ステップ1: ローカルデータで画面表示）
