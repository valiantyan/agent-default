# sessions/ — 历史会话归档

> 每月一个文件，由 Agent 在月底或文件过大时自动归档。
> MEMORY.md 的 Summary 区块超过 150 行时，主动提示用户将旧摘要移入此目录。

## 文件命名
YYYY-MM.md（例：2026-05.md）

## 归档触发条件
- MEMORY.md Summary 区块超过 150 行
- 会话摘要超过 3 个月未清理
