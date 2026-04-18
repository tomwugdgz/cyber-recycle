---
name: cyber-recycle
description: >
  赛博回收 Skill - 企业数字遗产回收与蒸馏平台集成工具。
  支持数据采集、蒸馏、RL 环境生成、A2A 支付等功能。
  适用于 AI Agent 开发者、数据工程师、AI 公司。
---

# CyberRecycle Skill - 赛博回收集成工具

## 🎯 功能概述

本 Skill 提供赛博回收平台的完整集成能力，包括：

1. **数据采集** - 从 Slack/Jira/GitHub 等源采集数据
2. **数据蒸馏** - AI 自动蒸馏成 L1-L5 质量等级
3. **RL 环境生成** - 从工作流数据生成训练环境
4. **A2A 支付** - Agent-to-Agent 智能合约自动结算
5. **数据市场** - 浏览和购买数据集/RL 环境

---

## 🚀 快速开始

### 1. 安装 Skill

```bash
# 从 Skill Hub 安装
skillhub install cyber-recycle

# 或手动安装
git clone https://github.com/cyber-recycle/skill.git ~/.workbuddy/skills/cyber-recycle
```

### 2. 配置认证

在 `~/.workbuddy/config.json` 添加：

```json
{
  "skills": {
    "cyber-recycle": {
      "api_key": "your_api_key",
      "wallet_address": "0xYourWalletAddress",
      "network": "polygon"  // 或 arbitrum/ethereum
    }
  }
}
```

### 3. 使用 Skill

在你的 AI Agent 中调用：

```python
from skill import CyberRecycleSkill

skill = CyberRecycleSkill()

# 采集 Slack 数据
data = await skill.collect_data(
    source_type='slack',
    workspace='your-company.slack.com',
    token='xoxb-...',
    sanitize=True
)

# 蒸馏数据
distilled = await skill.distill(data, level=5)

# 创建 RL 环境
env = await skill.create_rl_environment(distilled)
```

---

## 🔧 可用工具

### 1. collect_data - 数据采集

**用途：** 从指定源采集工作流数据

**参数：**
- `source_type` (str): 数据源类型
  - `slack` - Slack 消息存档
  - `jira` - Jira 工单系统
  - `github` - GitHub 代码库
  - `confluence` - Confluence 文档
- `credentials` (dict): 认证信息
- `sanitize` (bool): 是否自动脱敏（默认 True）
- `date_range` (dict): 日期范围

**示例：**
```python
# 采集 Slack 数据
result = await skill.collect_data(
    source_type='slack',
    credentials={
        'workspace': 'company.slack.com',
        'token': 'xoxb-...'
    },
    sanitize=True,
    date_range={
        'start': '2025-01-01',
        'end': '2025-12-31'
    }
)

print(f"采集完成：{result['record_count']} 条记录，{result['size_mb']} MB")
print(f"IPFS CID: {result['ipfs_cid']}")
```

---

### 2. distill_dataset - 数据蒸馏

**用途：** 将原始数据蒸馏成不同质量等级的训练集

**参数：**
- `data_cid` (str): IPFS 数据标识
- `distillation_level` (int): 蒸馏等级 1-5
  - L1: 原始数据清洗
  - L2: 结构化处理
  - L3: 任务提取
  - L4: 质量评分
  - L5: RL 环境生成
- `target_format` (str): 目标格式
  - `rl_environment` - RL 训练环境
  - `task_dataset` - 任务题库
  - `sft_data` - SFT 训练数据

**示例：**
```python
# L5 蒸馏生成 RL 环境
result = await skill.distill_dataset(
    data_cid='QmXoyp...',
    distillation_level=5,
    target_format='rl_environment'
)

print(f"质量评分：{result['quality_score']}/5")
print(f"任务数量：{result['task_count']}")
print(f"蒸馏后 CID: {result['distilled_cid']}")
```

---

### 3. create_rl_environment - 创建 RL 环境

**用途：** 从工作流数据自动生成 RL 训练环境

**参数：**
- `workflow_data_cid` (str): 工作流数据 CID
- `environment_type` (str): 环境类型
  - `big_tech` - 大厂工作环境
  - `finance` - 金融工作流
  - `ecommerce` - 电商运营
  - `healthcare` - 医疗流程
- `difficulty` (str): 难度等级
  - `easy` - 简单
  - `medium` - 中等
  - `hard` - 困难

**示例：**
```python
# 创建中等难度的大厂 RL 环境
env = await skill.create_rl_environment(
    workflow_data_cid='QmXoyp...',
    environment_type='big_tech',
    difficulty='medium'
)

print(f"环境 ID: {env['environment_id']}")
print(f"状态空间：{env['state_space_size']}")
print(f"动作空间：{env['action_space_size']}")
```

---

### 4. purchase_data - 购买数据

**用途：** 从数据市场购买数据集或 RL 环境

**参数：**
- `data_id` (str): 数据 ID
- `payment_token` (str): 支付代币
  - `USDC` - USD Coin
  - `ETH` - Ethereum
- `wallet_address` (str): 钱包地址

**示例：**
```python
# 购买 RL 环境
result = await skill.purchase_data(
    data_id='42',
    payment_token='USDC',
    wallet_address='0xYourWallet'
)

print(f"支付金额：{result['amount_paid']}")
print(f"NFT Token ID: {result['nft_token_id']}")
print(f"访问 URL: {result['access_url']}")
```

---

### 5. subscribe_rl_environment - 订阅 RL 环境

**用途：** 订阅 RL 环境的 A2A 调用服务

**参数：**
- `environment_id` (str): 环境 ID
- `calls` (int): 调用次数
- `duration_days` (int): 有效期（天）
- `payment_token` (str): 支付代币

**示例：**
```python
# 订阅 1000 次调用，30 天有效期
subscription = await skill.subscribe_rl_environment(
    environment_id='42',
    calls=1000,
    duration_days=30,
    payment_token='USDC'
)

print(f"订阅 ID: {subscription['subscription_id']}")
print(f"总费用：{subscription['total_cost']} USDC")
print(f"单次调用：{subscription['price_per_call']} USDC")
```

---

### 6. execute_rl_call - 执行 RL 调用

**用途：** 通过 A2A 支付执行 RL 环境调用

**参数：**
- `subscription_id` (str): 订阅 ID
- `input_data` (dict): 输入数据

**示例：**
```python
# 执行 RL 调用
result = await skill.execute_rl_call(
    subscription_id='sub_123',
    input_data={
        'task': 'schedule_meeting',
        'participants': ['alice', 'bob'],
        'duration': 30
    }
)

print(f"执行结果：{result['result']}")
print(f"消耗：{result['cost']} USDC")
print(f"剩余调用：{result['calls_remaining']}")
```

---

### 7. list_datasets - 浏览数据市场

**用途：** 查询可用数据集和 RL 环境

**参数：**
- `type` (str): 数据类型
- `min_quality` (int): 最低质量等级
- `max_price` (int): 最高价格（USDC）
- `sort_by` (str): 排序方式

**示例：**
```python
# 查询高质量 RL 环境
datasets = await skill.list_datasets(
    type='rl_environment',
    min_quality=4,
    max_price=100000,
    sort_by='quality'
)

for ds in datasets:
    print(f"{ds['id']}: {ds['name']} - {ds['price']} USDC (Q{ds['quality']})")
```

---

## 🎯 使用场景

### 场景 1：AI 公司训练 Agent

```python
# 1. 浏览数据市场
envs = await skill.list_datasets(type='rl_environment', min_quality=4)

# 2. 订阅合适的环境
sub = await skill.subscribe_rl_environment(
    environment_id=envs[0]['id'],
    calls=10000,
    duration_days=90
)

# 3. 批量训练
for i in range(1000):
    result = await skill.execute_rl_call(
        subscription_id=sub['subscription_id'],
        input_data={'task': get_random_task()}
    )
```

---

### 场景 2：倒闭公司数据变现

```python
# 1. 采集公司数据
data = await skill.collect_data(
    source_type='slack',
    credentials=slack_creds,
    sanitize=True
)

# 2. 铸造 NFT
nft = await skill.mint_data_nft(
    ipfs_cid=data['ipfs_cid'],
    data_type='slack_archive',
    quality_level=3,
    royalty_percent=20
)

# 3. 蒸馏并上架
distilled = await skill.distill_dataset(
    data_cid=data['ipfs_cid'],
    distillation_level=5
)

# 4. 设置价格并出售
await skill.list_for_sale(
    nft_token_id=nft['token_id'],
    price='50000 USDC'
)
```

---

### 场景 3：数据经销商

```python
# 1. 批量采购原始数据
raw_data = await skill.purchase_data(data_id='100')

# 2. 蒸馏成不同等级
l3_data = await skill.distill_dataset(raw_data['cid'], level=3)
l5_data = await skill.distill_dataset(raw_data['cid'], level=5)

# 3. 分装出售
await skill.list_for_sale(nft_id=l3_data['nft_id'], price='10000 USDC')
await skill.list_for_sale(nft_id=l5_data['nft_id'], price='50000 USDC')
```

---

## 📊 定价说明

### 数据采集
| 数据源 | 价格范围 | 说明 |
|--------|----------|------|
| Slack | 1-10 万 USDC | 按消息量和时间范围 |
| Jira | 0.5-5 万 USDC | 按工单数量 |
| GitHub | 2-20 万 USDC | 按代码库大小和提交数 |
| Confluence | 1-8 万 USDC | 按文档数量 |

### 数据蒸馏
| 等级 | 价格 | 说明 |
|------|------|------|
| L1 | 免费 | 基础清洗 |
| L2 | 0.01 USDC/MB | 结构化处理 |
| L3 | 0.05 USDC/MB | 任务提取 |
| L4 | 0.1 USDC/MB | 质量评分 |
| L5 | 0.5 USDC/MB | RL 环境生成 |

### RL 环境调用
| 难度 | 价格/调用 | 说明 |
|------|-----------|------|
| Easy | 0.1 USDC | 简单任务 |
| Medium | 0.5 USDC | 中等任务 |
| Hard | 2 USDC | 复杂任务 |

---

## 🔐 安全最佳实践

### 1. API Key 管理

```python
# ✅ 正确：从环境变量读取
import os
api_key = os.getenv('CYBER_RECYCLE_API_KEY')

# ❌ 错误：硬编码
api_key = 'sk-xxx'  # 不要这样做！
```

### 2. 钱包安全

```python
# ✅ 正确：使用硬件钱包
from ledger import LedgerWallet
wallet = LedgerWallet()

# ❌ 错误：私钥明文存储
private_key = '0xabc...'  # 不要这样做！
```

### 3. 数据脱敏

```python
# ✅ 正确：始终启用脱敏
result = await skill.collect_data(
    source_type='slack',
    sanitize=True  # 重要！
)

# 验证 ZK 证明
is_valid = await skill.verify_zk_proof(result['zk_proof'])
```

---

## 🛠️ 高级功能

### 批量操作

```python
# 批量采集多个数据源
tasks = [
    skill.collect_data('slack', slack_creds),
    skill.collect_data('jira', jira_creds),
    skill.collect_data('github', github_creds)
]
results = await asyncio.gather(*tasks)

# 合并数据集
combined = await skill.merge_datasets([r['ipfs_cid'] for r in results])

# 批量蒸馏
distilled = await skill.batch_distill(
    data_cids=[combined['cid']],
    levels=[3, 4, 5]
)
```

### 自定义 RL 环境

```python
# 定义自定义工作流
custom_workflow = {
    'name': 'Code Review Process',
    'steps': [
        {'action': 'fetch_pr', 'params': {'repo': 'myorg/myrepo'}},
        {'action': 'analyze_code', 'params': {'language': 'python'}},
        {'action': 'add_comments', 'params': {'style': 'constructive'}},
        {'action': 'approve_or_request', 'params': {'threshold': 0.8}}
    ],
    'reward_fn': 'code_quality_score'
}

# 创建环境
env = await skill.create_custom_environment(
    workflow=custom_workflow,
    difficulty='hard'
)
```

---

## 🆘 故障排查

### 问题：认证失败

**错误信息：** `Authentication failed: Invalid API key`

**解决方案：**
```bash
# 1. 检查 API Key 是否正确
echo $CYBER_RECYCLE_API_KEY

# 2. 在 Dashboard 重新生成 API Key
# 访问 https://cyber-recycle.io/dashboard/api-keys

# 3. 更新配置文件
```

### 问题：Gas 费用过高

**错误信息：** `Transaction failed: Insufficient gas`

**解决方案：**
```python
# 切换到 Layer2（Polygon/Arbitrum）
skill.set_network('polygon')  # Gas 费用降低 100 倍

# 或使用批量交易
await skill.batch_transaction(operations)  # 分摊 Gas 成本
```

---

## 📞 支持

- 📧 技术支持：dev@cyber-recycle.io
- 💬 Discord：discord.gg/cyber-recycle
- 📖 文档：docs.cyber-recycle.io/mcp
- 🐦 Twitter：@CyberRecycle

---

*Skill 版本：v1.0 | 最后更新：2026-04-17*
