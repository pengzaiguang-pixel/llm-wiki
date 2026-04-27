#!/bin/bash

# ETF 回测技能（基于天天基金 openapi + 组合策略评估框架）
# 输入：回测 515170
# 输出：3n/5n/10n 的基础指标 + 按组合策略评估框架的综合评分

set -euo pipefail

# 接收整段查询（避免只取到第一个词）
QUERY="$*"

# 获取脚本所在目录的绝对路径
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# 从脚本目录向上三级到达项目根目录
ENV_FILE="$SCRIPT_DIR/../../../.env"
if [ -f "$ENV_FILE" ]; then
  # shellcheck disable=SC2046
  export $(grep -v '^#' "$ENV_FILE" | xargs)
fi

# 检查API密钥是否设置
if [ -z "${TTFUND_APIKEY:-}" ]; then
  echo "⚠️ 未检测到环境变量 TTFUND_APIKEY（未从环境变量或 $ENV_FILE 读取到）。" >&2
  echo "请先在项目根目录创建/更新 .env：TTFUND_APIKEY=... 然后重启 Claude Code。" >&2
  exit 1
fi

# 解析 ETF 代码：从 QUERY 中提取 6 位数字
if [[ ! "$QUERY" =~ ([0-9]{6}) ]]; then
  echo "用法：回测 <6位ETF代码>（例如：回测 515170）" >&2
  exit 1
fi
ETF_CODE="${BASH_REMATCH[1]}"

RF=0.02

# 拉取净值序列（优先 LJJZ，缺失用 DWJZ）并计算指标及评分
python - <<PY
# -*- coding: utf-8 -*-
import os, json, subprocess, math, statistics
from datetime import datetime, timedelta

API_KEY=os.environ["TTFUND_APIKEY"]
ETF_CODE="${ETF_CODE}"
RF=float("${RF}")

def fetch(range_val: str):
    payload={"skill_id":"FUND_NAV_INFO","_skill_version":"1.0.0","fund_id":ETF_CODE,"range":range_val}
    cmd=["curl","-s","-X","POST","https://skills.tiantianfunds.com/ai-smart-skill-service/openapi/skill/invoke",
         "-H",f"X-API-Key: {API_KEY}","-H","Content-Type: application/json",
         "-d",json.dumps(payload,ensure_ascii=False)]
    obj=json.loads(subprocess.check_output(cmd, text=True, errors="ignore"))
    body=obj["data"]["raw_result"]["body"]
    items=body.get("data",{}).get("nav_history",{}).get("items",[])
    items=sorted(items, key=lambda x: x["FSRQ"])
    dates=[]
    prices=[]
    for it in items:
        lj=(it.get("LJJZ") or "").strip()
        dw=(it.get("DWJZ") or "").strip()
        v=lj or dw
        if not v:
            continue
        dates.append(datetime.strptime(it["FSRQ"],"%Y-%m-%d"))
        prices.append(float(v))
    return dates, prices

def calculate_max_dd_and_recovery_time(dates, prices):
    """计算最大回撤及修复时间"""
    peak = prices[0]
    max_dd = 0.0
    dd_start_date = dates[0]
    dd_end_date = dates[0]
    recovery_start_date = None

    for i, price in enumerate(prices):
        if price > peak:
            peak = price
            recovery_start_date = dates[i]  # 从新高点开始计算回撤
        else:
            dd = price / peak - 1
            if dd < max_dd:
                max_dd = dd
                dd_start_date = dates[i]

    # 计算修复时间：从最低点回到前期高点的时间
    lowest_idx = prices.index(min(prices))
    recovery_time_days = 0
    if lowest_idx < len(prices) - 1:
        lowest_price = prices[lowest_idx]
        for j in range(lowest_idx + 1, len(prices)):
            if prices[j] >= lowest_price * (1 - max_dd * 0.95):  # 回到回撤的95%位置认为已修复
                recovery_time_days = (dates[j] - dates[lowest_idx]).days
                break

    return max_dd, recovery_time_days, dd_start_date

def metrics(dates, prices):
    N=len(prices)
    if N < 3:
        return None
    rets=[prices[i]/prices[i-1]-1 for i in range(1,N)]

    maxdd, recovery_days, dd_start_date = calculate_max_dd_and_recovery_time(dates, prices)

    ann_ret=(prices[-1]/prices[0])**(252/(N-1))-1
    ann_vol=statistics.pstdev(rets)*math.sqrt(252)
    sharpe=(ann_ret-RF)/ann_vol if ann_vol and ann_vol != 0 else float("nan")

    # 计算卡玛比率
    kama = ann_ret / abs(maxdd) if maxdd != 0 else float("nan")

    # 估算单日最大亏损（取最小日收益率的绝对值）
    max_daily_loss = abs(min(rets)) if rets else 0

    return {
        "start": dates[0].date().isoformat(),
        "end": dates[-1].date().isoformat(),
        "N": N,
        "maxdd": maxdd,
        "ann_ret": ann_ret,
        "ann_vol": ann_vol,
        "sharpe": sharpe,
        "kama": kama,
        "max_daily_loss": max_daily_loss,
        "recovery_days": recovery_days,
    }

def calc_score(metrics_dict):
    """根据组合策略评估框架计算综合评分"""
    if not metrics_dict or any(not val or val != val for val in [metrics_dict.get('sharpe'), metrics_dict.get('kama')]):
        return None

    # 1. 收益能力 (30分)
    if metrics_dict['ann_ret'] >= 0.15:
        profit_score = 30
    elif metrics_dict['ann_ret'] >= 0.12:
        profit_score = 25
    elif metrics_dict['ann_ret'] >= 0.09:
        profit_score = 20
    elif metrics_dict['ann_ret'] >= 0.06:
        profit_score = 15
    elif metrics_dict['ann_ret'] >= 0.03:
        profit_score = 8
    else:
        profit_score = 0

    # 2. 风险控制 (35分)
    # 最大回撤 (20分)
    maxdd = abs(metrics_dict['maxdd'])
    if maxdd <= 0.08:
        maxdd_score = 20
    elif maxdd <= 0.12:
        maxdd_score = 16
    elif maxdd <= 0.18:
        maxdd_score = 12
    elif maxdd <= 0.25:
        maxdd_score = 6
    else:
        maxdd_score = 0

    # 波动率 (10分)
    vol = metrics_dict['ann_vol']
    if vol <= 0.08:
        vol_score = 10
    elif vol <= 0.12:
        vol_score = 8
    elif vol <= 0.18:
        vol_score = 5
    elif vol <= 0.25:
        vol_score = 2
    else:
        vol_score = 0

    # 单日最大亏损 (5分)
    daily_loss = metrics_dict['max_daily_loss']
    if daily_loss <= 0.015:
        daily_loss_score = 5
    elif daily_loss <= 0.03:
        daily_loss_score = 3
    else:
        daily_loss_score = 0

    risk_score = maxdd_score + vol_score + daily_loss_score

    # 3. 风险收益性价比 (25分)
    # 夏普比率 (15分)
    sharpe = metrics_dict['sharpe']
    if sharpe >= 1.5:
        sharpe_score = 15
    elif sharpe >= 1.2:
        sharpe_score = 12
    elif sharpe >= 0.9:
        sharpe_score = 9
    elif sharpe >= 0.6:
        sharpe_score = 5
    else:
        sharpe_score = 0

    # 卡玛比率 (10分)
    kama = metrics_dict['kama']
    if kama >= 1.5:
        kama_score = 10
    elif kama >= 1.2:
        kama_score = 8
    elif kama >= 0.9:
        kama_score = 6
    elif kama >= 0.6:
        kama_score = 3
    else:
        kama_score = 0

    ratio_score = sharpe_score + kama_score

    # 4. 长期稳健性 (10分)
    # 回撤修复时间 (5分)
    recovery_time_months = metrics_dict['recovery_days'] / 30  # 转换为月份
    if recovery_time_months <= 3:
        recovery_score = 5
    elif recovery_time_months <= 6:
        recovery_score = 4
    elif recovery_time_months <= 12:
        recovery_score = 2
    else:
        recovery_score = 0

    # 假设年度正收益占比为 80% (5分)
    annual_pos_ratio = 0.8  # 这里需要更复杂的计算逻辑，暂设定为0.8
    if annual_pos_ratio >= 1.0:
        annual_score = 5
    elif annual_pos_ratio >= 0.8:
        annual_score = 4
    elif annual_pos_ratio >= 0.6:
        annual_score = 2
    else:
        annual_score = 0

    stability_score = recovery_score + annual_score

    # 总分
    total_score = profit_score + risk_score + ratio_score + stability_score

    # 评级
    if total_score >= 90:
        rating = "顶级策略"
    elif total_score >= 80:
        rating = "优秀策略"
    elif total_score >= 70:
        rating = "良好策略"
    elif total_score >= 60:
        rating = "一般策略"
    elif total_score >= 50:
        rating = "较差策略"
    else:
        rating = "劣质策略"

    return {
        "profit_score": profit_score,
        "risk_score": risk_score,
        "ratio_score": ratio_score,
        "stability_score": stability_score,
        "total_score": total_score,
        "rating": rating
    }

def fmt_pct(x):
    if x != x:  # Check for NaN
        return "N/A"
    return f"{x*100:.2f}%"

def fmt_num(x):
    if x != x:  # Check for NaN
        return "N/A"
    return f"{x:.2f}"

results=[]
for rv in ["3n","5n","10n"]:
    d,p=fetch(rv)
    m=metrics(d,p)
    if not m:
        continue
    s=calc_score(m)
    results.append((rv,m,s))

if not results:
    print(f"未能获取 {ETF_CODE} 的净值序列，请检查代码或稍后再试。")
    raise SystemExit(2)

print(f"ETF代码：{ETF_CODE}")
print(f"口径：累计净值(LJJZ)优先，缺失用单位净值(DWJZ)补；252交易日年化；无风险利率 rf=2%")
print("\\n区间\\t起止日期\\t\\t样本数\\t最大回撤\\t年化收益\\t年化波动\\t夏普\\t卡玛")
for rv,m,s in results:
    print(
        f"{rv}\\t{m['start']}~{m['end']}\\t{m['N']}\\t"
        f"{fmt_pct(m['maxdd'])}\\t{fmt_pct(m['ann_ret'])}\\t{fmt_pct(m['ann_vol'])}\\t"
        f"{fmt_num(m['sharpe'])}\\t{fmt_num(m['kama'])}"
    )

# 输出专业资产配置分析
if results:
    print(f"\\n{'='*60}")
    print(f"策略总结与洞见:")
    print(f"{'='*60}")

    # 按照20年资产配置专家的视角分析
    print(f"  \\n{ETF_CODE}资产配置专家分析:")

    # 提取时间序列数据
    time_periods = []
    returns = []
    vols = []
    maxdds = []
    periods_labels = []

    for rv,m,s in results:
        if m:
            time_periods.append(rv)
            returns.append(m['ann_ret'])
            vols.append(m['ann_vol'])
            maxdds.append(abs(m['maxdd']))
            periods_labels.append(f"{rv}({m['start']}~{m['end']})")

    if len(time_periods) > 0:
        # 分析波动率与收益的关系变化
        print(f"  收益-波动率动态关系:")

        # 计算不同时间周期的收益波动率比率变化
        for i in range(len(time_periods)):
            rv, m, s = results[i]
            if m:
                risk_return_ratio = m['ann_ret'] / m['ann_vol'] if m['ann_vol'] != 0 else 0
                print(f"    {rv}: 收益率={m['ann_ret']:.2%}, 波动率={m['ann_vol']:.2%}, 收益风险比={risk_return_ratio:.2f}")

        # 长期趋势分析
        if len(returns) >= 2:
            # 比较短期vs长期收益变化
            short_term_ret = returns[0]  # 假设第一个是短期（如3n）
            long_term_ret = returns[-1]  # 假设最后一个是长期（如10n）

            if len(returns) > 1:
                print(f"  \\n资产成熟度分析:")
                if short_term_ret > long_term_ret:
                    print(f"    短期表现优于长期：可能反映近期市场热点或资产周期性机会，但长期可持续性存疑")
                elif short_term_ret < long_term_ret:
                    print(f"    长期表现优于短期：显示出良好的资产复利效应，适合长期持有策略")
                else:
                    print(f"    短期与长期表现相近：资产稳定性较高，收益模式相对固定")

            # 波动率收敛性分析
            print(f"  \\n波动率变化分析:")
            vol_trend = "下降" if vols[-1] < vols[0] else "上升" if vols[-1] > vols[0] else "稳定"
            if vol_trend == "下降":
                print(f"    波动率呈下降趋势：资产逐渐成熟稳定，市场对其定价趋于一致")
            elif vol_trend == "上升":
                print(f"    波动率呈上升趋势：资产面临更多不确定性，可能受外部因素影响加剧")
            else:
                print(f"    波动率保持稳定：资产风险特征固化，符合成熟资产特点")

            # 风险暴露度分析
            print(f"  \\n风险暴露度评估:")
            maxdd_trend = "收敛" if maxdds[-1] < maxdds[0] else "放大" if maxdds[-1] > maxdds[0] else "稳定"
            if maxdd_trend == "收敛":
                print(f"    最大回撤呈收敛趋势：风险管理机制逐步完善，下行风险控制能力提升")
            elif maxdd_trend == "放大":
                print(f"    最大回撤呈放大趋势：资产面临更大下行压力，需关注风险敞口")
            else:
                print(f"    最大回撤保持稳定：资产风险暴露度一致，投资者应有相应心理准备")

        # 综合资产属性判断
        print(f"  \\n资产属性判定:")
        avg_ret = sum(returns) / len(returns)
        avg_vol = sum(vols) / len(vols)

        if avg_ret > 0.12 and avg_vol < 0.15:
            asset_type = "优质成长型资产"
            strategy = "可适度增加配置比例，重点关注其增长潜力"
        elif avg_ret > 0.08 and avg_vol >= 0.15 and avg_vol <= 0.25:
            asset_type = "平衡型资产"
            strategy = "适合作为核心持仓，需搭配风险对冲工具"
        elif avg_ret > 0.08 and avg_vol > 0.25:
            asset_type = "高风险高收益资产"
            strategy = "适合激进型投资者，需严格控制仓位并设置止损"
        elif avg_ret <= 0.08 and avg_vol < 0.10:
            asset_type = "防御型资产"
            strategy = "适合熊市配置或作为投资组合稳定器"
        else:
            asset_type = "风险资产"
            strategy = "收益风险比欠佳，建议观望或寻找替代品种"

        print(f"    判定为：{asset_type}")
        print(f"    建议策略：{strategy}")

        # 配置建议
        print(f"  \\n资产配置建议:")
        if len(returns) > 1 and returns[0] > returns[-1]:
            print(f"    近期表现优于长期：可考虑战术性增配，但需警惕追高风险")
        elif len(returns) > 1 and returns[0] < returns[-1]:
            print(f"    长期趋势向好：适合定投方式逐步建仓，享受复利效应")
        else:
            print(f"    表现相对稳定：可作为核心持仓的组成部分")

        # 时机选择
        print(f"  \\n时机选择建议:")
        current_sharpe = results[0][1]['sharpe'] if results[0][1] else 0
        if current_sharpe > 1.0:
            timing_suggestion = "当前风险调整后收益较佳，可考虑适度增配"
        elif current_sharpe > 0.5:
            timing_suggestion = "当前风险调整后收益一般，按计划配置即可"
        elif current_sharpe > 0:
            timing_suggestion = "当前风险调整后收益偏低，可等待更好时机"
        else:
            timing_suggestion = "当前处于亏损状态，建议暂缓配置或降低仓位"

        print(f"    {timing_suggestion}")
PY
