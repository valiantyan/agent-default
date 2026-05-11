# MEMORY.md — 工作记忆

> 双层结构：Summary for Agent（常驻热层，200行以内）+ Details（按需读取）。
> Agent 每次会话只读 Summary；需要具体历史细节时，读 Details 或 memory/sessions/。
> 每次会话结束由 Agent 静默更新，不需要询问。

---

## Summary for Agent

> ⚠️ 此区块必须保持在文件前 200 行内。内容增长时，把旧记录移入 Details 或 memory/sessions/。

### 当前项目阶段
（Agent 填写：当前模块/迭代目标，一句话）

### 关键约定（本项目特有，区别于 core-rules.md）
（暂无，首次出现时由 Agent 写入，每条一行）

### 跨会话待跟进项
- [ ] （Agent 填写）

### 最近会话摘要（保留最近 3 条）
（暂无记录）

### 架构决策速查（仅记录结论，完整记录见 Details）
| 日期 | 决策 | 结论 |
|------|------|------|

---

## Details

> 完整记录区，不在启动时加载。需要具体细节时由 Agent 按需读取。

### 架构决策完整记录
| 日期 | 决策 | 采用方案 | 放弃的方案 | 原因 |
|------|------|---------|-----------|------|

### 历史会话归档入口
> 超过 3 个月的会话摘要移入 memory/sessions/ 按月归档。
> 格式：memory/sessions/YYYY-MM.md
