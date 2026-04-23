# 基金类天天基金Skills汇总安装指南

本文档介绍如何在本地环境中安装、配置并使用当前接入的基金类天天基金 skill。

## 前提条件

- 确保已安装 Node.js 环境（版本 16.14 或以上，推荐 18 或以上）。
- 确保已获取有效的 `TTFUND_APIKEY`。
- apikey 获取路径：
  - 打开天天基金 App
  - 搜索 `skills`
  - 在对应 Skills 页面获取 apikey
- `TTFUND_APIKEY` 与当前用户绑定，不与单个 skill 绑定。

## API Key 配置

所有基金类 skill 共用同一个 `TTFUND_APIKEY`。建议优先使用会话级环境变量，不修改 shell 启动文件，除非用户明确要求持久化配置。

```bash
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

## 统一调用信息

所有 skill 统一通过以下网关地址调用：

- 网关地址：`https://skills.tiantianfunds.com/ai-smart-skill-service/openapi/skill/invoke`
- 请求方式：`POST`
- 鉴权 Header：`X-API-Key`
- 请求体格式：JSON
- 必填字段：每次请求都要同时传 `skill_id` 和 `_skill_version`
- 当前版本说明：`FUND_BASE_INFOS` 与 `FUND_CONDITION_SELECT` 使用 `1.1.0`，其余 8 个 skill 使用 `1.0.0`。

统一请求示例：

```bash
curl --location 'https://skills.tiantianfunds.com/ai-smart-skill-service/openapi/skill/invoke' \
--header "X-API-Key: $TTFUND_APIKEY" \
--header 'Content-Type: application/json' \
--data '{
  "skill_id": "FUND_MANAGER_INFO",
  "_skill_version": "1.0.0",
  "manager_name": "张坤"
}'
```

## Skill 列表

### 1. 天天基金信息skill

- 技能名称：`天天基金信息skill`
- skill_id：`FUND_BASE_INFOS`
- version：`1.1.0`
- 简短说明：基金基础信息查询
- 状态：`enabled`

### 2. 基金经理查询

- 技能名称：`基金经理查询`
- skill_id：`FUND_MANAGER_INFO`
- version：`1.0.0`
- 简短说明：基金经理基本信息、在管产品、历史管理和业绩指标查询
- 状态：`enabled`

### 3. 天天条件选基skill

- 技能名称：`天天条件选基skill`
- skill_id：`FUND_CONDITION_SELECT`
- version：`1.1.0`
- 简短说明：条件选基
- 状态：`enabled`

### 4. 基金持仓查询

- 技能名称：`基金持仓查询`
- skill_id：`FUND_HOLDING_INFO`
- version：`1.0.0`
- 简短说明：基金持仓、重仓股债、行业配置与仓位查询
- 状态：`enabled`

### 5. 天天黄金查询

- 技能名称：`天天黄金查询`
- skill_id：`FUND_HUAAN_GOLD_INFO`
- version：`1.0.0`
- 简短说明：天天黄金查询
- 状态：`enabled`

### 6. 投顾策略查询

- 技能名称：`投顾策略查询`
- skill_id：`FUND_TG_STRATEGY_INFO`
- version：`1.0.0`
- 简短说明：投顾策略基本信息、业绩、风险与持仓查询
- 状态：`enabled`

### 7. 指数详情查询

- 技能名称：`指数详情查询`
- skill_id：`FUND_INDEX_INFO`
- version：`1.0.0`
- 简短说明：指数点位、估值、成分和相关产品查询
- 状态：`enabled`

### 8. 基金净值查询

- 技能名称：`基金净值查询`
- skill_id：`FUND_NAV_INFO`
- version：`1.0.0`
- 简短说明：基金净值历史、累计净值、日涨跌幅和分红拆分事件查询
- 状态：`enabled`

### 9. 模拟组合管理与交易skill

- 技能名称：`模拟组合管理与交易skill`
- skill_id：`MODEL_PORTFOLIO`
- version：`1.0.0`
- 简短说明：模拟组合的列表/详情/持仓/收益/买入赎回/交易查询（调仓仅预览）
- 状态：`enabled`

<<<<<<< HEAD
=======
### 10. 天天基金自选查询skill

- 技能名称：`天天基金自选查询skill`
- skill_id：`FUND_FAVOR_ZX`
- version：`1.0.0`
- 简短说明：查询用户自选基金列表与分组信息
- 状态：`enabled`

>>>>>>> master
## 参数说明

### 1. 天天基金信息skill

- skill_id：`FUND_BASE_INFOS`
- version：`1.1.0`

| 请求字段 | 类型 | 必填 | 说明 | 示例 |
|---|---|---|---|---|
| `fcode` | `string` | 是 | 基金代码 | `000001` |

最小可用请求：

```json
{
  "skill_id": "FUND_BASE_INFOS",
  "_skill_version": "1.1.0",
  "fcode": "000001"
}
```

说明：
- 当前最稳妥的调用方式是直接传基金代码。
- 若上层应用要支持基金名称输入，建议先做名称解析，再回填 `fcode`。

### 2. 基金经理查询

- skill_id：`FUND_MANAGER_INFO`

| 请求字段 | 类型 | 必填 | 说明 | 示例 |
|---|---|---|---|---|
| `manager_id` | `string` | 与 `manager_name` 二选一 | 基金经理代码 | `30189744` |
| `manager_name` | `string` | 与 `manager_id` 二选一 | 基金经理姓名 | `张坤` |

最小可用请求：

```json
{
  "skill_id": "FUND_MANAGER_INFO",
  "_skill_version": "1.0.0",
  "manager_name": "张坤"
}
```

常见自然语言映射：
- `张坤现在管理哪些基金` -> `manager_name=张坤`
- `葛兰的管理规模多大` -> `manager_name=葛兰`
- `30189744 是谁` -> `manager_id=30189744`

### 3. 天天条件选基skill

- skill_id：`FUND_CONDITION_SELECT`
- version：`1.1.0`

常用字段：

| 请求字段 | 类型 | 必填 | 说明 | 示例 |
|---|---|---|---|---|
| `pageIndex` | `integer` | 否 | 页码 | `1` |
| `pageNum` | `integer` | 否 | 每页返回数量 | `5` |
| `pageType` | `integer` | 否 | 页面类型，常用 `1` | `1` |
| `orderField` | `string` | 否 | 排序字段 | `5_6_-1` |
| `rsfType` | `string` | 否 | 一级基金分类 | `002` |
| `rsbType` | `string` | 否 | 二级基金分类 | `002001` |
| `riskLevel` | `string` | 否 | 风险等级，多值逗号分隔 | `3,4` |
| `fundLevel` | `string` | 否 | 基金评级，多值逗号分隔 | `4,5` |
| `fundSize` | `string` | 否 | 基金规模筛选 | `2,3` |
| `isBuy` | `string` | 否 | 是否可购，`1` 是 | `1` |
| `isDt` | `string` | 否 | 是否支持定投，`1` 是 | `1` |
| `stageSyl` | `string` | 否 | 阶段收益率筛选 | `6_0_50` |
| `annualStageSyl` | `string` | 否 | 年化收益率筛选 | `6_0_30` |
| `annualizedVolatility` | `string` | 否 | 年化波动率筛选 | `6_0_20` |
| `stageRanking` | `string` | 否 | 阶段同类排名筛选 | `6_0_20` |
| `followIndex` | `string` | 否 | 跟踪指数代码 | `000300` |
| `fcode` | `string` | 否 | 指定基金代码，多值逗号分隔 | `000001,000006` |
| `bkcodes` | `string` | 否 | 主题板块代码 | `000001` |

常用 `orderField`：

| 含义 | 值 |
|---|---|
| 近1年收益率倒序 | `5_6_-1` |
| 日涨跌幅倒序 | `5_1_-1` |

最小可用请求：

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

按日涨跌幅选基：

```json
{
  "skill_id": "FUND_CONDITION_SELECT",
  "_skill_version": "1.1.0",
  "pageIndex": 1,
  "pageNum": 5,
  "pageType": 1,
  "orderField": "5_1_-1"
}
```

常见自然语言映射：
- `近一年收益率最高的5只基金` -> `orderField=5_6_-1,pageNum=5`
- `日涨跌幅最高的5只基金` -> `orderField=5_1_-1,pageNum=5`

### 4. 基金持仓查询

- skill_id：`FUND_HOLDING_INFO`

| 请求字段 | 类型 | 必填 | 说明 | 示例 |
|---|---|---|---|---|
| `fund_id` | `string` | 是 | 基金代码或基金名称 | `000001` |
| `report_period` | `string` | 否 | 报告期 | `2025-Q4` |
| `holding_type` | `string` | 否 | 持仓类型：`stock` / `bond` / `all` | `all` |

最小可用请求：

```json
{
  "skill_id": "FUND_HOLDING_INFO",
  "_skill_version": "1.0.0",
  "fund_id": "000001",
  "holding_type": "all"
}
```

常见自然语言映射：
- `000001 的持仓情况` -> `fund_id=000001,holding_type=all`
- `华夏成长混合重仓了哪些股票` -> `fund_id=华夏成长混合,holding_type=stock`

### 5. 天天黄金查询

- skill_id：`FUND_HUAAN_GOLD_INFO`

| 请求字段 | 类型 | 必填 | 说明 | 示例 |
|---|---|---|---|---|
| `query_scope` | `string` | 否 | 查询范围：`gold` / `macro` / `risk` / `news` / `all` | `all` |

最小可用请求：

```json
{
  "skill_id": "FUND_HUAAN_GOLD_INFO",
  "_skill_version": "1.0.0",
  "query_scope": "all"
}
```

常见自然语言映射：
- `今天黄金行情如何` -> `query_scope=all`
- `最近有哪些黄金相关新闻` -> `query_scope=news`
- `黄金的风险指标怎么样` -> `query_scope=risk`

### 6. 投顾策略查询

- skill_id：`FUND_TG_STRATEGY_INFO`

| 请求字段 | 类型 | 必填 | 说明 | 示例 |
|---|---|---|---|---|
| `strategy_id` | `string` | 与 `strategy_name` 二选一 | 策略代码 | `PEYCXNH` |
| `strategy_name` | `string` | 与 `strategy_id` 二选一 | 策略名称 | `司南双月宝组合` |
| `query_scope` | `string` | 否 | 查询范围：`basic` / `performance` / `composition` / `risk` / `all` | `all` |

最小可用请求：

```json
{
  "skill_id": "FUND_TG_STRATEGY_INFO",
  "_skill_version": "1.0.0",
  "strategy_name": "司南双月宝组合",
  "query_scope": "all"
}
```

常见自然语言映射：
- `帮我看看司南双月宝组合这个投顾策略` -> `strategy_name=司南双月宝组合,query_scope=all`
- `这个投顾策略最大回撤是多少` -> `query_scope=risk`

### 7. 指数详情查询

- skill_id：`FUND_INDEX_INFO`

| 请求字段 | 类型 | 必填 | 说明 | 示例 |
|---|---|---|---|---|
| `index_id` | `string` | 是 | 指数代码或指数名称 | `沪深300` |
| `query_scope` | `string` | 否 | 查询范围：`quote` / `valuation` / `composition` / `performance` / `products` / `all` | `all` |
| `time_range` | `string` | 否 | 历史业绩时间范围 | `1y` |

最小可用请求：

```json
{
  "skill_id": "FUND_INDEX_INFO",
  "_skill_version": "1.0.0",
  "index_id": "沪深300",
  "query_scope": "all",
  "time_range": "1y"
}
```

常见自然语言映射：
- `沪深300现在点位多少` -> `index_id=沪深300,query_scope=all`
- `创业板指估值怎么样` -> `index_id=创业板指,query_scope=valuation`

### 8. 基金净值查询

- skill_id：`FUND_NAV_INFO`

| 请求字段 | 类型 | 必填 | 说明 | 示例 |
|---|---|---|---|---|
| `fund_id` | `string` | 是 | 基金代码或基金名称 | `000001` |
| `range` | `string` | 否 | 净值历史范围 | `n` |

`range` 枚举：

| 值 | 含义 |
|---|---|
| `y` | 近一月 |
| `3y` | 近三月 |
| `6y` | 近六月 |
| `n` | 近一年 |
| `2n` | 近两年 |
| `3n` | 近三年 |
| `ln` | 成立以来 |

最小可用请求：

```json
{
  "skill_id": "FUND_NAV_INFO",
  "_skill_version": "1.0.0",
  "fund_id": "000001",
  "range": "n"
}
```

常见自然语言映射：
- `000001 最近一个月净值走势` -> `fund_id=000001,range=y`
- `华夏成长混合近三年净值历史` -> `fund_id=华夏成长混合,range=3n`
- `成立以来净值` -> `range=ln`

### 9. 天天基金自选查询skill

- skill_id：`FUND_FAVOR_ZX`
- version：`1.0.0`

说明：
- 该 skill 为用户维度查询，`passportid` 与 `authkey` 由平台上下文/系统注入。
- 查询类型 `requestType` 由系统固定注入，默认使用 `7`（`4+2+1`），即同时返回自选列表、分组信息、组合信息。

最小可用请求：

```json
{
  "skill_id": "FUND_FAVOR_ZX",
  "_skill_version": "1.0.0"
}
```

## 调用示例

### 1. 调用 天天基金信息skill

```bash
curl --location 'https://skills.tiantianfunds.com/ai-smart-skill-service/openapi/skill/invoke' \
--header "X-API-Key: $TTFUND_APIKEY" \
--header 'Content-Type: application/json' \
--data '{
  "skill_id": "FUND_BASE_INFOS",
  "_skill_version": "1.1.0",
  "fcode": "000001"
}'
```

### 2. 调用 基金经理查询

```bash
curl --location 'https://skills.tiantianfunds.com/ai-smart-skill-service/openapi/skill/invoke' \
--header "X-API-Key: $TTFUND_APIKEY" \
--header 'Content-Type: application/json' \
--data '{
  "skill_id": "FUND_MANAGER_INFO",
  "_skill_version": "1.0.0",
  "manager_name": "张坤"
}'
```

### 3. 调用 天天条件选基skill

```bash
curl --location 'https://skills.tiantianfunds.com/ai-smart-skill-service/openapi/skill/invoke' \
--header "X-API-Key: $TTFUND_APIKEY" \
--header 'Content-Type: application/json' \
--data '{
  "skill_id": "FUND_CONDITION_SELECT",
  "_skill_version": "1.1.0",
  "pageIndex": 1,
  "pageNum": 5,
  "pageType": 1,
  "orderField": "5_6_-1"
}'
```

### 4. 调用 基金持仓查询

```bash
curl --location 'https://skills.tiantianfunds.com/ai-smart-skill-service/openapi/skill/invoke' \
--header "X-API-Key: $TTFUND_APIKEY" \
--header 'Content-Type: application/json' \
--data '{
  "skill_id": "FUND_HOLDING_INFO",
  "_skill_version": "1.0.0",
  "fund_id": "000001",
  "holding_type": "all"
}'
```

### 5. 调用 天天黄金查询

```bash
curl --location 'https://skills.tiantianfunds.com/ai-smart-skill-service/openapi/skill/invoke' \
--header "X-API-Key: $TTFUND_APIKEY" \
--header 'Content-Type: application/json' \
--data '{
  "skill_id": "FUND_HUAAN_GOLD_INFO",
  "_skill_version": "1.0.0",
  "query_scope": "all"
}'
```

### 6. 调用 投顾策略查询

```bash
curl --location 'https://skills.tiantianfunds.com/ai-smart-skill-service/openapi/skill/invoke' \
--header "X-API-Key: $TTFUND_APIKEY" \
--header 'Content-Type: application/json' \
--data '{
  "skill_id": "FUND_TG_STRATEGY_INFO",
  "_skill_version": "1.0.0",
  "strategy_name": "司南双月宝组合",
  "query_scope": "all"
}'
```

### 7. 调用 指数详情查询

```bash
curl --location 'https://skills.tiantianfunds.com/ai-smart-skill-service/openapi/skill/invoke' \
--header "X-API-Key: $TTFUND_APIKEY" \
--header 'Content-Type: application/json' \
--data '{
  "skill_id": "FUND_INDEX_INFO",
  "_skill_version": "1.0.0",
  "index_id": "沪深300",
  "query_scope": "all",
  "time_range": "1y"
}'
```

### 8. 调用 基金净值查询

```bash
curl --location 'https://skills.tiantianfunds.com/ai-smart-skill-service/openapi/skill/invoke' \
--header "X-API-Key: $TTFUND_APIKEY" \
--header 'Content-Type: application/json' \
--data '{
  "skill_id": "FUND_NAV_INFO",
  "_skill_version": "1.0.0",
  "fund_id": "000001",
  "range": "n"
}'
```

### 9. 调用 模拟组合管理与交易skill

```bash
curl --location 'https://skills.tiantianfunds.com/ai-smart-skill-service/openapi/skill/invoke' \
--header "X-API-Key: $TTFUND_APIKEY" \
--header 'Content-Type: application/json' \
--data '{
  "skill_id": "MODEL_PORTFOLIO",
  "_skill_version": "1.0.0",
  "action": "subacc.list",
  "subacc_list": {
    "fetchDissolve": true
  }
}'
```

<<<<<<< HEAD
=======
### 10. 调用 天天基金自选查询skill

```bash
curl --location 'https://skills.tiantianfunds.com/ai-smart-skill-service/openapi/skill/invoke' \
--header "X-API-Key: $TTFUND_APIKEY" \
--header 'Content-Type: application/json' \
--data '{
  "skill_id": "FUND_FAVOR_ZX",
  "_skill_version": "1.0.0"
}'
```

>>>>>>> master
## 返回结果说明

统一网关返回格式示例：

```json
{
  "code": 0,
  "message": "success",
  "data": {
    "skill_id": "FUND_MANAGER_INFO",
    "skill_name": "基金经理查询",
    "raw_result": {
      "status_code": 200,
      "body": {}
    },
    "field_interpretations": []
  }
}
```

核心字段说明：

- `code`：网关调用状态，`0` 表示成功
- `message`：网关提示信息
- `data.skill_id`：实际调用的 skill 标识
- `data.skill_name`：skill 名称
- `data.raw_result.status_code`：下游接口 HTTP 状态码
- `data.raw_result.body`：下游接口原始响应体
- `data.field_interpretations`：基于 `skill_config.response.fields` 生成的关键字段解释

## 错误处理

- 若缺少 `TTFUND_APIKEY`，必须先引导用户前往天天基金 App 搜索 `skills` 获取 apikey，并完成环境变量配置。
- 若请求返回非 2xx 状态码，应提示用户服务暂时不可用，请稍后重试。
- 若业务返回 `errorCode != 0`，应视为业务失败，不伪造成功结果。
- 若返回数据为空，应提示用户检查基金代码、基金名称或其他输入参数是否正确。

## 使用建议


## 各 Skill 详细文档

以下内容复用单个 skill 的完整渲染结果，便于对照字段释义、交互规范、错误处理和输出建议。

### 1. 天天基金信息skill 详细说明

---

请为我安装如下skill

## name:

天天基金信息skill

## version:

1.1.0

## description:

本 Skill 基于**fund**构建，支持通过**自然语言**实现以下功能：
- 调用 `FUND_BASE_INFOS` 对应的核心能力
- 当前发布版本为 `1.0.0`，调用时必须携带 `_skill_version`
- 支持基金代码直查；若仅提供基金名称，则先通过模糊搜索接口解析 fund_code，再查询基金基础信息，返回基金名称、基金公司、基金类型、单位净值、累计净值、风险等级、成立日期、申购费率、阶段收益、波动率、最大回撤及相关跟踪指标，用于基金信息查询、风险收益评估和后续分析。
- 输出适合阅读和进一步分析的结构化结果

---

# 天天基金信息skill

通过**自然语言**或结构化参数调用 `FUND_BASE_INFOS` 对应能力，接口返回 JSON 格式内容。

- 当前 skill 版本：`1.0.0`

## 使用方式

1. 在调用任何接口前，必须先检查本地环境变量 `TTFUND_APIKEY` 是否存在。
2. 若本地已存在 `TTFUND_APIKEY`，则直接使用该 apikey 发起请求。
3. 若本地不存在 `TTFUND_APIKEY`，必须强制引导用户先配置 apikey，不得跳过。
4. apikey 获取路径：
   - 打开 **天天基金**
   - 搜索 **skills**
   - 在对应 Skills 页面获取 `天天基金信息skill` 对应的 apikey
5. 当检测到 apikey 缺失时，必须明确提示用户：
   - `当前未检测到本地环境变量 TTFUND_APIKEY，请先前往天天基金搜索 skills 获取 apikey，并在本机配置环境变量后再继续使用。`
6. 在用户未完成 apikey 配置前，不继续执行 skill 查询请求。
7. 配置完成后，使用 **POST** 请求调用统一网关接口，并将 apikey 放入 `X-API-Key` 请求头中。
8. 每次请求体都必须同时携带 `skill_id` 和 `_skill_version`。
9. `_skill_version` 必须填写当前安装版本：`1.0.0`。

编写调用方式脚本

```bash
curl --location 'https://skills.tiantianfunds.com/ai-smart-skill-service/openapi/skill/invoke' \
--header "X-API-Key: $TTFUND_APIKEY" \
--header 'Content-Type: application/json' \
--data '{
  "skill_id": "FUND_BASE_INFOS",
  "_skill_version": "1.1.0",
  "fund_name": "华夏核心成长混合C"
}'
```

如果当前底层接口未强制校验 apikey，也必须先检查并要求配置 `TTFUND_APIKEY`，不可省略该步骤。

## 编排流程

该 skill 使用服务端 workflow 自动完成名称解析、数据获取与结果聚合，对调用方透明。

- 若已提供 `fcode`，服务端优先直查；缺少时可根据 `fund_name` 自动解析候选代码。
## 请求参数说明

以下表格说明统一网关接收的对外请求字段；若 skill 配置了 workflow，系统会在内部自动完成名称解析、代码回填和最终详情接口调用。

| 请求字段 | 类型 | 必填 | 说明 | 示例 |
|----|----|----|----|----|
| `fcode` | `string` | 至少传一项 | 基金代码，优先直查，例如 000006；与 `fund_name` 至少传一个 | `000006` |
| `fund_name` | `string` | 至少传一项 | 基金名称；缺少 fcode 时用于模糊搜索解析基金代码；与 `fcode` 至少传一个 | `华夏核心成长混合C` |

## 问句示例

| 类型 | query |
|----|----|
| 查询 天天基金信息skill | 帮我调用 FUND_BASE_INFOS |
| 按示例参数调用 | 使用 FUND_BASE_INFOS，参数参考请求示例 |
| 查询结果解释 | 帮我读取 FUND_BASE_INFOS 的返回结果并解释关键字段 |

## 接口结果释义

### 一、业务结果根节点 (`data.raw_result.body`)

以下字段位于统一网关返回中的 `data.raw_result.body`，是实际业务结果的根节点。

| 字段路径 | 类型 | 核心释义 |
|----|----|----|
| `data` | array | 核心业务数据 |
| `errorCode` | integer | 接口全局错误码，0 = 成功 |
| `firstError` | null | 首个错误信息，失败时用于定位问题 |
| `success` | boolean | 接口是否成功，true = 成功 |
| `hasWrongToken` | null | 鉴权异常标记 |
| `totalCount` | integer | 返回结果数量 |
| `expansion` | null | 扩展字段 |
| `jf` | string | 来源标识 |

### 二、核心字段说明

以下字段说明均面向 `data.raw_result.body`，不展开服务端内部编排、上下游映射和调试字段。

| 字段 Key | 含义说明 |
| --- | --- |
| `data` | 核心业务数据，请结合 response.example 理解字段含义 |

## 交互规范

1. 优先检查环境变量 `TTFUND_APIKEY`。
2. 若环境变量存在，则直接继续调用接口。
3. 若环境变量不存在，必须中断当前调用，并强制提示用户先完成 apikey 配置。
4. 引导文案必须明确包含：
   - 环境变量名：`TTFUND_APIKEY`
   - apikey 获取路径：`天天基金搜索 skills`
5. 每次请求都必须带上 `skill_id` 和 `_skill_version`。
6. `_skill_version` 固定使用当前安装版本：`1.0.0`。
7. 若缺少必填参数，应提示用户补充 `fcode 或 fund_name（至少传一个）`。
8. 返回结果时，应优先提炼核心信息，而不是直接原样堆砌所有字段。
9. 结果解释顺序必须是：先看业务结果，再看 `version_info`，最后决定是否追加升级建议。

## 输出建议

返回时优先展示：
- `business_result`
- `explanation_document`

如需结构化输出，建议包含两部分：

- `business_result`：对应 `data.raw_result.body` 的核心业务结果
- `explanation_document`：对关键字段和结果差异的说明

说明：统一网关还可能返回少量辅助信息，用于调试、排错或版本提示；用户文档默认不展开这些字段，请以 `data.raw_result.body` 为准。

后处理要求：

- 若 `data.version_info.is_outdated = true`，先完成本次结果回答，再附上一句简洁升级提醒。
- 若接口返回升级导向错误，不要重复盲重试，也不要误判为普通网络问题，应直接提示用户升级 skill。
- 若接口返回普通业务错误且没有版本归因信号，则按原有逻辑处理，不额外渲染升级提示。

## 错误处理

- 若缺少 apikey，应提示用户：
  - `当前未检测到 TTFUND_APIKEY，请先前往天天基金搜索 skills 获取 apikey，并在本机配置该环境变量后重试。`
- 若缺少 `_skill_version`，应提示用户：
  - `当前安装的 skill 可能为旧版本，未携带版本信息。请升级到最新版本 1.0.0 后重试。`
- 若 `_skill_version` 为空或无效，应提示用户：
  - `当前安装的 skill 版本信息无效，可能为旧版本或安装不完整。请升级到最新版本 1.0.0 后重试。`
- 若 HTTP 请求失败、超时或返回非 2xx 状态码，应提示用户：
  - `天天基金信息skill服务暂时不可用，请稍后重试。`
- 若返回 `version_info` 表示本地版本落后，应优先提示用户尽快升级 skill。
- 若版本落后且本次错误属于参数缺失、字段不兼容或调用协议不匹配，应优先提示用户先升级 skill 再重试。
- 若业务成功字段 `errorCode` 校验失败，则视为业务失败：
  - 简要说明错误信息
  - 不自行猜测结果或伪造成功
- 若核心返回数据为空，应提示用户检查输入参数是否正确。

## 安全与边界

- 该 Skill 返回的是 `天天基金信息skill` 对应的业务数据，请按业务场景谨慎使用。
- 返回内容仅用于当前用户请求的查询与分析，不应伪造结果或输出未验证内容。


### 2. 基金经理查询 详细说明

---

请为我安装如下skill

## name:

基金经理查询

## version:

1.0.0

## description:

本 Skill 基于**fund**构建，支持通过**自然语言**实现以下功能：
- 调用 `FUND_MANAGER_INFO` 对应的核心能力
- 当前发布版本为 `1.0.0`，调用时必须携带 `_skill_version`
- 支持基金经理代码直查；若仅提供基金经理姓名，则先解析 manager_id，再并行查询基金经理基本信息、代表基金信息、当前在管基金列表、历史离任基金列表与多周期风险收益指标，最终聚合返回基金经理基础信息、代表基金、在管/历史管理产品、绩效概览和用于生成 AI 风格解读的原始数据。
- 输出适合阅读和进一步分析的结构化结果

---

# 基金经理查询

通过**自然语言**或结构化参数调用 `FUND_MANAGER_INFO` 对应能力，接口返回 JSON 格式内容。

- 当前 skill 版本：`1.0.0`

## 使用方式

1. 在调用任何接口前，必须先检查本地环境变量 `TTFUND_APIKEY` 是否存在。
2. 若本地已存在 `TTFUND_APIKEY`，则直接使用该 apikey 发起请求。
3. 若本地不存在 `TTFUND_APIKEY`，必须强制引导用户先配置 apikey，不得跳过。
4. apikey 获取路径：
   - 打开 **天天基金**
   - 搜索 **skills**
   - 在对应 Skills 页面获取 `基金经理查询` 对应的 apikey
5. 当检测到 apikey 缺失时，必须明确提示用户：
   - `当前未检测到本地环境变量 TTFUND_APIKEY，请先前往天天基金搜索 skills 获取 apikey，并在本机配置环境变量后再继续使用。`
6. 在用户未完成 apikey 配置前，不继续执行 skill 查询请求。
7. 配置完成后，使用 **POST** 请求调用统一网关接口，并将 apikey 放入 `X-API-Key` 请求头中。
8. 每次请求体都必须同时携带 `skill_id` 和 `_skill_version`。
9. `_skill_version` 必须填写当前安装版本：`1.0.0`。

编写调用方式脚本

```bash
curl --location 'https://skills.tiantianfunds.com/ai-smart-skill-service/openapi/skill/invoke' \
--header "X-API-Key: $TTFUND_APIKEY" \
--header 'Content-Type: application/json' \
--data '{
  "skill_id": "FUND_MANAGER_INFO",
  "_skill_version": "1.0.0",
  "manager_name": "张坤"
}'
```

如果当前底层接口未强制校验 apikey，也必须先检查并要求配置 `TTFUND_APIKEY`，不可省略该步骤。

## 编排流程

该 skill 使用服务端 workflow 自动完成名称解析、数据获取与结果聚合，对调用方透明。

- 若已提供 `manager_id`，服务端优先直查；缺少时可根据 `manager_name` 自动解析候选代码。
- 服务端会自动执行内部步骤并完成聚合；当前配置共包含 `5` 个业务步骤。
- 文档中的返回字段说明仅面向最终业务结果 `data.raw_result.body`，不展开内部字段映射关系。
## 请求参数说明

以下表格说明统一网关接收的对外请求字段；若 skill 配置了 workflow，系统会在内部自动完成名称解析、代码回填和最终详情接口调用。

| 请求字段 | 类型 | 必填 | 说明 | 示例 |
|----|----|----|----|----|
| `manager_id` | `string` | 至少传一项 | 基金经理代码，优先直查；与 `manager_name` 至少传一个 | `30289521` |
| `manager_name` | `string` | 至少传一项 | 基金经理姓名，缺少 manager_id 时用于解析基金经理代码；与 `manager_id` 至少传一个 | `张坤` |

## 问句示例

| 类型 | query |
|----|----|
| 查询 基金经理查询 | 帮我调用 FUND_MANAGER_INFO |
| 按示例参数调用 | 使用 FUND_MANAGER_INFO，参数参考请求示例 |
| 查询结果解释 | 帮我读取 FUND_MANAGER_INFO 的返回结果并解释关键字段 |

## 接口结果释义

### 一、业务结果根节点 (`data.raw_result.body`)

以下字段位于统一网关返回中的 `data.raw_result.body`，是实际业务结果的根节点。

| 字段路径 | 类型 | 核心释义 |
|----|----|----|
| `success` | boolean | 接口是否成功，true = 成功 |
| `errorCode` | integer | 接口全局错误码，0 = 成功 |
| `data` | object | 核心业务数据 |

### 二、核心字段说明

以下字段说明均面向 `data.raw_result.body`，不展开服务端内部编排、上下游映射和调试字段。

| 字段 Key | 含义说明 |
| --- | --- |
| `success` | 接口是否成功；true 表示服务端 workflow 聚合成功 |
| `errorCode` | 业务错误码；0 表示成功，非 0 表示失败 |
| `data.manager_profile` | 基金经理基本信息聚合结果 |
| `data.manager_profile.manager_name` | 基金经理姓名 |
| `data.manager_profile.company` | 所属基金公司 |
| `data.manager_profile.start_date` | 从业起始日期 |
| `data.manager_profile.years_of_experience_days` | 从业累计管理天数；上层 skill 可换算为“X年X个月” |
| `data.manager_profile.education` | 学历背景 |
| `data.manager_profile.profile_summary` | 基金经理简介；来源于公开资料字段 RESUME |
| `data.manager_profile.investment_idea` | 投资理念 |
| `data.manager_profile.investment_method` | 投资方法 |
| `data.manager_profile.representative_fund_code` | 代表基金代码，优先取 fundBaseInfo 返回结果 |
| `data.manager_profile.representative_fund_name` | 代表基金名称，优先取 fundBaseInfo 返回结果 |
| `data.manager_profile.representative_fund_type` | 代表基金类型 |
| `data.manager_profile.representative_fund_return_1y` | 代表基金近1年收益率 |
| `data.manager_profile.representative_fund_manage_return` | 代表基金任职以来收益率 |
| `data.managed_funds` | 基金经理当前在管基金原始列表，来源于 MangerInOfficeFund 的 data 数组 |
| `data.managed_funds[].SHORTNAME` | 在管基金名称 |
| `data.managed_funds[].FCODE` | 在管基金代码 |
| `data.managed_funds[].FTYPE` | 在管基金类型 |
| `data.managed_funds[].ENDNAV` | 在管基金规模；原始口径通常为元，上层可换算为亿元展示 |
| `data.managed_funds[].SYL_1N` | 在管基金近1年收益率；应保守解释为近1年收益率，不直接等同于今年以来收益率 |
| `data.managed_funds[].TLGROWTH` | 在管基金同类同期平均收益率 |
| `data.managed_funds[].PENAVGROWTH` | 在管基金任职以来回报率 |
| `data.managed_funds[].FEMPDATE` | 在管基金开始管理日期 |
| `data.managed_funds[].TLRANK` | 在管基金同类同期排名分子 |
| `data.managed_funds[].TLSC` | 在管基金同类同期排名样本总数；可与 TLRANK 组合展示为 x/xx |
| `data.managed_fund_count` | 当前在管基金数量 |
| `data.historical_managed_funds` | 基金经理历史管理基金原始列表，通常包含开始管理日期、离任日期、任职天数和任职以来收益 |
| `data.historical_managed_fund_count` | 历史管理基金数量 |
| `data.performance_overview` | 基金经理历史业绩概览 |
| `data.performance_overview.annualized_return` | 年化收益率 |
| `data.performance_overview.win_rate_vs_benchmark` | 跑赢大盘概率 |
| `data.performance_overview.max_drawdown` | 管理期间最大回撤 |
| `data.performance_overview.ytd_return` | 今年以来收益率 |
| `data.performance_overview.return_3y` | 近3年收益率 |
| `data.performance_overview.return_5y` | 近5年收益率 |
| `data.performance_overview.risk_metrics` | 多周期风险收益指标，包括最大回撤、夏普比率、波动率及部分同类排名 |
| `data.performance_overview.risk_metrics.max_drawdown.year_1.value` | 近1年最大回撤 |
| `data.performance_overview.risk_metrics.sharpe.year_1.value` | 近1年夏普比率 |
| `data.performance_overview.risk_metrics.volatility.year_1.value` | 近1年波动率 |
| `data.disambiguation_candidates` | 名称歧义时的候选经理原始列表，供 skill 引导用户选择 |
| `data.resolution_selected` | 当前 resolver 自动选中的候选，仅供参考，不应在多候选时直接信任 |
| `data.risk_disclaimer` | 风险提示语 |

## 交互规范

1. 优先检查环境变量 `TTFUND_APIKEY`。
2. 若环境变量存在，则直接继续调用接口。
3. 若环境变量不存在，必须中断当前调用，并强制提示用户先完成 apikey 配置。
4. 引导文案必须明确包含：
   - 环境变量名：`TTFUND_APIKEY`
   - apikey 获取路径：`天天基金搜索 skills`
5. 每次请求都必须带上 `skill_id` 和 `_skill_version`。
6. `_skill_version` 固定使用当前安装版本：`1.0.0`。
7. 若缺少必填参数，应提示用户补充 `manager_id 或 manager_name（至少传一个）`。
8. 返回结果时，应优先提炼核心信息，而不是直接原样堆砌所有字段。
9. 结果解释顺序必须是：先看业务结果，再看 `version_info`，最后决定是否追加升级建议。

## 输出建议

返回时优先展示：
- `success`
- `errorCode`
- `data.manager_profile`
- `data.manager_profile.manager_name`
- `data.manager_profile.company`
- `data.manager_profile.start_date`
- `data.manager_profile.years_of_experience_days`
- `data.manager_profile.education`

如需结构化输出，建议包含两部分：

- `business_result`：对应 `data.raw_result.body` 的核心业务结果
- `explanation_document`：对关键字段和结果差异的说明

说明：统一网关还可能返回少量辅助信息，用于调试、排错或版本提示；用户文档默认不展开这些字段，请以 `data.raw_result.body` 为准。

后处理要求：

- 若 `data.version_info.is_outdated = true`，先完成本次结果回答，再附上一句简洁升级提醒。
- 若接口返回升级导向错误，不要重复盲重试，也不要误判为普通网络问题，应直接提示用户升级 skill。
- 若接口返回普通业务错误且没有版本归因信号，则按原有逻辑处理，不额外渲染升级提示。

## 错误处理

- 若缺少 apikey，应提示用户：
  - `当前未检测到 TTFUND_APIKEY，请先前往天天基金搜索 skills 获取 apikey，并在本机配置该环境变量后重试。`
- 若缺少 `_skill_version`，应提示用户：
  - `当前安装的 skill 可能为旧版本，未携带版本信息。请升级到最新版本 1.0.0 后重试。`
- 若 `_skill_version` 为空或无效，应提示用户：
  - `当前安装的 skill 版本信息无效，可能为旧版本或安装不完整。请升级到最新版本 1.0.0 后重试。`
- 若 HTTP 请求失败、超时或返回非 2xx 状态码，应提示用户：
  - `基金经理查询服务暂时不可用，请稍后重试。`
- 若返回 `version_info` 表示本地版本落后，应优先提示用户尽快升级 skill。
- 若版本落后且本次错误属于参数缺失、字段不兼容或调用协议不匹配，应优先提示用户先升级 skill 再重试。
- 若业务成功字段 `success` 校验失败，则视为业务失败：
  - 简要说明错误信息
  - 不自行猜测结果或伪造成功
- 若核心返回数据为空，应提示用户检查输入参数是否正确。

## 安全与边界

- 该 Skill 返回的是 `基金经理查询` 对应的业务数据，请按业务场景谨慎使用。
- 返回内容仅用于当前用户请求的查询与分析，不应伪造结果或输出未验证内容。


### 3. 天天条件选基skill 详细说明

---

请为我安装如下skill

## name:

天天条件选基skill

## version:

1.1.0

## description:

本 Skill 基于**fund**构建，支持通过**自然语言**实现以下功能：
- 调用 `FUND_CONDITION_SELECT` 对应的核心能力
- 当前发布版本为 `1.1.0`，调用时必须携带 `_skill_version`
- 根据基金分类、风险等级、基金规模、费率、收益率、波动率、最大回撤、定投表现等个性化筛选条件筛选基金，返回基金基础信息、收益排名及榜单相关指标，用于条件选基与候选基金分析。
- 输出适合阅读和进一步分析的结构化结果

---

# 天天条件选基skill

通过**自然语言**或结构化参数调用 `FUND_CONDITION_SELECT` 对应能力，接口返回 JSON 格式内容。

- 当前 skill 版本：`1.1.0`

## 使用方式

1. 在调用任何接口前，必须先检查本地环境变量 `TTFUND_APIKEY` 是否存在。
2. 若本地已存在 `TTFUND_APIKEY`，则直接使用该 apikey 发起请求。
3. 若本地不存在 `TTFUND_APIKEY`，必须强制引导用户先配置 apikey，不得跳过。
4. apikey 获取路径：
   - 打开 **天天基金**
   - 搜索 **skills**
   - 在对应 Skills 页面获取 `天天条件选基skill` 对应的 apikey
5. 当检测到 apikey 缺失时，必须明确提示用户：
   - `当前未检测到本地环境变量 TTFUND_APIKEY，请先前往天天基金搜索 skills 获取 apikey，并在本机配置环境变量后再继续使用。`
6. 在用户未完成 apikey 配置前，不继续执行 skill 查询请求。
7. 配置完成后，使用 **POST** 请求调用统一网关接口，并将 apikey 放入 `X-API-Key` 请求头中。
8. 每次请求体都必须同时携带 `skill_id` 和 `_skill_version`。
9. `_skill_version` 必须填写当前安装版本：`1.1.0`。

编写调用方式脚本

```bash
curl --location 'https://skills.tiantianfunds.com/ai-smart-skill-service/openapi/skill/invoke' \
--header "X-API-Key: $TTFUND_APIKEY" \
--header 'Content-Type: application/json' \
--data '{
  "skill_id": "FUND_CONDITION_SELECT",
  "_skill_version": "1.1.0",
  "pageIndex": 1,
  "pageNum": 20,
  "rsfType": "002",
  "rsbType": "002001",
  "establishPeriod": "2",
  "fundLevel": "4,5",
  "riskLevel": "3,4",
  "orderField": "5_1_-1",
  "abnormal": "3",
  "isBuy": "1",
  "filterAC": "1",
  "pageType": 1,
  "stageSyl": "1_0-20",
  "fundSize": "2,3",
  "fundCompany": "80000229,80041198",
  "isNew": "0",
  "isDk": "0",
  "kfType": "1,2",
  "purchaseRate": "2",
  "managementRate": "1",
  "redemptionRate": "2",
  "otherType": "031",
  "annualStageSyl": "6_0_30",
  "byYearSyl": "2024_0_50",
  "hisProfitProbability": "2_50_100",
  "stageExcessIndex": "6_0_30",
  "stageExcessSyl": "6_0_30",
  "buYearExcessSyl": "2024_0_30",
  "stageRanking": "6_0_20",
  "annualStageRanking": "6_0_20",
  "byYearRanking": "2024_0_20",
  "quarterAvgRanking": "6_0_20",
  "yearAvgRanking": "7_0_20",
  "stageMaxReturn": "6_0_20",
  "stageMaxReturnRanking": "6_0_20",
  "byYearMaxReturn": "2024_0_20",
  "byYearMaxReturnRanking": "2024_0_20",
  "annualizedVolatility": "6_0_20",
  "annualizedVolatilityRanking": "6_0_20",
  "sharpRanking": "6_0_20",
  "cmRanking": "6_0_20",
  "infoRatioRanking": "6_0_20",
  "netValueRepairDays": "6_0_20",
  "trackError": "6_0_20",
  "monthWinRate": "6_50_100",
  "quarterWinRate": "6_50_100",
  "monthExcessWinRate": "6_50_100",
  "quarterExcessWinRate": "6_50_100",
  "stockConcern": "2,3,4",
  "stockStyle": "1,2,3",
  "turnoverRate": "2,3",
  "holdRatio": "1,2",
  "selfPurchase": "2,3",
  "stockPct": "50_100",
  "holdIndustry": "029008",
  "holdIndustryRatio": "029008_0-50",
  "unHoldIndustry": "029017",
  "forHkStock": "1",
  "goldBullReward": "1",
  "manageSize": "50",
  "workPeriod": "5",
  "manageFundPeriod": "3",
  "paybackSyl": "3_10",
  "openDay": "1",
  "closePeriod": "2",
  "isNewFund": "0",
  "instituteHeavy": "50_100",
  "isSale": "1",
  "isDt": "1",
  "isLimitBuy": "0",
  "limitAmount": "100000",
  "discount": "1",
  "mainField": "SYL_Y",
  "secondField": "SYLRANK_Y",
  "orderLimitField": "SYL_Y",
  "orderLimitFieldSort": 0,
  "orderLimitNum": 100,
  "thYwx": "1",
  "currYjn": "2",
  "followIndex": "000300",
  "thamRank": "0-10",
  "lhStrategy": "1",
  "shfType": "1,2",
  "listType": "2",
  "redemptionFreeRate": "1",
  "tagFeavalue": "0015001",
  "drawcfmdata": "0-1,2-3",
  "minPurchaseAmount": "1",
  "maxReturnYearRank": "1_min-5",
  "isSYLPosition3": "1",
  "isSYLPosition5": "1",
  "rankSy": "1",
  "rankDt": "1",
  "showFavor": 1,
  "fcode": "000001,000006",
  "bkcodes": "000001"
}'
```

如果当前底层接口未强制校验 apikey，也必须先检查并要求配置 `TTFUND_APIKEY`，不可省略该步骤。

## 请求参数说明

以下表格说明统一网关接收的请求字段；`fixed` 表示系统自动注入，`context` 表示平台上下文注入。

| 请求字段 | 下游字段 | 来源 | 类型 | 必填 | 说明 | 示例/默认值 |
|----|----|----|----|----|----|----|
| `pageIndex` | `pageIndex` | `query` | `integer` | 否 | 页码 | `1` |
| `pageNum` | `pageNum` | `query` | `integer` | 否 | 每页记录数 | `20` |
| `orderField` | `orderField` | `query` | `string` | 否 | 排序字段，格式为 字段类型_时间维度_排序类型；例如 5_6_-1 表示按近1年阶段收益率倒序，5_1_-1 表示按日收益率/日涨跌幅倒序 | `5_1_-1` |
| `rsfType` | `rsfType` | `query` | `string` | 否 | 新版基金分类一级，可用于优选条件 | `002` |
| `rsbType` | `rsbType` | `query` | `string` | 否 | 新版基金分类二级，多个值逗号连接；部分分类支持股票仓位或可转债仓位扩展 | `002001` |
| `establishPeriod` | `establishPeriod` | `query` | `string` | 否 | 成立年限筛选，支持枚举或自定义区间 | `2` |
| `fundSize` | `fundSize` | `query` | `string` | 否 | 基金规模筛选，可多选逗号连接 | `2,3` |
| `fundLevel` | `fundLevel` | `query` | `string` | 否 | 基金评级筛选，可多选逗号连接 | `4,5` |
| `fundCompany` | `fundCompany` | `query` | `string` | 否 | 基金公司 id，多个逗号连接 | `80000229,80041198` |
| `riskLevel` | `riskLevel` | `query` | `string` | 否 | 风险等级，多个逗号连接 | `3,4` |
| `isNew` | `isNew` | `query` | `string` | 否 | 是否打新基金，1-是，0-否，已不使用 | `0` |
| `isDk` | `isDk` | `query` | `string` | 否 | 是否定开基金，1-是，0-否，已不使用 | `0` |
| `kfType` | `kfType` | `query` | `string` | 否 | 开放类型，可多选逗号连接 | `1,2` |
| `purchaseRate` | `purchaseRate` | `query` | `string` | 否 | 申购费率区间 | `2` |
| `managementRate` | `managementRate` | `query` | `string` | 否 | 管理费率区间 | `1` |
| `redemptionRate` | `redemptionRate` | `query` | `string` | 否 | 赎回费率区间 | `2` |
| `otherType` | `otherType` | `query` | `string` | 否 | 其他基金类型，多值逗号分隔 | `031` |
| `stageSyl` | `stageSyl` | `query` | `string` | 否 | 阶段收益率筛选，格式 时间维度_最小值-最大值 或 时间维度_最小值_最大值，多个条件逗号连接；例如 1_0-20 表示按日涨跌幅筛选 0%~20% | `1_0-20` |
| `annualStageSyl` | `annualStageSyl` | `query` | `string` | 否 | 年化收益率筛选 | `6_0_30` |
| `byYearSyl` | `byYearSyl` | `query` | `string` | 否 | 逐年收益率筛选 | `2024_0_50` |
| `hisProfitProbability` | `hisProfitProbability` | `query` | `string` | 否 | 历史盈利概率筛选 | `2_50_100` |
| `stageExcessIndex` | `stageExcessIndex` | `query` | `string` | 否 | 指数增强回报筛选 | `6_0_30` |
| `stageExcessSyl` | `stageExcessSyl` | `query` | `string` | 否 | 阶段超额收益率筛选 | `6_0_30` |
| `buYearExcessSyl` | `buYearExcessSyl` | `query` | `string` | 否 | 逐年超额收益率筛选 | `2024_0_30` |
| `stageRanking` | `stageRanking` | `query` | `string` | 否 | 阶段同类排名百分比筛选 | `6_0_20` |
| `annualStageRanking` | `annualStageRanking` | `query` | `string` | 否 | 年化阶段同类排名百分比筛选 | `6_0_20` |
| `byYearRanking` | `byYearRanking` | `query` | `string` | 否 | 逐年同类排名百分比筛选 | `2024_0_20` |
| `quarterAvgRanking` | `quarterAvgRanking` | `query` | `string` | 否 | 季度平均同类排名百分比筛选 | `6_0_20` |
| `yearAvgRanking` | `yearAvgRanking` | `query` | `string` | 否 | 年度平均同类排名百分比筛选 | `7_0_20` |
| `stageMaxReturn` | `stageMaxReturn` | `query` | `string` | 否 | 阶段最大回撤筛选 | `6_0_20` |
| `stageMaxReturnRanking` | `stageMaxReturnRanking` | `query` | `string` | 否 | 阶段最大回撤同类排名百分比筛选 | `6_0_20` |
| `byYearMaxReturn` | `byYearMaxReturn` | `query` | `string` | 否 | 逐年最大回撤筛选 | `2024_0_20` |
| `byYearMaxReturnRanking` | `byYearMaxReturnRanking` | `query` | `string` | 否 | 逐年最大回撤同类排名百分比筛选 | `2024_0_20` |
| `annualizedVolatility` | `annualizedVolatility` | `query` | `string` | 否 | 年化波动率筛选 | `6_0_20` |
| `annualizedVolatilityRanking` | `annualizedVolatilityRanking` | `query` | `string` | 否 | 年化波动率同类排名百分比筛选 | `6_0_20` |
| `sharpRanking` | `sharpRanking` | `query` | `string` | 否 | 夏普比率同类排名百分比筛选 | `6_0_20` |
| `cmRanking` | `cmRanking` | `query` | `string` | 否 | 卡玛比率同类排名百分比筛选 | `6_0_20` |
| `infoRatioRanking` | `infoRatioRanking` | `query` | `string` | 否 | 信息比率同类排名百分比筛选 | `6_0_20` |
| `netValueRepairDays` | `netValueRepairDays` | `query` | `string` | 否 | 最长解套天数筛选 | `6_0_20` |
| `trackError` | `trackError` | `query` | `string` | 否 | 跟踪误差筛选 | `6_0_20` |
| `monthWinRate` | `monthWinRate` | `query` | `string` | 否 | 月度胜率筛选 | `6_50_100` |
| `quarterWinRate` | `quarterWinRate` | `query` | `string` | 否 | 季度胜率筛选 | `6_50_100` |
| `monthExcessWinRate` | `monthExcessWinRate` | `query` | `string` | 否 | 月度超额收益胜率筛选 | `6_50_100` |
| `quarterExcessWinRate` | `quarterExcessWinRate` | `query` | `string` | 否 | 季度超额收益胜率筛选 | `6_50_100` |
| `stockConcern` | `stockConcern` | `query` | `string` | 否 | 重仓股集中度，可多选逗号连接 | `2,3,4` |
| `stockStyle` | `stockStyle` | `query` | `string` | 否 | 持股风格，多个条件逗号连接 | `1,2,3` |
| `turnoverRate` | `turnoverRate` | `query` | `string` | 否 | 换手率，可多选逗号连接 | `2,3` |
| `holdRatio` | `holdRatio` | `query` | `string` | 否 | 单一持有人占比，可多选逗号连接 | `1,2` |
| `selfPurchase` | `selfPurchase` | `query` | `string` | 否 | 基金公司自购区间，可多选逗号连接 | `2,3` |
| `stockPct` | `stockPct` | `query` | `string` | 否 | 股票资产占比区间 | `50_100` |
| `holdIndustry` | `holdIndustry` | `query` | `string` | 否 | 持有以下行业，多个申万一级行业 id 逗号连接，已不使用 | `029008` |
| `holdIndustryRatio` | `holdIndustryRatio` | `query` | `string` | 否 | 行业持仓占比筛选 | `029008_0-50` |
| `unHoldIndustry` | `unHoldIndustry` | `query` | `string` | 否 | 不持有以下行业，多个申万一级行业 id 逗号连接 | `029017` |
| `forHkStock` | `forHkStock` | `query` | `string` | 否 | 可投港股，1-是，2-否 | `1` |
| `goldBullReward` | `goldBullReward` | `query` | `string` | 否 | 金牛奖，1-是，2-否 | `1` |
| `manageSize` | `manageSize` | `query` | `string` | 否 | 非货管理规模，支持单值或区间 | `50` |
| `workPeriod` | `workPeriod` | `query` | `string` | 否 | 从业年限，支持单值或区间 | `5` |
| `manageFundPeriod` | `manageFundPeriod` | `query` | `string` | 否 | 管理该基金时长 | `3` |
| `paybackSyl` | `paybackSyl` | `query` | `string` | 否 | 基金经理年化回报率区间 | `3_10` |
| `openDay` | `openDay` | `query` | `string` | 否 | 开放日，1当月，2下月，3下下月 | `1` |
| `closePeriod` | `closePeriod` | `query` | `string` | 否 | 封闭期，1 <=3月，2 3-6月，3 6-12月，4 >12月 | `2` |
| `isNewFund` | `isNewFund` | `query` | `string` | 否 | 新发基金，1-是，0-否 | `0` |
| `instituteHeavy` | `instituteHeavy` | `query` | `string` | 否 | 机构重仓区间 | `50_100` |
| `isSale` | `isSale` | `query` | `string` | 否 | 是否代销基金，1-是，0-否 | `1` |
| `isBuy` | `isBuy` | `query` | `string` | 否 | 是否可购，1-是，0-否 | `1` |
| `isDt` | `isDt` | `query` | `string` | 否 | 是否定投，1-是，2-否 | `1` |
| `isLimitBuy` | `isLimitBuy` | `query` | `string` | 否 | 是否限购，1-是，0-否，已不使用 | `0` |
| `limitAmount` | `limitAmount` | `query` | `string` | 否 | 限购金额 | `100000` |
| `abnormal` | `abnormal` | `query` | `string` | 否 | 是否排除异常值，1-是，2-否，3-智能排除 | `3` |
| `discount` | `discount` | `query` | `string` | 否 | 费率折扣，0 表示 0 折，1 表示 1 折 | `1` |
| `mainField` | `mainField` | `query` | `string` | 否 | 大数据榜单主数据字段 | `SYL_Y` |
| `secondField` | `secondField` | `query` | `string` | 否 | 大数据榜单次数据字段 | `SYLRANK_Y` |
| `orderLimitField` | `orderLimitField` | `query` | `string` | 否 | 排名限制字段 | `SYL_Y` |
| `orderLimitFieldSort` | `orderLimitFieldSort` | `query` | `integer` | 否 | 排名限制字段顺序，0 降序，1 升序 | `0` |
| `orderLimitNum` | `orderLimitNum` | `query` | `integer` | 否 | 排名限制数量，默认 100 | `100` |
| `thYwx` | `thYwx` | `query` | `string` | 否 | 连续3年五星，1-是，2-否 | `1` |
| `currYjn` | `currYjn` | `query` | `string` | 否 | 当年获得金牛奖，1-是，2-否 | `2` |
| `followIndex` | `followIndex` | `query` | `string` | 否 | 跟踪的指数代码 | `000300` |
| `thamRank` | `thamRank` | `query` | `string` | 否 | 土豪爱买-近一月购买金额排名 | `0-10` |
| `lhStrategy` | `lhStrategy` | `query` | `string` | 否 | 量化策略，1-是，2-否 | `1` |
| `filterAC` | `filterAC` | `query` | `string` | 否 | 过滤 A/C 类，1-是，2-否，11 只保留 A，12 只保留 C，13 只保留 E | `1` |
| `shfType` | `shfType` | `query` | `string` | 否 | 申赎费区间，可多选逗号连接 | `1,2` |
| `listType` | `listType` | `query` | `string` | 否 | 大数据榜单基金分类 | `2` |
| `redemptionFreeRate` | `redemptionFreeRate` | `query` | `string` | 否 | 免赎回费率，1-7天免赎回，2-30天免赎回 | `1` |
| `tagFeavalue` | `tagFeavalue` | `query` | `string` | 否 | 券种分布，多值逗号分隔 | `0015001` |
| `drawcfmdata` | `drawcfmdata` | `query` | `string` | 否 | 到账日筛选 | `0-1,2-3` |
| `minPurchaseAmount` | `minPurchaseAmount` | `query` | `string` | 否 | 起购金额，对应数据库字段 MINSG | `1` |
| `maxReturnYearRank` | `maxReturnYearRank` | `query` | `string` | 否 | 近1年最大回撤排名筛选 | `1_min-5` |
| `isSYLPosition3` | `isSYLPosition3` | `query` | `string` | 否 | 连续3年正收益，1 表示启用 | `1` |
| `isSYLPosition5` | `isSYLPosition5` | `query` | `string` | 否 | 连续5年正收益，1 表示启用 | `1` |
| `rankSy` | `rankSy` | `query` | `string` | 否 | 是否需要外透排行收益分类字段，1 需要，0 不需要 | `1` |
| `rankDt` | `rankDt` | `query` | `string` | 否 | 是否需要外透排行定投分类字段，1 需要，0 不需要 | `1` |
| `showFavor` | `showFavor` | `query` | `integer` | 否 | 展示自选 code，1 展示 | `1` |
| `pageType` | `pageType` | `query` | `integer` | 否 | 接口应用页面，1 选基结果页，2 排行页，3 条件详情页，4 主题选基，5 wap 排行和净值页 | `1` |
| `fcode` | `fcode` | `query` | `string` | 否 | 手动选基传入的基金代码，多个逗号分隔 | `000001,000006` |
| `bkcodes` | `bkcodes` | `query` | `string` | 否 | 所属主题，多个逗号分隔 | `000001` |
| `fields` | `fields` | `fixed` | `string` | 是 | 固定返回字段列表，实际请求会自动编码为 %2C 分隔；系统自动注入 | `SYL_Y,SYLRANK_Y,SYLFNUM_Y,SYL_SY,SYLRANK_SY,SYLFNUM_SY` |

## 问句示例

| 类型 | query |
|----|----|
| 查询 天天条件选基skill | 帮我调用 FUND_CONDITION_SELECT |
| 按示例参数调用 | 使用 FUND_CONDITION_SELECT，参数参考请求示例 |
| 查询结果解释 | 帮我读取 FUND_CONDITION_SELECT 的返回结果并解释关键字段 |

## 接口结果释义

### 一、业务结果根节点 (`data.raw_result.body`)

以下字段位于统一网关返回中的 `data.raw_result.body`，是实际业务结果的根节点。

| 字段路径 | 类型 | 核心释义 |
|----|----|----|
| `Data` | array | 接口返回字段 |
| `ErrCode` | integer | 接口返回字段 |
| `Expansion` | object | 接口返回字段 |
| `Message` | string | 接口返回字段 |
| `Succeed` | boolean | 接口返回字段 |
| `TotalCount` | integer | 接口返回字段 |

### 二、核心字段说明

以下字段说明均面向 `data.raw_result.body`，不展开服务端内部编排、上下游映射和调试字段。

| 字段 Key | 含义说明 |
| --- | --- |
| `Succeed` | 接口是否成功；true 表示接口调用成功 |
| `ErrCode` | 错误码；0 表示成功，非 0 表示失败 |
| `Message` | 接口提示信息；成功时通常返回 success |
| `TotalCount` | 符合条件的基金总数；用于判断筛选结果规模 |
| `Expansion` | 扩展信息对象；当接口返回附加上下文时可从此读取 |
| `Data.fundCode` | 基金代码列表；用于标识筛选出的基金 |
| `Data.fundName` | 基金名称列表；用于展示基金名称 |
| `Data.company` | 基金公司列表；用于展示基金管理人 |
| `Data.fundtype` | 基金类型列表；用于识别基金所属类型 |
| `Data.rsbType` | 新基金分类-基金类型列表；用于识别新版二级分类 |
| `Data.establishDate` | 成立日期列表；用于判断基金成立时长 |
| `Data.fundSize` | 基金规模列表；用于评估基金管理规模 |
| `Data.fundLevel` | 基金评级列表；用于评估基金评级 |
| `Data.fundLevelCX` | 晨星评级列表；用于补充晨星维度评级信息 |
| `Data.riskLevel` | 风险等级列表；用于判断基金风险等级 |
| `Data.feature` | 基金属性列表；用于识别基金属性标签 |
| `Data.perNav` | 单位净值列表；用于查看基金当前单位净值 |
| `Data.jzrq` | 净值日期列表；用于确认净值对应日期 |
| `Data.gsZzl` | 估值涨跌幅列表；用于查看最新估值变化 |
| `Data.gsztime` | 估值时间列表；用于确认估值时间 |
| `Data.daySyl` | 单日收益率列表；用于评估日度表现 |
| `Data.weekSyl` | 近1周收益率列表；用于评估短期表现 |
| `Data.monthSyl` | 近1月收益率列表；用于评估近月表现 |
| `Data.sySyl` | 今年以来收益率列表；对应固定返回字段中的 SYL_SY |
| `Data.yearSyl` | 近1年收益率列表；对应固定返回字段中的 SYL_Y |
| `Data.twySyl` | 近2年收益率列表；用于评估中长期表现 |
| `Data.trySyl` | 近3年收益率列表；用于评估中长期表现 |
| `Data.fySyl` | 近5年收益率列表；用于评估长期表现 |
| `Data.lnSyl` | 成立以来收益率列表；用于评估成立以来累计收益 |
| `Data.sylRank_sy` | 今年以来收益率排名列表；对应固定返回字段中的 SYLRANK_SY |
| `Data.sylNum_sy` | 今年以来收益率样本总数列表；对应固定返回字段中的 SYLFNUM_SY |
| `Data.sylRank_y` | 近1年收益率排名列表；对应固定返回字段中的 SYLRANK_Y |
| `Data.sylNum_y` | 近1年收益率样本总数列表；对应固定返回字段中的 SYLFNUM_Y |
| `Data.yearReturn` | 近1年最大回撤列表；用于评估近1年回撤风险 |
| `Data.twyReturn` | 近2年最大回撤列表；用于评估近2年回撤风险 |
| `Data.tryReturn` | 近3年最大回撤列表；用于评估近3年回撤风险 |
| `Data.fyReturn` | 近5年最大回撤列表；用于评估近5年回撤风险 |
| `Data.syReturn` | 今年以来最大回撤列表；用于评估今年以来回撤风险 |
| `Data.yearVolatility` | 近1年年化波动率列表；用于评估近1年波动水平 |
| `Data.twyVolatility` | 近2年年化波动率列表；用于评估近2年波动水平 |
| `Data.tryVolatility` | 近3年年化波动率列表；用于评估近3年波动水平 |
| `Data.fyVolatility` | 近5年年化波动率列表；用于评估近5年波动水平 |
| `Data.yearSharp` | 近1年夏普比率列表；用于评估近1年风险收益比 |
| `Data.twySharp` | 近2年夏普比率列表；用于评估近2年风险收益比 |
| `Data.trySharp` | 近3年夏普比率列表；用于评估近3年风险收益比 |
| `Data.fySharp` | 近5年夏普比率列表；用于评估近5年风险收益比 |
| `Data.ptdtY` | 普通定投近1年收益列表；用于评估普通定投效果 |
| `Data.ptdtTWY` | 普通定投近2年收益列表；用于评估普通定投效果 |
| `Data.ptdtTRY` | 普通定投近3年收益列表；用于评估普通定投效果 |
| `Data.ptdtFY` | 普通定投近5年收益列表；用于评估普通定投效果 |
| `Data.bestDtY` | 智能定投近1年收益列表；用于评估智能定投效果 |
| `Data.bestDtTWY` | 智能定投近2年收益列表；用于评估智能定投效果 |
| `Data.bestDtTRY` | 智能定投近3年收益列表；用于评估智能定投效果 |
| `Data.bestDtFY` | 智能定投近5年收益列表；用于评估智能定投效果 |
| `Data.mbdtY` | 目标止盈定投近1年收益列表；用于评估目标止盈定投效果 |
| `Data.mbdtTWY` | 目标止盈定投近2年收益列表；用于评估目标止盈定投效果 |
| `Data.mbdtTRY` | 目标止盈定投近3年收益列表；用于评估目标止盈定投效果 |
| `Data.mbdtFY` | 目标止盈定投近5年收益列表；用于评估目标止盈定投效果 |
| `Data.yddtY` | 移动止盈定投近1年收益列表；用于评估移动止盈定投效果 |
| `Data.yddtTWY` | 移动止盈定投近2年收益列表；用于评估移动止盈定投效果 |
| `Data.yddtTRY` | 移动止盈定投近3年收益列表；用于评估移动止盈定投效果 |
| `Data.yddtFY` | 移动止盈定投近5年收益列表；用于评估移动止盈定投效果 |
| `Data.dwdtY` | 低位多投定投近1年收益列表；用于评估低位多投效果 |
| `Data.dwdtTWY` | 低位多投定投近2年收益列表；用于评估低位多投效果 |
| `Data.dwdtTRY` | 低位多投定投近3年收益列表；用于评估低位多投效果 |
| `Data.dwdtFY` | 低位多投定投近5年收益列表；用于评估低位多投效果 |
| `Data.dtzt` | 定投状态列表；1 表示支持定投，0 表示不支持定投 |
| `Data.isBuy` | 是否可购列表；用于判断基金当前是否可购买 |
| `Data.isSales` | 是否代销列表；用于判断平台是否代销该基金 |
| `Data.ipestart1` | 申购起始日列表；用于判断申购开放开始时间 |
| `Data.ipeend1` | 申购截止日列表；用于判断申购开放截止时间 |
| `Data.ncycle` | 封闭天数列表；用于识别封闭运作时长 |
| `Data.accPerNav` | 7日年化收益率列表；货币类基金可用于查看7日年化 |
| `Data.ftyi` | 14日年化收益率列表；用于查看14日年化表现 |
| `Data.teyi` | 28日年化收益率列表；用于查看28日年化表现 |
| `Data.tfyi` | 35日年化收益率列表；用于查看35日年化表现 |
| `Data.mainData` | 大数据榜单主数据列表；用于展示榜单主指标 |
| `Data.secondData` | 大数据榜单次数据列表；用于展示榜单次指标 |
| `Data.orderLimitData` | 排名限制数据列表；用于展示参与排名限制的值 |
| `Data.listType` | 大数据榜单基金分类列表；用于区分榜单基金分类 |
| `Data.abnormaltags` | 异常收益标签列表；用于标记巨额赎回等异常收益展示区间 |
| `Data.ylzt` | 养老类型列表；1 表示养老类型，0 或 null 表示非养老类型 |
| `Data.info` | 基金详情字段列表；包含基金详情扩展信息对象 |

## 交互规范

1. 优先检查环境变量 `TTFUND_APIKEY`。
2. 若环境变量存在，则直接继续调用接口。
3. 若环境变量不存在，必须中断当前调用，并强制提示用户先完成 apikey 配置。
4. 引导文案必须明确包含：
   - 环境变量名：`TTFUND_APIKEY`
   - apikey 获取路径：`天天基金搜索 skills`
5. 每次请求都必须带上 `skill_id` 和 `_skill_version`。
6. `_skill_version` 固定使用当前安装版本：`1.1.0`。
7. 若缺少必填参数，应提示用户补充 `页面筛选条件或排序字段`。
8. 返回结果时，应优先提炼核心信息，而不是直接原样堆砌所有字段。
9. 结果解释顺序必须是：先看业务结果，再看 `version_info`，最后决定是否追加升级建议。

## 输出建议

返回时优先展示：
- `Succeed`
- `ErrCode`
- `Message`
- `TotalCount`
- `Expansion`
- `Data.fundCode`
- `Data.fundName`
- `Data.company`

如需结构化输出，建议包含两部分：

- `business_result`：对应 `data.raw_result.body` 的核心业务结果
- `explanation_document`：对关键字段和结果差异的说明

说明：统一网关还可能返回少量辅助信息，用于调试、排错或版本提示；用户文档默认不展开这些字段，请以 `data.raw_result.body` 为准。

后处理要求：

- 若 `data.version_info.is_outdated = true`，先完成本次结果回答，再附上一句简洁升级提醒。
- 若接口返回升级导向错误，不要重复盲重试，也不要误判为普通网络问题，应直接提示用户升级 skill。
- 若接口返回普通业务错误且没有版本归因信号，则按原有逻辑处理，不额外渲染升级提示。

## 错误处理

- 若缺少 apikey，应提示用户：
  - `当前未检测到 TTFUND_APIKEY，请先前往天天基金搜索 skills 获取 apikey，并在本机配置该环境变量后重试。`
- 若缺少 `_skill_version`，应提示用户：
  - `当前安装的 skill 可能为旧版本，未携带版本信息。请升级到最新版本 1.1.0 后重试。`
- 若 `_skill_version` 为空或无效，应提示用户：
  - `当前安装的 skill 版本信息无效，可能为旧版本或安装不完整。请升级到最新版本 1.1.0 后重试。`
- 若 HTTP 请求失败、超时或返回非 2xx 状态码，应提示用户：
  - `天天条件选基skill服务暂时不可用，请稍后重试。`
- 若返回 `version_info` 表示本地版本落后，应优先提示用户尽快升级 skill。
- 若版本落后且本次错误属于参数缺失、字段不兼容或调用协议不匹配，应优先提示用户先升级 skill 再重试。
- 若业务成功字段 `ErrCode` 校验失败，则视为业务失败：
  - 简要说明错误信息
  - 不自行猜测结果或伪造成功
- 若核心返回数据为空，应提示用户检查输入参数是否正确。

## 安全与边界

- 该 Skill 返回的是 `天天条件选基skill` 对应的业务数据，请按业务场景谨慎使用。
- 返回内容仅用于当前用户请求的查询与分析，不应伪造结果或输出未验证内容。


### 4. 基金持仓查询 详细说明

---

请为我安装如下skill

## name:

基金持仓查询

## version:

1.0.0

## description:

本 Skill 基于**fund**构建，支持通过**自然语言**实现以下功能：
- 调用 `FUND_HOLDING_INFO` 对应的核心能力
- 当前发布版本为 `1.0.0`，调用时必须携带 `_skill_version`
- 支持输入基金代码或基金名称查询基金持仓。若输入为基金名称，则先通过搜索接口解析 fund_code，再并行查询十大持仓、资产配置、行业配置与 AI 持仓摘要，最终聚合返回基金基础信息、持仓概览、股票/债券/FOF 持仓明细、资产配置原始结果、行业配置原始结果、AI 摘要、名称解析候选与风险提示，供上层按需求文档进一步生成仓位变化、行业集中度和自然语言解读。
- 输出适合阅读和进一步分析的结构化结果

---

# 基金持仓查询

通过**自然语言**或结构化参数调用 `FUND_HOLDING_INFO` 对应能力，接口返回 JSON 格式内容。

- 当前 skill 版本：`1.0.0`

## 使用方式

1. 在调用任何接口前，必须先检查本地环境变量 `TTFUND_APIKEY` 是否存在。
2. 若本地已存在 `TTFUND_APIKEY`，则直接使用该 apikey 发起请求。
3. 若本地不存在 `TTFUND_APIKEY`，必须强制引导用户先配置 apikey，不得跳过。
4. apikey 获取路径：
   - 打开 **天天基金**
   - 搜索 **skills**
   - 在对应 Skills 页面获取 `基金持仓查询` 对应的 apikey
5. 当检测到 apikey 缺失时，必须明确提示用户：
   - `当前未检测到本地环境变量 TTFUND_APIKEY，请先前往天天基金搜索 skills 获取 apikey，并在本机配置环境变量后再继续使用。`
6. 在用户未完成 apikey 配置前，不继续执行 skill 查询请求。
7. 配置完成后，使用 **POST** 请求调用统一网关接口，并将 apikey 放入 `X-API-Key` 请求头中。
8. 每次请求体都必须同时携带 `skill_id` 和 `_skill_version`。
9. `_skill_version` 必须填写当前安装版本：`1.0.0`。

编写调用方式脚本

```bash
curl --location 'https://skills.tiantianfunds.com/ai-smart-skill-service/openapi/skill/invoke' \
--header "X-API-Key: $TTFUND_APIKEY" \
--header 'Content-Type: application/json' \
--data '{
  "skill_id": "FUND_HOLDING_INFO",
  "_skill_version": "1.0.0",
  "fund_id": "025209",
  "holding_type": "all"
}'
```

如果当前底层接口未强制校验 apikey，也必须先检查并要求配置 `TTFUND_APIKEY`，不可省略该步骤。

## 编排流程

该 skill 使用服务端 workflow 自动完成名称解析、数据获取与结果聚合，对调用方透明。

- 若已提供 `fcode`，服务端优先直查；缺少时可根据 `fund_id` 自动解析候选代码。
- 服务端会自动执行内部步骤并完成聚合；当前配置共包含 `4` 个业务步骤。
- 文档中的返回字段说明仅面向最终业务结果 `data.raw_result.body`，不展开内部字段映射关系。
## 请求参数说明

以下表格说明统一网关接收的对外请求字段；若 skill 配置了 workflow，系统会在内部自动完成名称解析、代码回填和最终详情接口调用。

| 请求字段 | 类型 | 必填 | 说明 | 示例 |
|----|----|----|----|----|
| `fund_id` | `string` | 是 | 基金代码（6位）或基金名称；当前 workflow 会优先通过搜索接口解析为 fund_code；至少传一个 | `025209` |
| `report_period` | `string` | 否 | 报告期，格式 YYYY-QN，如 2024-Q3；当前底层五个接口默认返回最新已披露一期，此字段供上层结果校验与提示使用 | `2024-Q3` |
| `holding_type` | `string` | 否 | 持仓类型：stock（股票）/ bond（债券）/ all（全部），默认 all | `all` |

## 问句示例

| 类型 | query |
|----|----|
| 查询 基金持仓查询 | 帮我调用 FUND_HOLDING_INFO |
| 按示例参数调用 | 使用 FUND_HOLDING_INFO，参数参考请求示例 |
| 查询结果解释 | 帮我读取 FUND_HOLDING_INFO 的返回结果并解释关键字段 |

## 接口结果释义

### 一、业务结果根节点 (`data.raw_result.body`)

以下字段位于统一网关返回中的 `data.raw_result.body`，是实际业务结果的根节点。

| 字段路径 | 类型 | 核心释义 |
|----|----|----|
| `success` | boolean | 接口是否成功，true = 成功 |
| `errorCode` | integer | 接口全局错误码，0 = 成功 |
| `data` | object | 核心业务数据 |

### 二、核心字段说明

以下字段说明均面向 `data.raw_result.body`，不展开服务端内部编排、上下游映射和调试字段。

| 字段 Key | 含义说明 |
| --- | --- |
| `success` | 接口是否成功；true 表示 workflow 聚合成功 |
| `errorCode` | 业务错误码；0 表示成功，非 0 表示失败 |
| `data.fund_profile` | 基金基础信息与本次输入信息 |
| `data.fund_profile.input_fund_id` | 原始输入的基金代码或基金名称 |
| `data.fund_profile.fund_code` | 解析后的基金代码 |
| `data.fund_profile.fund_name` | 解析后的基金名称 |
| `data.fund_profile.fund_type` | 搜索结果返回的基金类型；用于辅助判断股票型、债券型、FOF 等差异化处理 |
| `data.request_context.report_period` | 请求中的报告期；当前默认 latest_disclosed，表示读取最新已披露一期 |
| `data.request_context.holding_type` | 请求中的持仓类型过滤；stock / bond / all |
| `data.holding_overview.report_date` | 持仓报告截止日期；当前来源于 FundInverstPosition 的 expansion |
| `data.holding_overview.top10_ratio_components` | 前十大持仓占净值比原始列表；上层可求和得到 top10_ratio |
| `data.holding_overview.data_lag_notice` | 数据滞后说明 |
| `data.top_holdings.stock` | 股票重仓持仓列表，来源于 FundInverstPosition.data.fundStocks |
| `data.top_holdings.stock.GPJC` | 股票持仓名称列表 |
| `data.top_holdings.stock.GPDM` | 股票持仓代码列表 |
| `data.top_holdings.stock.JZBL` | 股票持仓占净值比例列表；单位通常为百分比 |
| `data.top_holdings.stock.PCTNVCHGTYPE` | 股票持仓变化类型列表；常见值包括 新增、增持、减持、不变 |
| `data.top_holdings.stock.PCTNVCHG` | 股票持仓较上期变化幅度列表；建议与 PCTNVCHGTYPE 组合使用，渲染为加仓/减仓/新进说明 |
| `data.top_holdings.stock.INDEXCODE` | 股票持仓所属行业代码列表 |
| `data.top_holdings.stock.INDEXNAME` | 股票持仓所属行业名称列表 |
| `data.top_holdings.stock.HOLDCOUNT` | 股票持仓进入重仓列表的期数或统计次数原始字段；具体业务含义需以上游字段定义为准 |
| `data.top_holdings.bond` | 债券重仓持仓列表，来源于 FundInverstPosition.data.fundboods |
| `data.top_holdings.fof` | FOF 底层基金持仓列表，来源于 FundInverstPosition.data.fundfofs |
| `data.top_holdings.etf_code` | 若为 ETF 联接基金，对应 ETF 基金代码 |
| `data.top_holdings.etf_shortname` | 若为 ETF 联接基金，对应 ETF 基金简称 |
| `data.top_holdings.raw` | 十大持仓接口原始结果聚合对象；保留股票、债券、FOF 和 ETF 联接相关原始字段，便于上层做兼容读取和补充解释 |
| `data.asset_allocation.raw` | 资产配置接口原始结果；当前样例未展开字段结构，上层需按真实返回做股票仓位与仓位变化计算 |
| `data.asset_allocation.total_count` | 资产配置接口返回记录数 |
| `data.industry_allocation.raw` | 行业配置接口原始结果；当前样例未展开字段结构，上层需按真实返回做前 8 大行业、权重变化和 top_holding 计算 |
| `data.industry_allocation.total_count` | 行业配置接口返回记录数 |
| `data.ai_summary.report_date` | AI 持仓摘要对应报告日期 |
| `data.ai_summary.fund_code` | AI 摘要对应基金代码 |
| `data.ai_summary.text` | AI 持仓摘要文本；可直接作为 D 模块底稿 |
| `data.ai_summary.raw` | AI 持仓摘要接口原始结果；保留 fundCode、text_summary、date 等原始字段，便于上层兼容读取和追溯 |
| `data.disambiguation_candidates` | 名称歧义时的候选基金列表，供上层引导用户选择 |
| `data.resolution_selected` | 当前 resolver 自动选中的基金候选，仅供参考 |
| `data.risk_disclaimer` | 风险提示语 |

## 交互规范

1. 优先检查环境变量 `TTFUND_APIKEY`。
2. 若环境变量存在，则直接继续调用接口。
3. 若环境变量不存在，必须中断当前调用，并强制提示用户先完成 apikey 配置。
4. 引导文案必须明确包含：
   - 环境变量名：`TTFUND_APIKEY`
   - apikey 获取路径：`天天基金搜索 skills`
5. 每次请求都必须带上 `skill_id` 和 `_skill_version`。
6. `_skill_version` 固定使用当前安装版本：`1.0.0`。
7. 若缺少必填参数，应提示用户补充 `fund_id`。
8. 返回结果时，应优先提炼核心信息，而不是直接原样堆砌所有字段。
9. 结果解释顺序必须是：先看业务结果，再看 `version_info`，最后决定是否追加升级建议。

## 输出建议

返回时优先展示：
- `success`
- `errorCode`
- `data.fund_profile`
- `data.fund_profile.input_fund_id`
- `data.fund_profile.fund_code`
- `data.fund_profile.fund_name`
- `data.fund_profile.fund_type`
- `data.request_context.report_period`

如需结构化输出，建议包含两部分：

- `business_result`：对应 `data.raw_result.body` 的核心业务结果
- `explanation_document`：对关键字段和结果差异的说明

说明：统一网关还可能返回少量辅助信息，用于调试、排错或版本提示；用户文档默认不展开这些字段，请以 `data.raw_result.body` 为准。

后处理要求：

- 若 `data.version_info.is_outdated = true`，先完成本次结果回答，再附上一句简洁升级提醒。
- 若接口返回升级导向错误，不要重复盲重试，也不要误判为普通网络问题，应直接提示用户升级 skill。
- 若接口返回普通业务错误且没有版本归因信号，则按原有逻辑处理，不额外渲染升级提示。

## 错误处理

- 若缺少 apikey，应提示用户：
  - `当前未检测到 TTFUND_APIKEY，请先前往天天基金搜索 skills 获取 apikey，并在本机配置该环境变量后重试。`
- 若缺少 `_skill_version`，应提示用户：
  - `当前安装的 skill 可能为旧版本，未携带版本信息。请升级到最新版本 1.0.0 后重试。`
- 若 `_skill_version` 为空或无效，应提示用户：
  - `当前安装的 skill 版本信息无效，可能为旧版本或安装不完整。请升级到最新版本 1.0.0 后重试。`
- 若 HTTP 请求失败、超时或返回非 2xx 状态码，应提示用户：
  - `基金持仓查询服务暂时不可用，请稍后重试。`
- 若返回 `version_info` 表示本地版本落后，应优先提示用户尽快升级 skill。
- 若版本落后且本次错误属于参数缺失、字段不兼容或调用协议不匹配，应优先提示用户先升级 skill 再重试。
- 若业务成功字段 `success` 校验失败，则视为业务失败：
  - 简要说明错误信息
  - 不自行猜测结果或伪造成功
- 若核心返回数据为空，应提示用户检查输入参数是否正确。

## 安全与边界

- 该 Skill 返回的是 `基金持仓查询` 对应的业务数据，请按业务场景谨慎使用。
- 返回内容仅用于当前用户请求的查询与分析，不应伪造结果或输出未验证内容。


### 5. 天天黄金查询 详细说明

请为我安装如下skill

## name
天天黄金分析skill

## version:
1.0.0

## description:
基于 FUND_HUAAN_GOLD_INFO 的黄金市场快照与十维度分析 skill。
单接口返回黄金行情、宏观财政、风险指标和资讯，并可生成买入/持有/卖出信号与建议。

# 天天黄金分析skill

## 1. 能力定位

本 Skill 用于回答以下问题：

- 今天黄金行情如何（上金所基准价、Au(T+D)、黄金期货主力）？
- 当前宏观环境是否利好黄金（通胀、就业、利率、CFTC、美股）？
- 风险指标怎么走（VIX、USDCNY 中间价、DXY）？
- 最近地缘风险新闻对黄金意味着什么？
- 是否适合买入/持有/减持黄金类资产？

核心数据入口统一为 `FUND_HUAAN_GOLD_INFO`，避免多接口拼装导致口径不一致。

## 2. 标准调用方式

### 2.1 调用前检查

1. 必须先检查环境变量 `TTFUND_APIKEY` 是否存在。
2. 若不存在，先提示用户配置，不继续调用。
3. 若存在，使用统一网关调用 skill。

缺少 apikey 时提示：

`当前未检测到 TTFUND_APIKEY，请先前往天天基金搜索 skills 获取 apikey，并在本机配置环境变量后再试。`

### 2.2 请求示例

```bash
curl --location 'https://skills.tiantianfunds.com/ai-smart-skill-service/openapi/skill/invoke' \
--header "X-API-Key: $TTFUND_APIKEY" \
--header 'Content-Type: application/json' \
--data '{
  "skill_id": "FUND_HUAAN_GOLD_INFO",
  "_skill_version": "1.0.0",
  "query_scope": "all"
}'
```

### 2.3 请求参数

| 参数 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| `skill_id` | string | 是 | 固定：`FUND_HUAAN_GOLD_INFO` |
| `_skill_version` | string | 否 | 建议固定：`1.0.0` |
| `query_scope` | string | 否 | `gold / macro / risk / news / all`，默认 `all` |

备注：当前 `query_scope` 主要用于上层展示裁剪，不改变底层单接口调用事实。

## 3. 响应读取规则

统一网关外层：

- `code == 0` 表示网关调用成功
- 业务主体在 `data.raw_result.body`

业务主体关键字段：

- `success`：业务成功标记（期望 `true`）
- `errorCode`：业务码（期望 `200`）
- `data`：黄金分析结构化快照

推荐读取路径：

`response.data.raw_result.body.data`

## 4. 数据模块说明（AI 消费视角）

### A. `gold_quotes`（黄金行情主模块）

- `sge_benchmark`: 上金所黄金基准价（早盘/晚盘）
- `au9999` / `au_td`: 上金所现货/延期
- `gold_futures_shfe`: 上期所黄金主力
- `central_bank_gold`: 中国央行黄金储备（月频）

### B. `macro_fiscal`

- `items`: 全量宏观与市场指标数组
- 常用快读字段：`cpi_yoy`、`treasury_yields`、`cftc_holding`、`dow/sp500/nasdaq`

### C. `risk_indicators`

- `items`: 全量风险指标数组
- 常用快读字段：`vix`、`exchprice`（USDCNY 中间价）、`dxy`

### D. `news.items`

- 默认已是精简资讯：`newsid/title/summary/source/publish_time/publish_date/url`
- 用于地缘风险和情绪解释，不直接等同于交易指令

## 5. 时效字段解释（必须向用户说清楚）

| 字段 | 含义 |
| --- | --- |
| `date` | 指标业务日期（发布时间/交易日），不等于请求当日 |
| `freshness_days` | 当前日期与指标 `date` 的天数差 |
| `is_stale` | 是否超出该指标可接受时效阈值 |
| `is_backfilled` | 当期缺失时是否使用最近非空值回填 |

规则：

1. 回答时必须先说 `as_of`、`update_time`，再说每个关键指标自己的 `date`。
2. 若 `is_stale=true` 或 `is_backfilled=true`，必须显式提示“该指标为滞后/回填数据”。
3. 禁止把月频指标（如央行储备）描述为“实时”。

## 6. 十维度模型映射（沿用 gold-analyzer 框架）

### 短期交易属性（1-3 个月）

1. 地缘风险（10%）
- 主要看：`news.items`（标题与摘要）

2. 股市波动（10%）
- 主要看：`risk_indicators.vix` + `macro_fiscal.dow/sp500/nasdaq`

3. 期货持仓（10%）
- 主要看：`macro_fiscal.cftc_holding` + `gold_quotes.gold_futures_shfe`

4. 技术面（10%）
- 主要看：`gold_quotes.sge_benchmark`、`au9999`、`au_td`、`gold_futures_shfe`

### 中期金融属性（4-6 个月）

5. 实际利率（15%）
- 主要看：`macro_fiscal.treasury_yields` + `macro_fiscal.cpi_yoy`

6. 通胀（15%）
- 主要看：`cpi_yoy/cpi_mom/core_cpi_mom/core_pce_yoy`

7. 就业（10%）
- 主要看：`unemployment_rate/non_farm/initial_jobless/adp_employment`

### 长期货币属性（6 个月以上）

8. 人民币汇率（8%）
- 主要看：`risk_indicators.exchprice`

9. 美元信用与债务压力代理（6%）
- 主要看：`risk_indicators.dxy` + `macro_fiscal.treasury_yields`
- 说明：当前返回中无直接“美债赤字”字段，采用代理变量解释

10. 央行购金（6%）
- 主要看：`gold_quotes.central_bank_gold`

## 7. 评分与信号

单维度评分：

- 利好黄金：`1`
- 中性：`0.5`
- 利空黄金：`0`

总分区间映射：

- `>= 7`：强烈买入
- `5 - 7`：买入/增持
- `4 - 5`：持有观望
- `3 - 4`：减持/谨慎
- `<= 3`：卖出/规避

输出要求：

1. 可以输出“信号方向”，但不输出伪精确概率。
2. 结论先行，再给四模块证据链（黄金/宏观/风险/资讯）。
3. 若关键指标滞后，结论必须降置信度并提示风险。

## 8. 回答模板（建议）

```text
结论：当前黄金信号为[买入/持有/减持]（强度：[强/中/弱]）。

A. 黄金行情（business_date）
- SGE基准价：早盘 X，晚盘 Y
- Au(T+D)：收盘 X，涨跌 Y%
- 黄金期货主力：收盘 X，涨跌 Y%

B. 宏观与利率
- CPI同比：X%（date=...）
- 美债10Y：X%，中美10Y利差：X%
- CFTC净仓：X（趋势：上升/下降）

C. 风险指标
- VIX：X，DXY：X，USDCNY中间价：X

D. 资讯
- 最近N条重点新闻（标题 + 来源 + 时间）

风险提示：
- 标记了 stale/backfilled 的指标可能存在时滞或回填偏差；
- 本结论不构成投资建议。
```

## 9. 错误处理与降级

1. 若 HTTP 非 200 或 `code != 0`：直接返回 skill 调用失败。
2. 若 `raw_result.body.success != true` 或 `errorCode != 200`：按业务失败处理。
3. 若 `news.items` 为空：继续输出黄金/宏观/风险，并说明“当前暂无最新资讯”。
4. 若部分宏观字段缺失：保留已有字段，不编造，不自动补写未经返回的数据。

## 10. 边界与合规

1. 不把资讯或单一指标描述为确定性买卖依据。
2. 不把 `is_stale=true` 的指标写成“最新实时数据”。
3. 不省略时间信息（`as_of` + 各指标 `date`）。
4. 回答必须包含风险提示语义：

`风险提示：黄金价格、宏观指标、风险指标与新闻信息均来自公开数据或业务网关聚合结果，可能存在时滞、回填或口径差异，不代表未来表现，也不构成投资建议。`

## 11. 典型问句触发

- 今天金价多少？
- 天天黄金现在看什么数据最重要？
- 上海黄金交易所基准价是多少？
- 黄金期货主力今天表现怎么样？
- 最近有哪些黄金相关新闻？
- 现在适合买黄金吗？

### 6. 投顾策略查询 详细说明

---

请为我安装如下skill

## name:

投顾策略查询

## version:

1.0.0

## description:

本 Skill 基于**fund**构建，支持通过**自然语言**实现以下功能：
- 调用 `FUND_TG_STRATEGY_INFO` 对应的核心能力
- 当前发布版本为 `1.0.0`，调用时必须携带 `_skill_version`
- 支持投顾策略代码直查；若仅提供策略名称，则先通过搜索接口解析 strategy_id，再串联查询投顾拓展信息与投顾聚合信息，返回策略基础信息、历史业绩、组合构成、风险指标、服务动态与生成 AI 解读所需原始字段，帮助用户在订阅投顾策略前做出判断。
- 输出适合阅读和进一步分析的结构化结果

---

# 投顾策略查询

通过**自然语言**或结构化参数调用 `FUND_TG_STRATEGY_INFO` 对应能力，接口返回 JSON 格式内容。

- 当前 skill 版本：`1.0.0`

## 使用方式

1. 在调用任何接口前，必须先检查本地环境变量 `TTFUND_APIKEY` 是否存在。
2. 若本地已存在 `TTFUND_APIKEY`，则直接使用该 apikey 发起请求。
3. 若本地不存在 `TTFUND_APIKEY`，必须强制引导用户先配置 apikey，不得跳过。
4. apikey 获取路径：
   - 打开 **天天基金**
   - 搜索 **skills**
   - 在对应 Skills 页面获取 `投顾策略查询` 对应的 apikey
5. 当检测到 apikey 缺失时，必须明确提示用户：
   - `当前未检测到本地环境变量 TTFUND_APIKEY，请先前往天天基金搜索 skills 获取 apikey，并在本机配置环境变量后再继续使用。`
6. 在用户未完成 apikey 配置前，不继续执行 skill 查询请求。
7. 配置完成后，使用 **POST** 请求调用统一网关接口，并将 apikey 放入 `X-API-Key` 请求头中。
8. 每次请求体都必须同时携带 `skill_id` 和 `_skill_version`。
9. `_skill_version` 必须填写当前安装版本：`1.0.0`。

编写调用方式脚本

```bash
curl --location 'https://skills.tiantianfunds.com/ai-smart-skill-service/openapi/skill/invoke' \
--header "X-API-Key: $TTFUND_APIKEY" \
--header 'Content-Type: application/json' \
--data '{
  "skill_id": "FUND_TG_STRATEGY_INFO",
  "_skill_version": "1.0.0",
  "strategy_name": "司南双月宝组合",
  "query_scope": "all"
}'
```

如果当前底层接口未强制校验 apikey，也必须先检查并要求配置 `TTFUND_APIKEY`，不可省略该步骤。

## 编排流程

该 skill 使用服务端 workflow 自动完成名称解析、数据获取与结果聚合，对调用方透明。

- 若已提供 `strategy_id`，服务端优先直查；缺少时可根据 `strategy_name` 自动解析候选代码。
- 服务端会自动执行内部步骤并完成聚合；当前配置共包含 `2` 个业务步骤。
- 文档中的返回字段说明仅面向最终业务结果 `data.raw_result.body`，不展开内部字段映射关系。
## 请求参数说明

以下表格说明统一网关接收的对外请求字段；若 skill 配置了 workflow，系统会在内部自动完成名称解析、代码回填和最终详情接口调用。

| 请求字段 | 类型 | 必填 | 说明 | 示例 |
|----|----|----|----|----|
| `strategy_id` | `string` | 至少传一项 | 策略 ID；优先直查，通常对应投顾代码 TGCODE；与 `strategy_name` 至少传一个 | `PEYCXNH` |
| `strategy_name` | `string` | 至少传一项 | 策略名称；缺少 strategy_id 时用于模糊搜索解析策略代码；与 `strategy_id` 至少传一个 | `司南双月宝组合` |
| `query_scope` | `string` | 否 | 查询范围：basic / performance / composition / risk / all，默认 all；当前主要用于上层输出裁剪，不直接改变底层接口调用 | `all` |

## 问句示例

| 类型 | query |
|----|----|
| 查询 投顾策略查询 | 帮我调用 FUND_TG_STRATEGY_INFO |
| 按示例参数调用 | 使用 FUND_TG_STRATEGY_INFO，参数参考请求示例 |
| 查询结果解释 | 帮我读取 FUND_TG_STRATEGY_INFO 的返回结果并解释关键字段 |

## 接口结果释义

### 一、业务结果根节点 (`data.raw_result.body`)

以下字段位于统一网关返回中的 `data.raw_result.body`，是实际业务结果的根节点。

| 字段路径 | 类型 | 核心释义 |
|----|----|----|
| `success` | boolean | 接口是否成功，true = 成功 |
| `errorCode` | integer | 接口全局错误码，0 = 成功 |
| `data` | object | 核心业务数据 |

### 二、核心字段说明

以下字段说明均面向 `data.raw_result.body`，不展开服务端内部编排、上下游映射和调试字段。

| 字段 Key | 含义说明 |
| --- | --- |
| `success` | 接口是否成功；true 表示 workflow 聚合成功 |
| `errorCode` | 业务错误码；0 表示成功，非 0 表示失败 |
| `data.request_context` | 本次查询请求上下文 |
| `data.strategy_profile` | 投顾策略基础信息聚合结果 |
| `data.performance` | 投顾策略历史业绩聚合结果 |
| `data.composition` | 投顾策略组合构成聚合结果 |
| `data.risk` | 投顾策略风险特征聚合结果 |
| `data.ai_context` | 用于生成 AI 解读摘要的补充上下文 |
| `data.service_updates` | 策略服务动态原始聚合结果 |
| `data.strategy_profile.strategy_id` | 投顾策略唯一标识 |
| `data.strategy_profile.strategy_name` | 投顾策略名称 |
| `data.strategy_profile.provider` | 投顾机构名称 |
| `data.strategy_profile.strategy_type` | 策略类型或策略风格标签；当前取 tgfund.tgExtendInfo.LABEL2 |
| `data.strategy_profile.risk_level` | 风险等级原始值；上游返回 1-5 的原始等级值；上层展示时建议渲染为 R1-R5，例如 3 -> R3 |
| `data.strategy_profile.target_user` | 适合用户描述原始标签 |
| `data.strategy_profile.target_annual_yield` | 目标或期望年化回报；来源于 TARGETANNYIELD；若为空字符串表示暂无公开数据 |
| `data.strategy_profile.min_investment` | 最低投资金额原始值 |
| `data.strategy_profile.subscription_fee` | 投顾服务年费率原始值；例如 0.004 表示 0.4%，上层展示时需乘以 100 后拼接百分号 |
| `data.strategy_profile.inception_date` | 策略成立日期原始时间戳 |
| `data.strategy_profile.subscriber_count_display` | 跟投人数或展示人数原始值 |
| `data.strategy_profile.strategy_summary` | 策略简介或策略理念汇总 |
| `data.performance.ytd_return` | 今年以来收益率 |
| `data.performance.return_1m` | 近1月收益率 |
| `data.performance.return_3m` | 近3月收益率 |
| `data.performance.return_6m` | 近6月收益率 |
| `data.performance.return_1y` | 近1年收益率 |
| `data.performance.return_since_inception` | 成立以来收益率 |
| `data.performance.annualized_return` | 成立以来年化收益率 |
| `data.performance.benchmark_return_1y` | 近1年基准收益率 |
| `data.performance.excess_return_1y_source` | 近1年超额收益计算所需原始值 |
| `data.composition.snapshot_date` | 组合持仓披露日期 |
| `data.composition.hold_type_groups` | 按基金类型分组的组合持仓列表 |
| `data.composition.hold_type_groups[].newFundTypeName` | 资产类别或基金类型名称 |
| `data.composition.hold_type_groups[].totalRatio` | 该资产类别当前权重占比 |
| `data.composition.hold_type_groups[].fundsList[].fundName` | 底层基金名称 |
| `data.composition.hold_type_groups[].fundsList[].fundCode` | 底层基金代码 |
| `data.composition.hold_type_groups[].fundsList[].newFundTypeName` | 底层基金类型 |
| `data.composition.hold_type_groups[].fundsList[].increase` | 较上次调仓变化原始值 |
| `data.composition.hold_type_groups[].fundsList[].ratio` | 底层基金持仓权重；当前样例中为空，需按真实返回判空使用 |
| `data.composition.hold_type_groups[].fundsList[].date` | 持仓披露日期 |
| `data.risk.max_drawdown` | 成立以来最大回撤 |
| `data.risk.max_drawdown_since_inception` | 成立以来最大回撤；当前与 max_drawdown 使用同一底层字段 tgCharacteristicsPage1.maxretra_LN |
| `data.risk.max_drawdown_1y` | 近1年最大回撤 |
| `data.risk.profit_probability_1y` | 持有1年盈利概率 |
| `data.risk.annualized_volatility` | 近1年波动率 |
| `data.risk.sharpe_ratio` | 夏普比率（近1年） |
| `data.risk.benchmark_win_rate_1y` | 近1年跑赢基准概率 |
| `data.risk.win_rate_monthly` | 兼容字段；当前底层来源是 mexwin_1N，实际更接近近1年跑赢基准概率，不建议直接解读为月度胜率 |
| `data.risk.high_quality_ratio_1y` | 近1年排名靠前基金占比 |
| `data.ai_context.strategy_concept_full` | 策略理念全文，可作为 AI 解读底稿 |
| `data.ai_context.latest_accompany_text` | 最新投顾陪伴文案 |
| `data.ai_context.latest_service_post_title` | 最新服务动态标题 |
| `data.disambiguation_candidates` | 名称歧义时的候选策略列表，供上层引导用户选择 |
| `data.resolution_selected` | 当前 resolver 自动选中的候选，仅供参考 |
| `data.risk_disclaimer` | 风险提示语 |

## 交互规范

1. 优先检查环境变量 `TTFUND_APIKEY`。
2. 若环境变量存在，则直接继续调用接口。
3. 若环境变量不存在，必须中断当前调用，并强制提示用户先完成 apikey 配置。
4. 引导文案必须明确包含：
   - 环境变量名：`TTFUND_APIKEY`
   - apikey 获取路径：`天天基金搜索 skills`
5. 每次请求都必须带上 `skill_id` 和 `_skill_version`。
6. `_skill_version` 固定使用当前安装版本：`1.0.0`。
7. 若缺少必填参数，应提示用户补充 `strategy_id 或 strategy_name（至少传一个）`。
8. 返回结果时，应优先提炼核心信息，而不是直接原样堆砌所有字段。
9. 结果解释顺序必须是：先看业务结果，再看 `version_info`，最后决定是否追加升级建议。

## 输出建议

返回时优先展示：
- `success`
- `errorCode`
- `data.request_context`
- `data.strategy_profile`
- `data.performance`
- `data.composition`
- `data.risk`
- `data.ai_context`

如需结构化输出，建议包含两部分：

- `business_result`：对应 `data.raw_result.body` 的核心业务结果
- `explanation_document`：对关键字段和结果差异的说明

说明：统一网关还可能返回少量辅助信息，用于调试、排错或版本提示；用户文档默认不展开这些字段，请以 `data.raw_result.body` 为准。

后处理要求：

- 若 `data.version_info.is_outdated = true`，先完成本次结果回答，再附上一句简洁升级提醒。
- 若接口返回升级导向错误，不要重复盲重试，也不要误判为普通网络问题，应直接提示用户升级 skill。
- 若接口返回普通业务错误且没有版本归因信号，则按原有逻辑处理，不额外渲染升级提示。

## 错误处理

- 若缺少 apikey，应提示用户：
  - `当前未检测到 TTFUND_APIKEY，请先前往天天基金搜索 skills 获取 apikey，并在本机配置该环境变量后重试。`
- 若缺少 `_skill_version`，应提示用户：
  - `当前安装的 skill 可能为旧版本，未携带版本信息。请升级到最新版本 1.0.0 后重试。`
- 若 `_skill_version` 为空或无效，应提示用户：
  - `当前安装的 skill 版本信息无效，可能为旧版本或安装不完整。请升级到最新版本 1.0.0 后重试。`
- 若 HTTP 请求失败、超时或返回非 2xx 状态码，应提示用户：
  - `投顾策略查询服务暂时不可用，请稍后重试。`
- 若返回 `version_info` 表示本地版本落后，应优先提示用户尽快升级 skill。
- 若版本落后且本次错误属于参数缺失、字段不兼容或调用协议不匹配，应优先提示用户先升级 skill 再重试。
- 若业务成功字段 `success` 校验失败，则视为业务失败：
  - 简要说明错误信息
  - 不自行猜测结果或伪造成功
- 若核心返回数据为空，应提示用户检查输入参数是否正确。

## 安全与边界

- 该 Skill 返回的是 `投顾策略查询` 对应的业务数据，请按业务场景谨慎使用。
- 返回内容仅用于当前用户请求的查询与分析，不应伪造结果或输出未验证内容。


### 7. 指数详情查询 详细说明

---

请为我安装如下skill

## name:

指数详情查询

## version:

1.0.0

## description:

本 Skill 基于**fund**构建，支持通过**自然语言**实现以下功能：
- 调用 `FUND_INDEX_INFO` 对应的核心能力
- 当前发布版本为 `1.0.0`，调用时必须携带 `_skill_version`
- 支持输入指数代码或指数名称查询指数详情。若输入为指数名称，则先通过搜索接口解析 index_code，再串联查询指数基础详情、实时行情、指数成分与相关可投产品，最终聚合返回指数基础信息、实时行情、历史表现、估值水平、成分概览、相关产品原始结果、AI 解读所需上下文、名称解析候选与风险提示。
- 输出适合阅读和进一步分析的结构化结果

---

# 指数详情查询

通过**自然语言**或结构化参数调用 `FUND_INDEX_INFO` 对应能力，接口返回 JSON 格式内容。

- 当前 skill 版本：`1.0.0`

## 使用方式

1. 在调用任何接口前，必须先检查本地环境变量 `TTFUND_APIKEY` 是否存在。
2. 若本地已存在 `TTFUND_APIKEY`，则直接使用该 apikey 发起请求。
3. 若本地不存在 `TTFUND_APIKEY`，必须强制引导用户先配置 apikey，不得跳过。
4. apikey 获取路径：
   - 打开 **天天基金**
   - 搜索 **skills**
   - 在对应 Skills 页面获取 `指数详情查询` 对应的 apikey
5. 当检测到 apikey 缺失时，必须明确提示用户：
   - `当前未检测到本地环境变量 TTFUND_APIKEY，请先前往天天基金搜索 skills 获取 apikey，并在本机配置环境变量后再继续使用。`
6. 在用户未完成 apikey 配置前，不继续执行 skill 查询请求。
7. 配置完成后，使用 **POST** 请求调用统一网关接口，并将 apikey 放入 `X-API-Key` 请求头中。
8. 每次请求体都必须同时携带 `skill_id` 和 `_skill_version`。
9. `_skill_version` 必须填写当前安装版本：`1.0.0`。

编写调用方式脚本

```bash
curl --location 'https://skills.tiantianfunds.com/ai-smart-skill-service/openapi/skill/invoke' \
--header "X-API-Key: $TTFUND_APIKEY" \
--header 'Content-Type: application/json' \
--data '{
  "skill_id": "FUND_INDEX_INFO",
  "_skill_version": "1.0.0",
  "index_id": "沪深300",
  "query_scope": "all",
  "time_range": "1y"
}'
```

如果当前底层接口未强制校验 apikey，也必须先检查并要求配置 `TTFUND_APIKEY`，不可省略该步骤。

## 编排流程

该 skill 使用服务端 workflow 自动完成名称解析、数据获取与结果聚合，对调用方透明。

- 若已提供 `indexcode`，服务端优先直查；缺少时可根据 `index_id` 自动解析候选代码。
- 服务端会自动执行内部步骤并完成聚合；当前配置共包含 `4` 个业务步骤。
- 文档中的返回字段说明仅面向最终业务结果 `data.raw_result.body`，不展开内部字段映射关系。
## 请求参数说明

以下表格说明统一网关接收的对外请求字段；若 skill 配置了 workflow，系统会在内部自动完成名称解析、代码回填和最终详情接口调用。

| 请求字段 | 类型 | 必填 | 说明 | 示例 |
|----|----|----|----|----|
| `index_id` | `string` | 是 | 指数代码或指数名称，例如 000300、沪深300、创业板指；至少传一个 | `沪深300` |
| `query_scope` | `string` | 否 | 查询范围：quote / valuation / composition / performance / products / all，默认 all；当前主要用于上层结果裁剪，不直接改变底层接口调用 | `all` |
| `time_range` | `string` | 否 | 历史业绩时间范围，默认 1y；当前底层接口直接返回多区间收益，此字段供上层选择展示窗口 | `1y` |

## 问句示例

| 类型 | query |
|----|----|
| 查询 指数详情查询 | 帮我调用 FUND_INDEX_INFO |
| 按示例参数调用 | 使用 FUND_INDEX_INFO，参数参考请求示例 |
| 查询结果解释 | 帮我读取 FUND_INDEX_INFO 的返回结果并解释关键字段 |

## 接口结果释义

### 一、业务结果根节点 (`data.raw_result.body`)

以下字段位于统一网关返回中的 `data.raw_result.body`，是实际业务结果的根节点。

| 字段路径 | 类型 | 核心释义 |
|----|----|----|
| `success` | boolean | 接口是否成功，true = 成功 |
| `errorCode` | integer | 接口全局错误码，0 = 成功 |
| `data` | object | 核心业务数据 |

### 二、核心字段说明

以下字段说明均面向 `data.raw_result.body`，不展开服务端内部编排、上下游映射和调试字段。

| 字段 Key | 含义说明 |
| --- | --- |
| `success` | 接口是否成功；true 表示 workflow 聚合成功 |
| `errorCode` | 业务错误码；0 表示成功，非 0 表示失败 |
| `data.request_context` | 本次指数查询请求上下文 |
| `data.index_profile` | 指数基础信息聚合结果 |
| `data.quote` | 指数实时行情聚合结果 |
| `data.performance` | 指数历史表现聚合结果 |
| `data.valuation` | 指数估值水平聚合结果 |
| `data.composition` | 指数成分概览聚合结果 |
| `data.related_products` | 指数相关可投产品结果 |
| `data.ai_context` | 用于生成 AI 解读摘要的补充上下文 |
| `data.index_profile.index_code` | 解析后的指数代码 |
| `data.index_profile.index_name` | 指数名称 |
| `data.index_profile.full_index_name` | 指数全称 |
| `data.index_profile.index_market` | 指数市场号原始值；用于拼接实时行情 secids，也可辅助上层推导 SH / SZ 等展示后缀 |
| `data.index_profile.index_type` | 指数市场分类原始值 |
| `data.index_profile.maker_name` | 指数编制机构 |
| `data.index_profile.description` | 指数简介或编制逻辑说明 |
| `data.index_profile.related_fund_count` | 相关跟踪基金数量 |
| `data.index_profile.related_fund_codes` | 相关基金代码列表原始串 |
| `data.index_profile.index_valuation_flag` | 是否展示估值原始标记 |
| `data.quote.index_code_full` | 带市场后缀的指数代码；当前优先取成分接口中的 SECUCODE，例如 000300.SH |
| `data.quote.current_point` | 当前点位 |
| `data.quote.change_point` | 今日涨跌点数 |
| `data.quote.change_pct` | 今日涨跌幅 |
| `data.quote.turnover_volume` | 成交量原始值 |
| `data.quote.turnover_amount` | 成交额原始值；上层可换算为亿元展示 |
| `data.quote.quote_time` | 行情日期或最近交易日日期 |
| `data.quote.ytd_return` | 今年以来涨跌幅 |
| `data.performance.return_1w` | 近1周收益率 |
| `data.performance.return_1m` | 近1月收益率 |
| `data.performance.return_3m` | 近3月收益率 |
| `data.performance.return_6m` | 近6月收益率 |
| `data.performance.return_1y` | 近1年收益率 |
| `data.performance.return_2y` | 近2年收益率 |
| `data.performance.return_3y` | 近3年收益率 |
| `data.performance.return_5y` | 近5年收益率 |
| `data.performance.return_ytd` | 今年以来收益率 |
| `data.valuation.pe_ttm` | 当前市盈率（TTM） |
| `data.valuation.pe_percentile_10y` | PE 在历史区间中的分位数 |
| `data.valuation.pb` | 当前市净率 |
| `data.valuation.pb_percentile_10y` | PB 在历史区间中的分位数 |
| `data.valuation.roe` | 近 12 个月净资产收益率 |
| `data.valuation.dividend_yield` | 股息率 |
| `data.valuation.valuation_label_source` | 估值标签合成所需原始分位数据 |
| `data.composition.total_components` | 成分股或成分券数量 |
| `data.composition.industry_count` | 行业分组数量 |
| `data.composition.top_industries` | 行业分布原始数组；上层可取前 3 大行业做展示 |
| `data.composition.component_details` | 成分股明细原始数组；当前底层固定返回前 10 条成分明细；上层可取前 5 条生成 top5_components，并用这 10 条权重求和得到 concentration_top10 |
| `data.related_products.index_code` | 当前相关产品对应的指数代码 |
| `data.related_products.raw` | 相关可投产品原始结果；返回结构按 index_code 为 key 组织，例如 raw['000300'] 即对应产品列表 |
| `data.ai_context.raw` | AI 解读所需原始指数详情数据 |
| `data.disambiguation_candidates` | 名称歧义时的候选指数列表，供上层引导用户选择 |
| `data.resolution_selected` | 当前 resolver 自动选中的候选，仅供参考 |
| `data.risk_disclaimer` | 风险提示语 |

## 交互规范

1. 优先检查环境变量 `TTFUND_APIKEY`。
2. 若环境变量存在，则直接继续调用接口。
3. 若环境变量不存在，必须中断当前调用，并强制提示用户先完成 apikey 配置。
4. 引导文案必须明确包含：
   - 环境变量名：`TTFUND_APIKEY`
   - apikey 获取路径：`天天基金搜索 skills`
5. 每次请求都必须带上 `skill_id` 和 `_skill_version`。
6. `_skill_version` 固定使用当前安装版本：`1.0.0`。
7. 若缺少必填参数，应提示用户补充 `index_id`。
8. 返回结果时，应优先提炼核心信息，而不是直接原样堆砌所有字段。
9. 结果解释顺序必须是：先看业务结果，再看 `version_info`，最后决定是否追加升级建议。

## 输出建议

返回时优先展示：
- `success`
- `errorCode`
- `data.request_context`
- `data.index_profile`
- `data.quote`
- `data.performance`
- `data.valuation`
- `data.composition`

如需结构化输出，建议包含两部分：

- `business_result`：对应 `data.raw_result.body` 的核心业务结果
- `explanation_document`：对关键字段和结果差异的说明

说明：统一网关还可能返回少量辅助信息，用于调试、排错或版本提示；用户文档默认不展开这些字段，请以 `data.raw_result.body` 为准。

后处理要求：

- 若 `data.version_info.is_outdated = true`，先完成本次结果回答，再附上一句简洁升级提醒。
- 若接口返回升级导向错误，不要重复盲重试，也不要误判为普通网络问题，应直接提示用户升级 skill。
- 若接口返回普通业务错误且没有版本归因信号，则按原有逻辑处理，不额外渲染升级提示。

## 错误处理

- 若缺少 apikey，应提示用户：
  - `当前未检测到 TTFUND_APIKEY，请先前往天天基金搜索 skills 获取 apikey，并在本机配置该环境变量后重试。`
- 若缺少 `_skill_version`，应提示用户：
  - `当前安装的 skill 可能为旧版本，未携带版本信息。请升级到最新版本 1.0.0 后重试。`
- 若 `_skill_version` 为空或无效，应提示用户：
  - `当前安装的 skill 版本信息无效，可能为旧版本或安装不完整。请升级到最新版本 1.0.0 后重试。`
- 若 HTTP 请求失败、超时或返回非 2xx 状态码，应提示用户：
  - `指数详情查询服务暂时不可用，请稍后重试。`
- 若返回 `version_info` 表示本地版本落后，应优先提示用户尽快升级 skill。
- 若版本落后且本次错误属于参数缺失、字段不兼容或调用协议不匹配，应优先提示用户先升级 skill 再重试。
- 若业务成功字段 `success` 校验失败，则视为业务失败：
  - 简要说明错误信息
  - 不自行猜测结果或伪造成功
- 若核心返回数据为空，应提示用户检查输入参数是否正确。

## 安全与边界

- 该 Skill 返回的是 `指数详情查询` 对应的业务数据，请按业务场景谨慎使用。
- 返回内容仅用于当前用户请求的查询与分析，不应伪造结果或输出未验证内容。


### 8. 基金净值查询 详细说明

---

请为我安装如下skill

## name:

基金净值查询

## version:

1.0.0

## description:

本 Skill 基于**fund**构建，支持通过**自然语言**实现以下功能：
- 调用 `FUND_NAV_INFO` 对应的核心能力
- 当前发布版本为 `1.0.0`，调用时必须携带 `_skill_version`
- 支持输入基金代码或基金名称查询基金净值历史。当前配置会先通过基金搜索接口解析 fund_code，再查询净值曲线接口，最终返回基金基础信息、查询范围、净值历史序列、分红拆分等事件标记、名称解析候选与风险提示。
- 输出适合阅读和进一步分析的结构化结果

---

# 基金净值查询

通过**自然语言**或结构化参数调用 `FUND_NAV_INFO` 对应能力，接口返回 JSON 格式内容。

- 当前 skill 版本：`1.0.0`

## 使用方式

1. 在调用任何接口前，必须先检查本地环境变量 `TTFUND_APIKEY` 是否存在。
2. 若本地已存在 `TTFUND_APIKEY`，则直接使用该 apikey 发起请求。
3. 若本地不存在 `TTFUND_APIKEY`，必须强制引导用户先配置 apikey，不得跳过。
4. apikey 获取路径：
   - 打开 **天天基金**
   - 搜索 **skills**
   - 在对应 Skills 页面获取 `基金净值查询` 对应的 apikey
5. 当检测到 apikey 缺失时，必须明确提示用户：
   - `当前未检测到本地环境变量 TTFUND_APIKEY，请先前往天天基金搜索 skills 获取 apikey，并在本机配置环境变量后再继续使用。`
6. 在用户未完成 apikey 配置前，不继续执行 skill 查询请求。
7. 配置完成后，使用 **POST** 请求调用统一网关接口，并将 apikey 放入 `X-API-Key` 请求头中。
8. 每次请求体都必须同时携带 `skill_id` 和 `_skill_version`。
9. `_skill_version` 必须填写当前安装版本：`1.0.0`。

编写调用方式脚本

```bash
curl --location 'https://skills.tiantianfunds.com/ai-smart-skill-service/openapi/skill/invoke' \
--header "X-API-Key: $TTFUND_APIKEY" \
--header 'Content-Type: application/json' \
--data '{
  "skill_id": "FUND_NAV_INFO",
  "_skill_version": "1.0.0",
  "fund_id": "华夏核心成长混合C",
  "range": "n"
}'
```

如果当前底层接口未强制校验 apikey，也必须先检查并要求配置 `TTFUND_APIKEY`，不可省略该步骤。

## 编排流程

该 skill 使用服务端 workflow 自动完成名称解析、数据获取与结果聚合，对调用方透明。

- 若已提供 `fcode`，服务端优先直查；缺少时可根据 `fund_id` 自动解析候选代码。
- 服务端会自动执行内部步骤并完成聚合；当前配置共包含 `1` 个业务步骤。
- 文档中的返回字段说明仅面向最终业务结果 `data.raw_result.body`，不展开内部字段映射关系。
## 请求参数说明

以下表格说明统一网关接收的对外请求字段；若 skill 配置了 workflow，系统会在内部自动完成名称解析、代码回填和最终详情接口调用。

| 请求字段 | 类型 | 必填 | 说明 | 示例 |
|----|----|----|----|----|
| `fund_id` | `string` | 是 | 基金代码或基金名称，例如 018036、华夏核心成长混合C；至少传一个 | `华夏核心成长混合C` |
| `range` | `string` | 否 | 净值历史范围：y=近一月，3y=近三月，6y=近六月，n=近一年，2n=近两年，3n=近三年，ln=成立以来；默认 n | `n` |

## 问句示例

| 类型 | query |
|----|----|
| 查询 基金净值查询 | 帮我调用 FUND_NAV_INFO |
| 按示例参数调用 | 使用 FUND_NAV_INFO，参数参考请求示例 |
| 查询结果解释 | 帮我读取 FUND_NAV_INFO 的返回结果并解释关键字段 |

## 接口结果释义

### 一、业务结果根节点 (`data.raw_result.body`)

以下字段位于统一网关返回中的 `data.raw_result.body`，是实际业务结果的根节点。

| 字段路径 | 类型 | 核心释义 |
|----|----|----|
| `success` | boolean | 接口是否成功，true = 成功 |
| `errorCode` | integer | 接口全局错误码，0 = 成功 |
| `data` | object | 核心业务数据 |

### 二、核心字段说明

以下字段说明均面向 `data.raw_result.body`，不展开服务端内部编排、上下游映射和调试字段。

| 字段 Key | 含义说明 |
| --- | --- |
| `success` | 接口是否成功；true 表示服务端 workflow 聚合成功 |
| `errorCode` | 业务错误码；0 表示成功，非 0 表示失败 |
| `data` | 基金净值查询聚合结果 |
| `data.fund_profile` | 基金基础信息与本次输入信息 |
| `data.fund_profile.input_fund_id` | 原始输入的基金代码或基金名称 |
| `data.fund_profile.fund_code` | 解析后的基金代码 |
| `data.fund_profile.fund_name` | 解析后的基金名称 |
| `data.fund_profile.fund_type` | 解析出的基金类型 |
| `data.request_context` | 本次查询上下文 |
| `data.request_context.range` | 净值历史查询范围 |
| `data.nav_history` | 净值历史数据聚合结果 |
| `data.nav_history.items` | 净值历史序列 |
| `data.nav_history.items.FSRQ` | 净值日期列表 |
| `data.nav_history.items.DWJZ` | 单位净值列表 |
| `data.nav_history.items.JZZZL` | 单日涨跌幅列表；单位通常为百分比 |
| `data.nav_history.items.LJJZ` | 累计净值列表 |
| `data.nav_history.items.NAVTYPE` | 净值类型列表 |
| `data.nav_history.items.RATE` | 预留收益率字段列表 |
| `data.nav_history.total_count` | 净值历史记录总数 |
| `data.nav_history.corporate_actions` | 分红、拆分等净值事件标记列表 |
| `data.nav_history.corporate_actions.STYPE` | 事件类型列表 |
| `data.nav_history.corporate_actions.BONUS` | 分红金额列表 |
| `data.nav_history.corporate_actions.NET` | 净值调整相关字段列表 |
| `data.nav_history.corporate_actions.FSRQ` | 事件发生日期列表 |
| `data.nav_history.raw` | 净值历史接口原始结果 |
| `data.disambiguation_candidates` | 名称歧义时的候选基金列表，供上层引导用户选择 |
| `data.resolution_selected` | 当前 resolver 自动选中的基金候选，仅供参考 |
| `data.risk_disclaimer` | 风险提示语 |

## 交互规范

1. 优先检查环境变量 `TTFUND_APIKEY`。
2. 若环境变量存在，则直接继续调用接口。
3. 若环境变量不存在，必须中断当前调用，并强制提示用户先完成 apikey 配置。
4. 引导文案必须明确包含：
   - 环境变量名：`TTFUND_APIKEY`
   - apikey 获取路径：`天天基金搜索 skills`
5. 每次请求都必须带上 `skill_id` 和 `_skill_version`。
6. `_skill_version` 固定使用当前安装版本：`1.0.0`。
7. 若缺少必填参数，应提示用户补充 `fund_id`。
8. 返回结果时，应优先提炼核心信息，而不是直接原样堆砌所有字段。
9. 结果解释顺序必须是：先看业务结果，再看 `version_info`，最后决定是否追加升级建议。

## 输出建议

返回时优先展示：
- `success`
- `errorCode`
- `data`
- `data.fund_profile`
- `data.fund_profile.input_fund_id`
- `data.fund_profile.fund_code`
- `data.fund_profile.fund_name`
- `data.fund_profile.fund_type`

如需结构化输出，建议包含两部分：

- `business_result`：对应 `data.raw_result.body` 的核心业务结果
- `explanation_document`：对关键字段和结果差异的说明

说明：统一网关还可能返回少量辅助信息，用于调试、排错或版本提示；用户文档默认不展开这些字段，请以 `data.raw_result.body` 为准。

后处理要求：

- 若 `data.version_info.is_outdated = true`，先完成本次结果回答，再附上一句简洁升级提醒。
- 若接口返回升级导向错误，不要重复盲重试，也不要误判为普通网络问题，应直接提示用户升级 skill。
- 若接口返回普通业务错误且没有版本归因信号，则按原有逻辑处理，不额外渲染升级提示。

## 错误处理

- 若缺少 apikey，应提示用户：
  - `当前未检测到 TTFUND_APIKEY，请先前往天天基金搜索 skills 获取 apikey，并在本机配置该环境变量后重试。`
- 若缺少 `_skill_version`，应提示用户：
  - `当前安装的 skill 可能为旧版本，未携带版本信息。请升级到最新版本 1.0.0 后重试。`
- 若 `_skill_version` 为空或无效，应提示用户：
  - `当前安装的 skill 版本信息无效，可能为旧版本或安装不完整。请升级到最新版本 1.0.0 后重试。`
- 若 HTTP 请求失败、超时或返回非 2xx 状态码，应提示用户：
  - `基金净值查询服务暂时不可用，请稍后重试。`
- 若返回 `version_info` 表示本地版本落后，应优先提示用户尽快升级 skill。
- 若版本落后且本次错误属于参数缺失、字段不兼容或调用协议不匹配，应优先提示用户先升级 skill 再重试。
- 若业务成功字段 `success` 校验失败，则视为业务失败：
  - 简要说明错误信息
  - 不自行猜测结果或伪造成功
- 若核心返回数据为空，应提示用户检查输入参数是否正确。

## 安全与边界

- 该 Skill 返回的是 `基金净值查询` 对应的业务数据，请按业务场景谨慎使用。
- 返回内容仅用于当前用户请求的查询与分析，不应伪造结果或输出未验证内容。

---



### 9. 模拟组合管理与交易skill 详细说明

---

请为我安装如下skill

## name:

模拟组合管理与交易skill

## version:

1.0.0

## description:

本 Skill 基于**portfolio**构建，支持通过**自然语言**实现以下功能：
- 调用 `MODEL_PORTFOLIO` 对应的核心能力
- 当前发布版本为 `1.0.0`，调用时必须携带 `_skill_version`
- 单 skill 多 action 路由：覆盖模拟组合的组合管理、组合查询、持仓与收益查询、买入/赎回、交易查询与撤单等能力；调仓能力当前提供调仓预览。
- 输出适合阅读和进一步分析的结构化结果

---

# 模拟组合管理与交易skill

通过**自然语言**或结构化参数调用 `MODEL_PORTFOLIO` 对应能力，接口返回 JSON 格式内容。

- 当前 skill 版本：`1.0.0`

## 使用方式

1. 在调用任何接口前，必须先检查本地环境变量 `TTFUND_APIKEY` 是否存在。
2. 若本地已存在 `TTFUND_APIKEY`，则直接使用该 apikey 发起请求。
3. 若本地不存在 `TTFUND_APIKEY`，必须强制引导用户先配置 apikey，不得跳过。
4. apikey 获取路径：
   - 打开 **天天基金**
   - 搜索 **skills**
   - 在对应 Skills 页面获取 `模拟组合管理与交易skill` 对应的 apikey
5. 当检测到 apikey 缺失时，必须明确提示用户：
   - `当前未检测到本地环境变量 TTFUND_APIKEY，请先前往天天基金搜索 skills 获取 apikey，并在本机配置环境变量后再继续使用。`
6. 在用户未完成 apikey 配置前，不继续执行 skill 查询请求。
7. 配置完成后，使用 **POST** 请求调用统一网关接口，并将 apikey 放入 `X-API-Key` 请求头中。
8. 每次请求体都必须同时携带 `skill_id` 和 `_skill_version`。
9. `_skill_version` 必须填写当前安装版本：`1.0.0`。

编写调用方式脚本

```bash
curl --location 'https://skills.tiantianfunds.com/ai-smart-skill-service/openapi/skill/invoke' \
--header "X-API-Key: $TTFUND_APIKEY" \
--header 'Content-Type: application/json' \
--data '{
  "skill_id": "MODEL_PORTFOLIO",
  "_skill_version": "1.0.0",
  "action": "subacc.list",
  "subacc_list": {
    "fetchDissolve": true
  }
}'
```

如果当前底层接口未强制校验 apikey，也必须先检查并要求配置 `TTFUND_APIKEY`，不可省略该步骤。

## 交易调用防踩坑（重要）

- `MODEL_PORTFOLIO` 按对象字段路由，不按 `action` 文本路由。
- 买入类调用必须传对象参数，不可写 `trade_buy_bulk_amount: 1` 或 `trade_buy_bulk_amount_v2: 1`。
- 交易参数不能放根节点，必须放在对应对象内（例如 `trade_buy_bulk_amount_v2.subAccountNo`）。
- `trade_buy_bulk_amount` / `trade_buy_bulk_amount_v2` 的 `items` 子项必须是 `{fundCode, itemAmount}`，不要写成 `{fundCode, amount}`。
- `reference` 建议控制在 `<=10` 字符，避免下游数据库长度报错。

错误示例（会被跳过）：

```json
{
  "skill_id": "MODEL_PORTFOLIO",
  "_skill_version": "1.0.0",
  "trade_buy_bulk_amount_v2": 1,
  "subAccountNo": "MP10458714",
  "fundCode": "019144",
  "amount": 200
}
```

正确示例（能命中交易 step）：

```json
{
  "skill_id": "MODEL_PORTFOLIO",
  "_skill_version": "1.0.0",
  "confirm_write": true,
  "trade_buy_bulk_amount_v2": {
    "subAccountNo": "MP10458714",
    "amount": 200,
    "items": [
      {
        "fundCode": "019144",
        "itemAmount": 200
      }
    ],
    "reference": "r1"
  }
}
```

## 编排流程

该 skill 使用服务端 workflow 自动完成名称解析、数据获取与结果聚合，对调用方透明。

- 服务端会自动执行内部步骤并完成聚合；当前配置共包含 `37` 个业务步骤。
- 文档中的返回字段说明仅面向最终业务结果 `data.raw_result.body`，不展开内部字段映射关系。
## 请求参数说明

以下表格说明统一网关接收的对外请求字段；若 skill 配置了 workflow，系统会在内部自动完成名称解析、代码回填和最终详情接口调用。

| 请求字段 | 类型 | 必填 | 说明 | 示例 |
|----|----|----|----|----|
| `action` | `string` | 否 | 可选：用于说明本次调用意图。实际路由以对应 action 对象是否存在为准（例如 subacc_list/subacc_detail 等）。 | `-` |
| `confirm_write` | `boolean` | 否 | 可选：写操作确认开关。建议写操作时显式传 true。 | `-` |
| `subacc_list` | `object` | 至少传一项 | subacc.list：获取全部分账户信息（组合列表）。字段：fetchDissolve(可选,true/false)；customerNo 由上下文注入。 | `-` |
| `subacc_detail` | `object` | 至少传一项 | subacc.detail：获取分账户组合详细信息。字段：subAccountNo；customerNo 由上下文注入。 | `-` |
| `subacc_create` | `object` | 至少传一项 | subacc.create：新增组合（写）。字段：info(对象)；passportId 与 info.customerNo 均由上下文注入并强制覆盖；info.style 必须传枚举值（如 S2）。 | `-` |
| `subacc_update` | `object` | 至少传一项 | subacc.update：更新组合（写）。字段：subAccountInfo(对象)；subAccountInfo.customerNo 由上下文注入并强制覆盖。 | `-` |
| `subacc_disband` | `object` | 至少传一项 | subacc.disband：解散组合（写）。字段：businRemark, subAccountInfo(对象)；subAccountInfo.customerNo 由上下文注入并强制覆盖。 | `-` |
| `subacc_validate` | `object` | 至少传一项 | subacc.validate：验证组合是否有效。字段：subAccountNoList（逗号分隔）。 | `-` |
| `subacc_hold` | `object` | 至少传一项 | subacc.hold：获取组合持仓详情。字段：subAccountNo；customerNo 由上下文注入。 | `-` |
| `subacc_profit_daily` | `object` | 至少传一项 | subacc.profit.daily：分页每日收益。字段：subAccountNo, pageNum, pageCount；customerNo 由上下文注入。 | `-` |
| `subacc_profit_monthly` | `object` | 至少传一项 | subacc.profit.monthly：月度收益。字段：subAccountNo, startTime, endTime（yyyy-MM-dd HH:mm:ss）；customerNo 由上下文注入。 | `-` |
| `subacc_profit_interval_detail` | `object` | 至少传一项 | subacc.profit.interval_detail：收益日线图。字段：subAccountNO, intervalType, dataType；customerNO 由上下文注入。 | `-` |
| `subacc_profit_drawdown` | `object` | 至少传一项 | subacc.profit.drawdown：历史收益率回测。字段：subAccountNo；customerNo 由上下文注入。 | `-` |
| `rebalance_record_list` | `object` | 至少传一项 | rebalance.record.list：调仓记录查询（web）。字段：subAccountNo, pageNum, pageCount, endTime（yyyy-MM-dd HH:mm:ss）；customerNo 由上下文注入。 | `-` |
| `trade_init` | `object` | 至少传一项 | trade.init：初始化交易侧账户（写）。字段：customerNo/passportId 均由上下文注入。 | `-` |
| `asset_by_customer` | `object` | 至少传一项 | asset.by_customer：客户维度资产概览。customerNo 由上下文注入。 | `-` |
| `asset_by_sub` | `object` | 至少传一项 | asset.by_sub：子账户资产明细预览。字段：subAccNo；customerNo 由上下文注入。 | `-` |
| `rebalance_expected_ratio` | `object` | 至少传一项 | rebalance.expected_ratio：获取预期持仓占比。字段：subAccountNo；customerNo 由上下文注入。 | `-` |
| `trade_buy_bulk_ratio` | `object` | 至少传一项 | trade.buy.bulk_ratio：组合一键买入（比例，写）。字段：subAccountNo, amount, ratios(数组), reference(可选，建议<=10字符)；customerNo 由上下文注入；ratio 口径 0-1。 | `-` |
| `trade_buy_bulk_amount` | `object` | 至少传一项 | trade.buy.bulk_amount：组合一键买入（自定义金额，写）。字段：subAccountNo, amount, items(数组), reference(建议<=10字符)；customerNo 由上下文注入；items 子项必须是 {fundCode, itemAmount}。 | `-` |
| `trade_buy_bulk_ratio_v2` | `object` | 至少传一项 | trade.buy.bulk_ratio_v2：组合一键买入V2（比例，写）。完整字段见下方 `trade_buy_bulk_ratio_v2 字段建议`。 | `-` |
| `trade_buy_bulk_amount_v2` | `object` | 至少传一项 | trade.buy.bulk_amount_v2：组合一键买入V2（自定义金额，写）。完整字段见下方 `trade_buy_bulk_amount_v2 字段建议`。 | `-` |
| `trade_vcard_pay` | `object` | 至少传一项 | trade.vcard_pay：虚拟账户支付（写）。字段：appAmount, cardNo, appSheetNo(父单号), businType/remark/workday(可选)；customerNo 由上下文注入；cardNo 应传 subAccountNo。 | `-` |
| `trade_pay_callback` | `object` | 至少传一项 | trade.pay_callback：支付回写（写）。字段：appSheetSerialNo, payState, payFundCode/payResult/payTime(可选)。 | `-` |
| `trade_redeem_bulk_percent` | `object` | 至少传一项 | trade.redeem.bulk_percent：组合一键赎回（比例，写）。字段：subAccountNo, percent, displayBusinType, reference(可选，建议<=10字符)；customerNo 由上下文注入。 | `-` |
| `trade_redeem_bulk_custom` | `object` | 至少传一项 | trade.redeem.bulk_custom：组合一键赎回（自定义份额，写）。字段：subAccountNo, items(数组), displayBusinType, reference(可选，建议<=10字符)；items 子项见下方说明；customerNo 由上下文注入。 | `-` |
| `trade_revoke_union` | `object` | 至少传一项 | trade.revoke_union：统一撤单（写）。字段：isRevokedToCashBag, nonceStr, reference(建议<=10字符), appParentSerialNo, appTraceNo(可选), remark(可选)；仅支持父单号撤单，businType 固定 819；customerNo 由上下文注入。 | `-` |
| `trade_list` | `object` | 至少传一项 | trade.list：交易列表。字段：pageIndex, pageSize, queryReq(对象)；queryReq 子字段见下方说明；customerNo 由上下文注入。 | `-` |
| `trade_list_by_fund` | `object` | 至少传一项 | trade.list_by_fund：单基金交易列表。字段：pageIndex, pageSize, queryReq(对象)；queryReq 子字段见下方说明；customerNo 由上下文注入。 | `-` |
| `trade_detail` | `object` | 至少传一项 | trade.detail：交易详情。字段：bizSerialNo, bizTypeCode；customerNo 由上下文注入。 | `-` |
| `rebalance_preview` | `object` | 至少传一项 | rebalance.preview：调仓预览（trade）。字段：subAccountNo, amount, whType, managerRatios, reference(可选，建议<=10字符)；managerRatios 子项见下方说明；customerNo 由上下文注入；ratio 口径 0-1。 | `-` |

统一约束：上述 action 对象 `至少传一个`，无需在每行重复声明。

### subacc_create.info 字段建议（写接口建议完整传入）

| 字段 | 类型 | 必填 | 建议值/说明 |
|---|---|---|---|
| `customerNo` | `string` | 否（系统覆盖） | 由上下文注入，调用方可不传 |
| `name` | `string` | 是 | 组合名称 |
| `alias` | `string/null` | 否 | 组合别名，可空 |
| `state` | `integer` | 是 | 建议 `1` |
| `style` | `string` | 是 | 必须传枚举值，如 `S2` |
| `property` | `string` | 否 | 可传空字符串 `""` |
| `followedSubAccountNo` | `string/null` | 否 | 非跟投场景传 `null` |
| `followedCustomerNo` | `string/null` | 否 | 非跟投场景传 `null` |
| `customizeProperty` | `string` | 否 | 可传空字符串 `""` |
| `subAccountNoIdea` | `string` | 否 | 可传空字符串 `""` |
| `openState` | `integer` | 是 | 建议 `2` |
| `lastCloseTime` | `string/null` | 否 | 建议 `null` |
| `manualReviewState` | `integer` | 否 | 建议 `0` |
| `manualReviewField` | `string/null` | 否 | 建议 `null` |
| `isEnabled` | `integer` | 否 | 建议 `1` |
| `createTime` | `string` | 否 | 可省略（服务端生成/维护） |
| `updateTime` | `string` | 否 | 可省略（服务端生成/维护） |
| `type` | `integer` | 是 | 当前场景建议 `9` |
| `followFlag` | `integer` | 否 | 建议 `0` |
| `holdInterval` | `integer` | 否 | 建议 `0` |

### subacc_update.subAccountInfo 字段建议（建议完整回写）

| 字段 | 类型 | 必填 | 建议值/说明 |
|---|---|---|---|
| `customerNo` | `string` | 否（系统覆盖） | 由上下文注入，调用方可不传 |
| `subAccountNo` | `string` | 是 | 目标组合编号 |
| `name` | `string` | 是 | 组合名称 |
| `alias` | `string/null` | 否 | 组合别名，可空 |
| `state` | `integer` | 是 | 建议传当前状态（常见 `1`） |
| `style` | `string` | 是 | 必须传枚举值，如 `S2` |
| `property` | `string` | 否 | 可传空字符串 `""` |
| `followedSubAccountNo` | `string/null` | 否 | 非跟投场景传 `null` |
| `followedCustomerNo` | `string/null` | 否 | 非跟投场景传 `null` |
| `customizeProperty` | `string` | 否 | 可传空字符串 `""` |
| `subAccountNoIdea` | `string` | 否 | 可传空字符串 `""` |
| `openState` | `integer` | 是 | 建议传当前公开状态（常见 `2`） |
| `lastCloseTime` | `string/null` | 否 | 建议 `null` |
| `manualReviewState` | `integer` | 否 | 建议回写当前值 |
| `manualReviewField` | `string/null` | 否 | 建议回写当前值 |
| `isEnabled` | `integer` | 否 | 建议 `1` |
| `createTime` | `string` | 否 | 可省略（服务端生成/维护） |
| `updateTime` | `string` | 否 | 可省略（服务端生成/维护） |
| `type` | `integer` | 是 | 当前场景建议 `9` |
| `followFlag` | `integer` | 否 | 建议 `0` |
| `holdInterval` | `integer` | 否 | 建议 `0` |

### subacc_disband.subAccountInfo 字段建议（最小可用）

| 字段 | 类型 | 必填 | 建议值/说明 |
|---|---|---|---|
| `customerNo` | `string` | 否（系统覆盖） | 由上下文注入，调用方可不传 |
| `subAccountNo` | `string` | 是 | 待解散组合编号 |
| `name` | `string` | 否 | 组合名称，建议传 |
| `state` | `integer` | 是 | 当前状态，常见 `1` |
| `openState` | `integer` | 是 | 当前公开状态，常见 `2` |
| `type` | `integer` | 是 | 当前场景建议 `9` |

### trade_list.queryReq 字段建议

| 字段 | 类型 | 必填 | 建议值/说明 |
|---|---|---|---|
| `customerNo` | `string` | 否（系统覆盖） | 由上下文注入，调用方可不传 |
| `subAccountNo` | `string` | 是 | 组合编号 |

### trade_list_by_fund.queryReq 字段建议

| 字段 | 类型 | 必填 | 建议值/说明 |
|---|---|---|---|
| `customerNo` | `string` | 否（系统覆盖） | 由上下文注入，调用方可不传 |
| `subAccountNo` | `string` | 是 | 组合编号 |
| `fundCode` | `string` | 是 | 基金代码 |

### trade_buy_bulk_ratio_v2 字段建议

| 字段 | 类型 | 必填 | 建议值/说明 |
|---|---|---|---|
| `customerNo` | `string` | 否（系统覆盖） | 由上下文注入，调用方可不传 |
| `subAccountNo` | `string` | 是 | 组合编号 |
| `amount` | `number` | 是 | 申购总金额，业务侧通常建议 `>=100` |
| `ratios` | `array` | 是 | 比例列表，子项见下表 |
| `reference` | `string` | 否 | 建议 `<=10` 字符 |

`ratios` 子项：

| 字段 | 类型 | 必填 | 说明 |
|---|---|---|---|
| `fundCode` | `string` | 是 | 基金代码 |
| `ratio` | `number` | 是 | 比例口径 `0-1` |

### trade_buy_bulk_amount_v2 字段建议

| 字段 | 类型 | 必填 | 建议值/说明 |
|---|---|---|---|
| `customerNo` | `string` | 否（系统覆盖） | 由上下文注入，调用方可不传 |
| `subAccountNo` | `string` | 是 | 组合编号 |
| `amount` | `number` | 是 | 申购总金额，需等于各 `itemAmount` 之和，业务侧通常建议 `>=100` |
| `items` | `array` | 是 | 金额列表，子项见下表 |
| `reference` | `string` | 否 | 建议 `<=10` 字符 |

`items` 子项：

| 字段 | 类型 | 必填 | 说明 |
|---|---|---|---|
| `fundCode` | `string` | 是 | 基金代码 |
| `itemAmount` | `number` | 是 | 该基金买入金额 |

### trade_redeem_bulk_custom.items 字段建议

| 字段 | 类型 | 必填 | 说明 |
|---|---|---|---|
| `fundCode` | `string` | 是 | 基金代码 |
| `itemVol` | `number` | 是 | 赎回份额 |

### rebalance_preview.managerRatios 字段建议

| 字段 | 类型 | 必填 | 说明 |
|---|---|---|---|
| `fundCode` | `string` | 是 | 基金代码 |
| `ratio` | `number` | 是 | 比例口径 `0-1` |

## 问句示例

| 类型 | query |
|----|----|
| 查询 模拟组合管理与交易skill | 帮我调用 MODEL_PORTFOLIO |
| 按示例参数调用 | 使用 MODEL_PORTFOLIO，参数参考请求示例 |
| 查询结果解释 | 帮我读取 MODEL_PORTFOLIO 的返回结果并解释关键字段 |

## 接口结果释义

### 一、业务结果根节点 (`data.raw_result.body`)

以下字段位于统一网关返回中的 `data.raw_result.body`，是实际业务结果的根节点。

| 字段路径 | 类型 | 核心释义 |
|----|----|----|
| `response` | object | 接口原始响应对象 |

### 二、核心字段说明

以下字段说明均面向 `data.raw_result.body`，不展开服务端内部编排、上下游映射和调试字段。

| 字段 Key | 含义说明 |
| --- | --- |
| `success` | workflow 是否整体成功 |
| `data.action` | 本次意图说明（仅提示用） |
| `data.steps` | 各 action 对应 step 的执行结果（含 skipped/success/status_code/body/error）。其中 body 通常含 succeed/result/message/errorCode/codeMessage。 |
| `data.steps.subacc_list.body.result` | 组合列表：每项含 customerNo/subAccountNo/subAccountName/state/openFlag/type 等 |
| `data.steps.subacc_detail.body.result` | 组合详情：含 subAccountName/state/openFlag/createTime 等 |
| `data.steps.subacc_create.body.result.subAccountInfo.subAccountNo` | 创建组合后返回的新 subAccountNo |
| `data.steps.subacc_update.body.result.subAccountInfo` | 更新组合后的 subAccountInfo（建议完整回写 state/openState 等字段） |
| `data.steps.subacc_disband.body.result.subAccountInfo.state` | 解散后组合状态（常见从 1 变为 2） |
| `data.steps.subacc_hold.body.result.dailyClassfyFundHoldList` | 组合持仓列表（可能为空） |
| `data.steps.subacc_profit_daily.body.result.dailyProfitList` | 每日收益列表（分页） |
| `data.steps.subacc_profit_monthly.body.result.monthlyIncome` | 月度收益列表（注意 startTime/endTime 入参格式 yyyy-MM-dd HH:mm:ss） |
| `data.steps.subacc_profit_interval_detail.body.result.graphSpotList` | 收益曲线点位列表（可能为空） |
| `data.steps.subacc_profit_drawdown.body.result.historyDrawDown` | 历史回撤信息（可能为 null） |
| `data.steps.rebalance_record_list.body.result.result` | 调仓/仓位变动记录列表（web）。endTime 若传必须 yyyy-MM-dd HH:mm:ss |
| `data.steps.trade_init.body.result` | 交易初始化结果（通常为 true） |
| `data.steps.asset_by_customer.body.result` | 客户维度资产概览（每个 subAccNo 一条） |
| `data.steps.asset_by_sub.body.result.subAssetPreview` | 子账户资产预览（assetValue/dailyProfit/stayWayCount 等） |
| `data.steps.rebalance_expected_ratio.body.result.assetRatio` | 预期持仓占比列表（ratio 口径 0-1） |
| `data.steps.trade_buy_bulk_ratio.body.result.bizAppList` | 批量买入回包（子单列表，含 parentAppSheetSerialNo/appSheetSerialNo/appState/traceNo 等） |
| `data.steps.trade_buy_bulk_amount.body.result.bizAppList` | 批量买入（自定义金额）回包（同样返回 bizAppList） |
| `data.steps.trade_buy_bulk_ratio_v2.body.result.bizAppList` | 批量买入V2（比例）回包（同样返回 bizAppList，另有 unsupportedFundCodes） |
| `data.steps.trade_buy_bulk_amount_v2.body.result.bizAppList` | 批量买入V2（自定义金额）回包（同样返回 bizAppList，另有 unsupportedFundCodes） |
| `data.steps.trade_vcard_pay.body.result` | 手动虚拟账户支付结果（通常为 true/false）。当前联调结论：cardNo 应传 subAccountNo。 |
| `data.steps.trade_vcard_pay_auto_amount.body.result` | 金额买入链路自动触发的虚拟账户支付结果（通常为 true/false） |
| `data.steps.trade_vcard_pay_auto_ratio.body.result` | 比例买入链路自动触发的虚拟账户支付结果（通常为 true/false） |
| `data.steps.trade_vcard_pay_auto_amount_v2.body.result` | 金额买入V2链路自动触发的虚拟账户支付结果（通常为 true/false） |
| `data.steps.trade_vcard_pay_auto_ratio_v2.body.result` | 比例买入V2链路自动触发的虚拟账户支付结果（通常为 true/false） |
| `data.steps.trade_pay_callback.body.result` | 手动支付回写结果对象，通常为 BizAppResp 或布尔成功结果 |
| `data.steps.trade_pay_callback_auto_amount.body.result` | 金额买入链路自动触发的支付回写结果对象 |
| `data.steps.trade_pay_callback_auto_ratio.body.result` | 比例买入链路自动触发的支付回写结果对象 |
| `data.steps.trade_pay_callback_auto_amount_v2.body.result` | 金额买入V2链路自动触发的支付回写结果对象 |
| `data.steps.trade_pay_callback_auto_ratio_v2.body.result` | 比例买入V2链路自动触发的支付回写结果对象 |
| `data.steps.trade_redeem_bulk_percent.body.result.bulkRedeemList` | 批量赎回回包（bulkRedeemList，每项含 businAppList） |
| `data.steps.trade_revoke_union.body.result.revokeState` | 撤单是否成功（true/false） |
| `data.steps.trade_list.body.result.queryResp` | 交易列表（queryResp，每项含 bizSerialNo/bizTypeCode/appState/onWay/appTime 等） |
| `data.steps.trade_list_by_fund.body.result.queryResp` | 单基金交易列表（queryResp） |
| `data.steps.trade_detail.body.result.canRevoke` | 交易详情是否可撤单 |
| `data.steps.rebalance_preview.body.result.fundPreviewList` | 调仓预览列表（fundPreviewList；managerRatios.ratio 口径 0-1） |

## 交互规范

1. 优先检查环境变量 `TTFUND_APIKEY`。
2. 若环境变量存在，则直接继续调用接口。
3. 若环境变量不存在，必须中断当前调用，并强制提示用户先完成 apikey 配置。
4. 引导文案必须明确包含：
   - 环境变量名：`TTFUND_APIKEY`
   - apikey 获取路径：`天天基金搜索 skills`
5. 每次请求都必须带上 `skill_id` 和 `_skill_version`。
6. `_skill_version` 固定使用当前安装版本：`1.0.0`。
7. 若缺少必填参数，应提示用户补充 `subacc_list 或 subacc_detail 或 subacc_create 或 subacc_update 或 subacc_disband 或 subacc_validate 或 subacc_hold 或 subacc_profit_daily 或 subacc_profit_monthly 或 subacc_profit_interval_detail 或 subacc_profit_drawdown 或 rebalance_record_list 或 trade_init 或 asset_by_customer 或 asset_by_sub 或 rebalance_expected_ratio 或 trade_buy_bulk_ratio 或 trade_buy_bulk_amount 或 trade_buy_bulk_ratio_v2 或 trade_buy_bulk_amount_v2 或 trade_vcard_pay 或 trade_pay_callback 或 trade_redeem_bulk_percent 或 trade_redeem_bulk_custom 或 trade_revoke_union 或 trade_list 或 trade_list_by_fund 或 trade_detail 或 rebalance_preview（至少传一个）`。
8. 返回结果时，应优先提炼核心信息，而不是直接原样堆砌所有字段。
9. 结果解释顺序必须是：先看业务结果，再看 `version_info`，最后决定是否追加升级建议。

## 输出建议

返回时优先展示：
- `success`
- `data.action`
- `data.steps`
- `data.steps.subacc_list.body.result`
- `data.steps.subacc_detail.body.result`
- `data.steps.subacc_create.body.result.subAccountInfo.subAccountNo`
- `data.steps.subacc_update.body.result.subAccountInfo`
- `data.steps.subacc_disband.body.result.subAccountInfo.state`

如需结构化输出，建议包含两部分：

- `business_result`：对应 `data.raw_result.body` 的核心业务结果
- `explanation_document`：对关键字段和结果差异的说明

说明：统一网关还可能返回少量辅助信息，用于调试、排错或版本提示；用户文档默认不展开这些字段，请以 `data.raw_result.body` 为准。

后处理要求：

- 若 `data.version_info.is_outdated = true`，先完成本次结果回答，再附上一句简洁升级提醒。
- 若接口返回升级导向错误，不要重复盲重试，也不要误判为普通网络问题，应直接提示用户升级 skill。
- 若接口返回普通业务错误且没有版本归因信号，则按原有逻辑处理，不额外渲染升级提示。

## 错误处理

- 若缺少 apikey，应提示用户：
  - `当前未检测到 TTFUND_APIKEY，请先前往天天基金搜索 skills 获取 apikey，并在本机配置该环境变量后重试。`
- 若缺少 `_skill_version`，应提示用户：
  - `当前安装的 skill 可能为旧版本，未携带版本信息。请升级到最新版本 1.0.0 后重试。`
- 若 `_skill_version` 为空或无效，应提示用户：
  - `当前安装的 skill 版本信息无效，可能为旧版本或安装不完整。请升级到最新版本 1.0.0 后重试。`
- 若 HTTP 请求失败、超时或返回非 2xx 状态码，应提示用户：
  - `模拟组合管理与交易skill服务暂时不可用，请稍后重试。`
- 若返回 `version_info` 表示本地版本落后，应优先提示用户尽快升级 skill。
- 若版本落后且本次错误属于参数缺失、字段不兼容或调用协议不匹配，应优先提示用户先升级 skill 再重试。
- 若业务成功字段 `success` 校验失败，则视为业务失败：
  - 简要说明错误信息
  - 不自行猜测结果或伪造成功
- 若核心返回数据为空，应提示用户检查输入参数是否正确。

## 安全与边界

- 该 Skill 返回的是 `模拟组合管理与交易skill` 对应的业务数据，请按业务场景谨慎使用。
- 返回内容仅用于当前用户请求的查询与分析，不应伪造结果或输出未验证内容。
<<<<<<< HEAD
=======

---

### 10. 天天基金自选查询skill 详细说明

---

请为我安装如下skill

## name:

天天基金自选查询skill

## version:

1.0.0

## description:

本 Skill 基于**fund**构建，支持通过**自然语言**实现以下功能：
- 调用 `FUND_FAVOR_ZX` 对应的核心能力
- 当前发布版本为 `1.0.0`，调用时必须携带 `_skill_version`
- 用于查询用户的基金自选数据，支持获取自选列表、分组信息，可用于自选页展示、分组管理、用户偏好分析以及与基金详情页联动
- 输出适合阅读和进一步分析的结构化结果

---

# 天天基金自选查询skill

通过**自然语言**或结构化参数调用 `FUND_FAVOR_ZX` 对应能力，接口返回 JSON 格式内容。

- 当前 skill 版本：`1.0.0`

## 使用方式

1. 在调用任何接口前，必须先检查本地环境变量 `TTFUND_APIKEY` 是否存在。
2. 若本地已存在 `TTFUND_APIKEY`，则直接使用该 apikey 发起请求。
3. 若本地不存在 `TTFUND_APIKEY`，必须强制引导用户先配置 apikey，不得跳过。
4. apikey 获取路径：
   - 打开 **天天基金**
   - 搜索 **skills**
   - 在对应 Skills 页面获取 `天天基金自选查询skill` 对应的 apikey
5. 若缺少 apikey，应提示：
   - `当前未检测到 TTFUND_APIKEY，请先前往天天基金搜索 skills 获取 apikey，并在本机配置该环境变量后重试。`
6. 每次请求体都必须同时携带 `skill_id` 和 `_skill_version`。

## 最小调用示例

```bash
curl --location 'https://skills.tiantianfunds.com/ai-smart-skill-service/openapi/skill/invoke' \
--header "X-API-Key: $TTFUND_APIKEY" \
--header 'Content-Type: application/json' \
--data '{
  "skill_id": "FUND_FAVOR_ZX",
  "_skill_version": "1.0.0"
}'
```

## 请求参数说明

| 请求字段 | 类型 | 必填 | 说明 |
|---|---|---|---|
| `requestType` | `integer` | 系统注入 | 查询范围类型，默认 `7`（`4+2+1`） |
| `passportid` | `string` | 系统注入 | 用户身份标识 |
| `authkey` | `string` | 系统注入 | 下游鉴权凭证 |

## 返回关键字段

| 字段路径 | 含义 |
|---|---|
| `data.zxActionResponse.zxlist` | 自选基金列表 |
| `data.groupResponse.data` | 自选分组列表 |
| `data.subAccResponses` | 组合/子账户响应列表 |
| `success` | 接口是否成功 |
| `errorCode` | 业务错误码，`0` 表示成功 |
>>>>>>> master
