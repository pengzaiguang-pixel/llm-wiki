#!/bin/bash

# 天天基金技能执行脚本
# 根据用户查询执行相应的API调用

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
if [ -z "$TTFUND_APIKEY" ]; then
  echo "⚠️ 未检测到环境变量 TTFUND_APIKEY（未从环境变量或 $ENV_FILE 读取到）。"
  echo "请先在项目根目录创建/更新 .env：TTFUND_APIKEY=... 然后重启 Claude Code。"
  exit 1
fi

echo "✅ 检测到环境变量 TTFUND_APIKEY，正在使用..."

# 根据查询类型选择API端点
if [[ "$QUERY" == *"基金信息"* || "$QUERY" == *"基金基本情况"* ]]; then
  echo "🔍 识别为基金信息查询"
  FUND_CODE="000001"  # 默认使用华夏成长混合基金代码

  # 如果查询中包含具体的基金名称，可以进一步解析
  if [[ "$QUERY" == *"华夏成长混合"* ]]; then
    FUND_CODE="000001"
  elif [[ "$QUERY" =~ ([0-9]{6}) ]]; then
    FUND_CODE="${BASH_REMATCH[1]}"
  fi

  echo "📊 正在查询基金代码: $FUND_CODE"

  RESULT=$(curl -s -X POST 'https://skills.tiantianfunds.com/ai-smart-skill-service/openapi/skill/invoke' \
    -H "X-API-Key: $TTFUND_APIKEY" \
    -H "Content-Type: application/json" \
    -d "{\"skill_id\": \"FUND_BASE_INFOS\", \"_skill_version\": \"1.1.0\", \"fcode\": \"$FUND_CODE\"}")

  echo "$RESULT" | python -m json.tool

elif [[ "$QUERY" == *"基金经理"* || "$QUERY" == *"张坤"* || "$QUERY" == *"葛兰"* ]]; then
  echo "🔍 识别为基金经理查询"
  MANAGER_NAME="张坤"  # 默认查询张坤

  if [[ "$QUERY" == *"葛兰"* ]]; then
    MANAGER_NAME="葛兰"
  elif [[ "$QUERY" =~ (张坤|葛兰|刘彦春|萧楠|王宗合|周应波|冯波|胡昕炜|刘格菘|邬传雁|杜猛|杨浩|赵枫|李晓西|王园园|郑煜|孙彬|韩威俊|何帅|陈皓|付浩|杨佳庆|苗宇|王海涛|林英睿|唐颐恒|笪玺|邓栋|韩冰|刘苏|陆剑飞|谭丽|姜诚|程洲|王健|颜燕|牟星海|王延平|张明|陈鹏扬|王大鹏|张清华|李博|蔡目荣|方纬|郑泽鸿|李晓星|张羽翔|赵强|盛骅|曾豪|孙迪|郑澄然|钟帅|王栩|李阳|崔宸龙|杨宇|陈金伟|翁启森|刘潇|郑青|张雅君|饶刚|吴越|左金保|钱睿南|魏伟|何帅|陈良栋|韩创|黄海|丘栋荣|肖觅|杨欢|刘莉莉|蒋璆|刘洋|陆彬|陈思郁|戴庞龙|赵诣|沈楠|张仲维|刘辉|许文星|袁芳|王克玉|祁禾|郑泽鸿|焦巍|李化松|赵晓东|梅雷德|施成|刘畅畅|刘格菘|吴培文|郑丹琳|陈涛|王健|李巍|杨瑨|郑泽鸿|李元博|栾江伟|彭凌志|郭堃|韩冬|陈鹏扬|王大鹏|刘晓|陈军|王海涛|林英睿|郑澄然|钟帅|郑青|饶刚|吴越|左金保|钱睿南|魏伟|何帅|陈良栋|韩创|黄海|丘栋荣|肖觅|杨欢|刘莉莉|蒋璆|刘洋|陆彬|陈思郁|戴庞龙|赵诣|沈楠|张仲维|刘辉|许文星|袁芳|王克玉|祁禾|焦巍|李化松|赵晓东|梅雷德|施成|刘畅畅|吴培文|郑丹琳|陈涛|李巍|杨瑨|李元博|栾江伟|彭凌志|郭堃|韩冬) ]]; then
    MANAGER_NAME="${BASH_REMATCH[1]}"
  fi

  echo "📊 正在查询基金经理: $MANAGER_NAME"

  RESULT=$(curl -s -X POST 'https://skills.tiantianfunds.com/ai-smart-skill-service/openapi/skill/invoke' \
    -H "X-API-Key: $TTFUND_APIKEY" \
    -H "Content-Type: application/json" \
    -d "{\"skill_id\": \"FUND_MANAGER_INFO\", \"_skill_version\": \"1.0.0\", \"manager_name\": \"$MANAGER_NAME\"}")

  echo "$RESULT" | python -m json.tool

elif [[ "$QUERY" == *"选基"* || "$QUERY" == *"收益率最高"* || "$QUERY" == *"涨跌幅排序"* ]]; then
  echo "🔍 识别为条件选基查询"

  RESULT=$(curl -s -X POST 'https://skills.tiantianfunds.com/ai-smart-skill-service/openapi/skill/invoke' \
    -H "X-API-Key: $TTFUND_APIKEY" \
    -H "Content-Type: application/json" \
    -d "{\"skill_id\": \"FUND_CONDITION_SELECT\", \"_skill_version\": \"1.1.0\", \"pageIndex\": 1, \"pageNum\": 5, \"pageType\": 1, \"orderField\": \"5_6_-1\"}")

  echo "$RESULT" | python -m json.tool

elif [[ "$QUERY" == *"持仓"* || "$QUERY" == *"重仓"* ]]; then
  echo "🔍 识别为基金持仓查询"
  FUND_ID="000001"  # 默认使用华夏成长混合基金代码

  if [[ "$QUERY" =~ ([0-9]{6}) ]]; then
    FUND_ID="${BASH_REMATCH[1]}"
  elif [[ "$QUERY" == *"华夏成长混合"* ]]; then
    FUND_ID="000001"
  fi

  echo "📊 正在查询基金持仓: $FUND_ID"

  RESULT=$(curl -s -X POST 'https://skills.tiantianfunds.com/ai-smart-skill-service/openapi/skill/invoke' \
    -H "X-API-Key: $TTFUND_APIKEY" \
    -H "Content-Type: application/json" \
    -d "{\"skill_id\": \"FUND_HOLDING_INFO\", \"_skill_version\": \"1.0.0\", \"fund_id\": \"$FUND_ID\", \"holding_type\": \"all\"}")

  echo "$RESULT" | python -m json.tool

elif [[ "$QUERY" == *"黄金"* || "$QUERY" == *"黄金行情"* ]]; then
  echo "🔍 识别为黄金行情查询"

  RESULT=$(curl -s -X POST 'https://skills.tiantianfunds.com/ai-smart-skill-service/openapi/skill/invoke' \
    -H "X-API-Key: $TTFUND_APIKEY" \
    -H "Content-Type: application/json" \
    -d "{\"skill_id\": \"FUND_HUAAN_GOLD_INFO\", \"_skill_version\": \"1.0.0\", \"query_scope\": \"all\"}")

  echo "$RESULT" | python -m json.tool

elif [[ "$QUERY" == *"净值"* ]]; then
  echo "🔍 识别为基金净值查询"
  FUND_ID="000001"  # 默认使用华夏成长混合基金代码

  if [[ "$QUERY" =~ ([0-9]{6}) ]]; then
    FUND_ID="${BASH_REMATCH[1]}"
  elif [[ "$QUERY" == *"华夏成长混合"* ]]; then
    FUND_ID="000001"
  fi

  RESULT=$(curl -s -X POST 'https://skills.tiantianfunds.com/ai-smart-skill-service/openapi/skill/invoke' \
    -H "X-API-Key: $TTFUND_APIKEY" \
    -H "Content-Type: application/json" \
    -d "{\"skill_id\": \"FUND_NAV_INFO\", \"_skill_version\": \"1.0.0\", \"fund_id\": \"$FUND_ID\", \"range\": \"n\"}")

  echo "$RESULT" | python -m json.tool

else
  echo "💡 无法识别查询意图，提供通用基金信息查询"
  echo "📝 支持的查询类型：基金信息、基金经理、条件选基、基金持仓、黄金行情、基金净值"
  echo "📝 示例查询：'查询华夏成长混合基金信息', '张坤管理的基金有哪些', '近一年收益率最高的5只基金'"
fi