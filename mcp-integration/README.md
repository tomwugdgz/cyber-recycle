# 赛博回收 - WebMCP 集成方案

> **版本**: v1.0  
> **创建时间**: 2026-04-17  
> **适用对象**: AI Agent 开发者、数据工程师

---

## 📡 WebMCP 简介

**WebMCP (Web Model Context Protocol)** 是一个用于 AI Agent 与 Web 服务交互的开放协议，支持：
- 🔌 标准化的工具调用接口
- 🔐 安全的身份验证和授权
- 📊 上下文感知的数据交换

---

## 🚀 快速开始

### 1. 安装 MCP SDK

```bash
# Node.js
npm install @anthropic-ai/mcp

# Python
pip install mcp
```

### 2. 配置 MCP 服务器

```json
{
  "mcpServers": {
    "cyber-recycle": {
      "command": "npx",
      "args": ["-y", "@cyber-recycle/mcp-server"],
      "env": {
        "API_KEY": "your_api_key_here"
      }
    }
  }
}
```

### 3. 连接 Claude Desktop

```bash
# 将配置添加到 Claude Desktop 配置
# macOS: ~/Library/Application Support/Claude/claude_desktop_config.json
# Windows: %APPDATA%\Claude\claude_desktop_config.json
```

---

## 🔧 可用工具

### 1. collect_data - 数据采集

从指定源采集数据并自动脱敏。

**输入参数：**
```json
{
  "source_type": "slack|jira|github|confluence",
  "credentials": {
    "workspace": "your-company.slack.com",
    "token": "xoxb-..."
  },
  "sanitize": true,
  "date_range": {
    "start": "2025-01-01",
    "end": "2025-12-31"
  }
}
```

**返回：**
```json
{
  "success": true,
  "ipfs_cid": "QmXoypizjW3WknFiJnKLwHCnL72vedxjQkDDP1mXZ6xPhk",
  "data_type": "slack_archive",
  "record_count": 15420,
  "size_mb": 256,
  "zk_proof": "0x..."
}
```

**使用示例（Claude Desktop）：**
```
请帮我从 Slack 工作区采集 #engineering 频道 2025 年的所有消息，并自动脱敏。
```

---

### 2. mint_data_nft - 铸造数据 NFT

将采集的数据铸造为 NFT，代表数据所有权。

**输入参数：**
```json
{
  "ipfs_cid": "QmXoyp...",
  "data_type": "slack_archive",
  "quality_level": 3,
  "royalty_percent": 20
}
```

**返回：**
```json
{
  "success": true,
  "token_id": "42",
  "contract_address": "0x1234567890abcdef1234567890abcdef12345678",
  "transaction_hash": "0xabcdef...",
  "owner": "0xYourWalletAddress"
}
```

**使用示例：**
```
帮我把刚才采集的 Slack 数据铸造为 NFT，设置 20% 版税。
```

---

### 3. distill_dataset - 数据蒸馏

将原始数据蒸馏成不同质量等级的训练集。

**输入参数：**
```json
{
  "data_cid": "QmXoyp...",
  "distillation_level": 5,
  "target_format": "rl_environment|task_dataset|sft_data"
}
```

**返回：**
```json
{
  "success": true,
  "distilled_cid": "QmYz...",
  "quality_score": 4.8,
  "task_count": 350,
  "format": "rl_environment"
}
```

**使用示例：**
```
请把这个数据集蒸馏成 L5 等级的 RL 环境。
```

---

### 4. create_rl_environment - 创建 RL 环境

从工作流数据自动生成 RL 环境。

**输入参数：**
```json
{
  "workflow_data_cid": "QmXoyp...",
  "environment_type": "big_tech|finance|ecommerce",
  "difficulty": "easy|medium|hard"
}
```

**返回：**
```json
{
  "success": true,
  "environment_id": "42",
  "name": "Slack Engineering Workflow",
  "state_space_size": 1024,
  "action_space_size": 56,
  "ipfs_cid": "QmAbc..."
}
```

**使用示例：**
```
基于这个 Slack 工作流数据，创建一个中等难度的 RL 训练环境。
```

---

### 5. purchase_data - 购买数据

从数据市场购买数据集或 RL 环境。

**输入参数：**
```json
{
  "data_id": "42",
  "payment_token": "USDC|ETH",
  "wallet_address": "0xYourWallet"
}
```

**返回：**
```json
{
  "success": true,
  "transaction_hash": "0x...",
  "amount_paid": "50000 USDC",
  "nft_token_id": "42",
  "access_url": "ipfs://Qm..."
}
```

**使用示例：**
```
我想购买 ID 为 42 的 RL 环境，使用 USDC 支付。
```

---

### 6. subscribe_rl_environment - 订阅 RL 环境

订阅 RL 环境的 A2A 调用服务。

**输入参数：**
```json
{
  "environment_id": "42",
  "calls": 1000,
  "duration_days": 30,
  "payment_token": "USDC"
}
```

**返回：**
```json
{
  "success": true,
  "subscription_id": "sub_123",
  "total_cost": "500 USDC",
  "price_per_call": "0.5 USDC",
  "expiry_time": 1735689600
}
```

**使用示例：**
```
帮我订阅环境 42，1000 次调用，30 天有效期。
```

---

### 7. execute_rl_call - 执行 RL 调用

通过 A2A 支付执行 RL 环境调用。

**输入参数：**
```json
{
  "subscription_id": "sub_123",
  "input_data": {
    "task": "schedule_meeting",
    "participants": ["alice", "bob"],
    "duration": 30
  }
}
```

**返回：**
```json
{
  "success": true,
  "result": {
    "action": "send_calendar_invite",
    "details": {...}
  },
  "cost": "0.5 USDC",
  "calls_remaining": 999
}
```

**使用示例：**
```
执行 RL 调用，任务是安排一个 30 分钟的会议，参与者是 Alice 和 Bob。
```

---

## 📊 数据市场查询

### list_datasets - 列出数据集

**输入参数：**
```json
{
  "type": "slack|jira|code|rl_environment",
  "min_quality": 3,
  "max_price": 100000,
  "sort_by": "quality|price|date"
}
```

**返回：**
```json
{
  "datasets": [
    {
      "id": "42",
      "name": "Slack Engineering Archive",
      "type": "slack_archive",
      "quality": 4,
      "price": "50000 USDC",
      "size_mb": 256
    }
  ]
}
```

---

## 🔐 身份验证

### API Key 认证

1. 在 [cyber-recycle.io](https://cyber-recycle.io) 注册账户
2. 在 Dashboard 创建 API Key
3. 将 API Key 添加到 MCP 配置

### 钱包认证（推荐）

```typescript
import { createWalletClient } from 'viem';

const wallet = createWalletClient({
  address: '0xYourWallet',
  // ... 配置
});

// 签名消息进行认证
const signature = await wallet.signMessage({
  message: 'Login to CyberRecycle MCP'
});
```

---

## 🛠️ 高级用法

### 批量数据采集

```typescript
const connector = new CyberRecycleMCP();

// 同时采集多个数据源
const results = await Promise.all([
  connector.collectData('slack', slackCredentials),
  connector.collectData('jira', jiraCredentials),
  connector.collectData('github', githubCredentials)
]);

// 合并数据并蒸馏
const combined = await connector.mergeDatasets(results);
const distilled = await connector.distill(combined, { level: 5 });
```

### 自定义 RL 环境

```typescript
// 定义自定义任务
const customTask = {
  name: 'Code Review Workflow',
  steps: [
    'fetch_pull_request',
    'analyze_code_changes',
    'add_review_comments',
    'approve_or_request_changes'
  ],
  reward_function: 'code_quality_score'
};

// 创建环境
const env = await connector.createCustomEnvironment({
  workflow_data: customTask,
  difficulty: 'hard'
});
```

---

## 📋 最佳实践

### 1. 数据脱敏

- ✅ 始终启用自动脱敏（`sanitize: true`）
- ✅ 验证 ZK 证明确保脱敏质量
- ✅ 避免上传包含 PII 的原始数据

### 2. 质量控制

- ✅ 选择合适的质量等级（L3 适合大多数场景）
- ✅ 检查质量评分（>4.0 为优质）
- ✅ 先购买小样本测试再批量采购

### 3. 成本优化

- ✅ 使用订阅模式比单次购买更经济
- ✅ 批量蒸馏享受折扣
- ✅ 关注数据市场的促销活动

---

## 🆘 故障排查

### 问题：数据采集失败

**可能原因：**
- API Token 过期
- 权限不足
- 网络问题

**解决方案：**
```bash
# 检查连接
curl https://api.cyber-recycle.io/health

# 刷新 Token
# 重新生成 API Key
```

### 问题：智能合约交易失败

**可能原因：**
- Gas 不足
- 余额不足
- 合约调用参数错误

**解决方案：**
```typescript
// 检查余额
const balance = await wallet.getBalance();

// 估算 Gas
const gasEstimate = await contract.estimateGas.purchaseData(...);
```

---

## 📞 支持

- 📧 技术支持：dev@cyber-recycle.io
- 💬 Discord：discord.gg/cyber-recycle
- 📖 文档：docs.cyber-recycle.io

---

*文档版本：v1.0 | 最后更新：2026-04-17*
