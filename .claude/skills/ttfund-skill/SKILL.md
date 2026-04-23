---
name: ttfund-skill
description: 天天基金综合技能包 - 通过自然语言查询基金信息、基金经理、条件选基、基金持仓、黄金分析、投顾策略、指数详情、基金净值、模拟组合管理和自选基金等信息。当用户询问基金相关问题、查询基金经理、选基、持仓分析、净值查询、投资策略、黄金行情、指数信息、自选基金或模拟组合时使用此技能。
---

# 天天基金综合技能包

## 功能概述

本技能包整合了天天基金的多种查询能力，支持通过自然语言实现以下功能：

- 基金基础信息查询
- 基金经理信息查询
- 条件选基
- 基金持仓查询
- 黄金行情分析
- 投顾策略查询
- 指数详情查询
- 基金净值查询
- 模拟组合管理
- 自选基金查询

## 前提条件

- 确保已获取有效的 `TTFUND_APIKEY`
- apikey 获取路径：打开天天基金 App → 搜索 `skills` → 在对应 Skills 页面获取 apikey

## API 配置

所有功能共用同一个 `TTFUND_APIKEY` 环境变量。

```bash
# 检查环境变量
if [ -z "$TTFUND_APIKEY" ]; then
  echo "⚠️ 未检测到环境变量 TTFUND_APIKEY。"
  echo "请先前往天天基金 App 搜索 skills，获取当前用户对应的 apikey。"
  read -r -p "请输入 TTFUND_APIKEY: " input_key
  if [ -n "$input_key" ]; then
    export TTFUND_APIKEY="$input_key"
    echo "✅ TTFUND_APIKEY 已临时设置（当前会话有效）。"
  else
    echo "❌ 输入为空，配置终止。"
    exit 1
  fi
else
  echo "✅ 检测到环境变量 TTFUND_APIKEY，正在使用..."
fi
```

## 统一调用接口

- 网关地址：`https://skills.tiantianfunds.com/ai-smart-skill-service/openapi/skill/invoke`
- 请求方式：`POST`
- 鉴权 Header：`X-API-Key`
- 请求体格式：JSON

## 支持的查询类型

### 1. 基金信息查询

**适用场景**：查询基金基础信息、公司、类型、净值、风险等级、成立日期、申购费率、阶段收益等

**示例**：
- "查询华夏成长混合基金信息"
- "000001 基金的基本情况"

**内部调用**：
```json
{
  "skill_id": "FUND_BASE_INFOS",
  "_skill_version": "1.1.0",
  "fcode": "基金代码"
}
```

### 2. 基金经理查询

**适用场景**：查询基金经理基本信息、在管产品、历史管理和业绩指标

**示例**：
- "张坤管理的基金有哪些"
- "基金经理葛兰的业绩如何"

**内部调用**：
```json
{
  "skill_id": "FUND_MANAGER_INFO",
  "_skill_version": "1.0.0",
  "manager_name": "基金经理姓名"
}
```

### 3. 条件选基

**适用场景**：根据基金分类、风险等级、基金规模、收益率等条件筛选基金

**示例**：
- "近一年收益率最高的5只基金"
- "按日涨跌幅排序的基金"

**内部调用**：
```json
{
  "skill_id": "FUND_CONDITION_SELECT",
  "_skill_version": "1.1.0",
  "pageIndex": 1,
  "pageNum": 5,
  "pageType": 1,
  "orderField": "5_6_-1"
}
```

### 4. 基金持仓查询

**适用场景**：查询基金持仓、重仓股债、行业配置与仓位

**示例**：
- "000001 的持仓情况"
- "华夏成长混合重仓了哪些股票"

**内部调用**：
```json
{
  "skill_id": "FUND_HOLDING_INFO",
  "_skill_version": "1.0.0",
  "fund_id": "基金代码或名称",
  "holding_type": "all"
}
```

### 5. 黄金行情分析

**适用场景**：查询黄金行情、宏观财政、风险指标和资讯

**示例**：
- "今天黄金行情如何"
- "黄金相关的风险指标"

**内部调用**：
```json
{
  "skill_id": "FUND_HUAAN_GOLD_INFO",
  "_skill_version": "1.0.0",
  "query_scope": "all"
}
```

### 6. 投顾策略查询

**适用场景**：查询投顾策略基本信息、业绩、风险与持仓

**示例**：
- "司南双月宝组合这个投顾策略怎么样"
- "这个投顾策略最大回撤是多少"

**内部调用**：
```json
{
  "skill_id": "FUND_TG_STRATEGY_INFO",
  "_skill_version": "1.0.0",
  "strategy_name": "策略名称",
  "query_scope": "all"
}
```

### 7. 指数详情查询

**适用场景**：查询指数点位、估值、成分和相关产品

**示例**：
- "沪深300现在点位多少"
- "创业板指估值怎么样"

**内部调用**：
```json
{
  "skill_id": "FUND_INDEX_INFO",
  "_skill_version": "1.0.0",
  "index_id": "指数名称",
  "query_scope": "all",
  "time_range": "1y"
}
```

### 8. 基金净值查询

**适用场景**：查询基金净值历史、累计净值、日涨跌幅和分红拆分事件

**示例**：
- "000001 最近一个月净值走势"
- "华夏成长混合近三年净值历史"

**内部调用**：
```json
{
  "skill_id": "FUND_NAV_INFO",
  "_skill_version": "1.0.0",
  "fund_id": "基金代码或名称",
  "range": "n"
}
```

### 9. 模拟组合管理

**适用场景**：模拟组合的列表/详情/持仓/收益/买入赎回/交易查询（调仓仅预览）

**示例**：
- "我的模拟组合情况"
- "查询组合收益"

**内部调用**：
```json
{
  "skill_id": "MODEL_PORTFOLIO",
  "_skill_version": "1.0.0",
  "action": "subacc.list",
  "subacc_list": {
    "fetchDissolve": true
  }
}
```

### 10. 自选基金查询

**适用场景**：查询用户自选基金列表与分组信息

**示例**：
- "我的自选基金有哪些"
- "查看自选股"

**内部调用**：
```json
{
  "skill_id": "FUND_FAVOR_ZX",
  "_skill_version": "1.0.0"
}
```

## 实现逻辑

1. 分析用户查询意图，确定最适合的查询类型
2. 解析用户提供的参数（基金代码、名称、基金经理、策略名称等）
3. 验证必要的环境变量（TTFUND_APIKEY）
4. 构建相应的API请求
5. 调用天天基金API
6. 解析和整理返回结果
7. 以易读格式呈现给用户

## 错误处理

- 若缺少 `TTFUND_APIKEY`，引导用户配置环境变量
- 若请求失败，提示用户稍后重试
- 若业务返回错误，如实反馈给用户
- 若返回数据为空，提示用户检查输入参数

## 使用建议

- 在进行基金投资决策前，请仔细阅读相关基金法律文件
- 基金投资有风险，过往业绩不代表未来表现
- 请根据自身的风险承受能力选择合适的基金产品