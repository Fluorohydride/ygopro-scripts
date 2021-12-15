--min/max value
MIN_ID		=1000		--4 digits, by DataManager::GetDesc()
MAX_ID		=268435455	--28 bits, by DataManager::GetDesc()
MAX_COUNTER	=65535		--max number for adding/removing counters, by card::add_counter(), field::remove_counter()
--Locations 区域
LOCATION_DECK		=0x01		--卡组
LOCATION_HAND		=0x02		--手牌
LOCATION_MZONE		=0x04		--怪兽区
LOCATION_SZONE		=0x08		--魔陷区(0~4)+场地区(5)
LOCATION_GRAVE		=0x10		--墓地
LOCATION_REMOVED	=0x20		--除外区
LOCATION_EXTRA		=0x40		--额外
LOCATION_OVERLAY	=0x80		--超量素材
LOCATION_ONFIELD	=0x0c		--场上（LOCATION_MZONE+LOCATION_SZONE）
--Locations (for redirect) 若在重定向类效果中仅指定LOCATION_DECK则为弹回卡组顶部
LOCATION_DECKBOT	=0x10001	--弹回卡组底部
LOCATION_DECKSHF	=0x20001	--弹回卡组并洗牌
--Sequences (for Duel.SendtoDeck)
SEQ_DECKTOP			=0			--弹回卡组顶端
SEQ_DECKBOTTOM		=1			--弹回卡组底端
SEQ_DECKSHUFFLE		=2			--弹回卡组并洗牌（洗牌前暂时放在底端）
--Locations of spell cards
LOCATION_FZONE		=0x100		--场地区
LOCATION_PZONE		=0x200		--灵摆区
--Positions 表示形式
POS_FACEUP_ATTACK		=0x1	--表侧攻击
POS_FACEDOWN_ATTACK		=0x2	--(reserved)
POS_FACEUP_DEFENSE		=0x4	--表侧守备
POS_FACEDOWN_DEFENSE	=0x8	--里侧守备
POS_FACEUP				=0x5	--正面表示
POS_FACEDOWN			=0xa	--背面表示
POS_ATTACK				=0x3	--攻击表示
POS_DEFENSE				=0xc	--守备表示
NO_FLIP_EFFECT			=0x10000--不发动反转效果
--Types 卡片类型
TYPE_MONSTER		=0x1		--怪兽卡
TYPE_SPELL			=0x2		--魔法卡
TYPE_TRAP			=0x4		--陷阱卡
TYPE_NORMAL			=0x10		--通常怪兽
TYPE_EFFECT			=0x20		--效果
TYPE_FUSION			=0x40		--融合
TYPE_RITUAL			=0x80		--仪式
TYPE_TRAPMONSTER	=0x100		--陷阱怪兽
TYPE_SPIRIT			=0x200		--灵魂
TYPE_UNION			=0x400		--同盟
TYPE_DUAL			=0x800		--二重
TYPE_TUNER			=0x1000		--调整
TYPE_SYNCHRO		=0x2000		--同调
TYPE_TOKEN			=0x4000		--衍生物
TYPE_QUICKPLAY		=0x10000	--速攻
TYPE_CONTINUOUS		=0x20000	--永续
TYPE_EQUIP			=0x40000	--装备
TYPE_FIELD			=0x80000	--场地
TYPE_COUNTER		=0x100000	--反击
TYPE_FLIP			=0x200000	--翻转
TYPE_TOON			=0x400000	--卡通
TYPE_XYZ			=0x800000	--超量
TYPE_PENDULUM		=0x1000000	--灵摆
TYPE_SPSUMMON		=0x2000000	--特殊召唤
TYPE_LINK			=0x4000000	--连接
--组合类型
TYPES_TOKEN_MONSTER	=0x4011
TYPES_NORMAL_TRAP_MONSTER	=0x111
TYPES_EFFECT_TRAP_MONSTER	=0x121
--Attributes 属性
ATTRIBUTE_ALL		=0x7f		--All
ATTRIBUTE_EARTH		=0x01		--地
ATTRIBUTE_WATER		=0x02		--水
ATTRIBUTE_FIRE		=0x04		--炎
ATTRIBUTE_WIND		=0x08		--风
ATTRIBUTE_LIGHT		=0x10		--光
ATTRIBUTE_DARK		=0x20		--暗
ATTRIBUTE_DIVINE	=0x40		--神
--Races 种族
RACE_ALL			=0x1ffffff	--全种族
RACE_WARRIOR		=0x1		--战士
RACE_SPELLCASTER	=0x2		--魔法师
RACE_FAIRY			=0x4		--天使
RACE_FIEND			=0x8		--恶魔
RACE_ZOMBIE			=0x10		--不死
RACE_MACHINE		=0x20		--机械
RACE_AQUA			=0x40		--水
RACE_PYRO			=0x80		--炎
RACE_ROCK			=0x100		--岩石
RACE_WINDBEAST		=0x200		--鸟兽
RACE_PLANT			=0x400		--植物
RACE_INSECT			=0x800		--昆虫
RACE_THUNDER		=0x1000		--雷
RACE_DRAGON			=0x2000		--龙
RACE_BEAST			=0x4000		--兽
RACE_BEASTWARRIOR	=0x8000		--兽战士
RACE_DINOSAUR		=0x10000	--恐龙
RACE_FISH			=0x20000	--鱼
RACE_SEASERPENT		=0x40000	--海龙
RACE_REPTILE		=0x80000	--爬虫类
RACE_PSYCHO			=0x100000	--念动力
RACE_DIVINE			=0x200000	--幻神兽
RACE_CREATORGOD		=0x400000	--创造神
RACE_WYRM			=0x800000	--幻龙
RACE_CYBERSE		=0x1000000	--电子界
--Reason 卡片到当前位置的原因
REASON_DESTROY		=0x1		--破坏
REASON_RELEASE		=0x2		--解放
REASON_TEMPORARY	=0x4		--暂时
REASON_MATERIAL		=0x8		--作为融合/同调/超量素材或用於儀式/升級召喚
REASON_SUMMON		=0x10		--召唤
REASON_BATTLE		=0x20		--战斗破坏
REASON_EFFECT		=0x40		--效果
REASON_COST			=0x80		--用於代價或無法支付代價而破壞
REASON_ADJUST		=0x100		--调整（御前试合）
REASON_LOST_TARGET	=0x200		--失去装备对象
REASON_RULE			=0x400		--规则
REASON_SPSUMMON		=0x800		--特殊召唤
REASON_DISSUMMON	=0x1000		--召唤失败
REASON_FLIP			=0x2000		--翻转
REASON_DISCARD		=0x4000		--丢弃
REASON_RDAMAGE		=0x8000		--回復轉換後的傷害
REASON_RRECOVER		=0x10000	--傷害轉換後的回復
REASON_RETURN		=0x20000	--回到墓地
REASON_FUSION		=0x40000	--用於融合召喚
REASON_SYNCHRO		=0x80000	--用於同调召喚
REASON_RITUAL		=0x100000	--用於仪式召喚
REASON_XYZ			=0x200000	--用於超量召喚
REASON_REPLACE		=0x1000000	--代替
REASON_DRAW			=0x2000000	--抽卡
REASON_REDIRECT		=0x4000000	--改变去向（大宇宙，带菌等）
REASON_REVEAL		=0x8000000	--翻开卡组（森罗）
REASON_LINK			=0x10000000	--用于连接召唤
REASON_LOST_OVERLAY =0x20000000	--超量素材随着超量怪兽离场
--Location Reason
LOCATION_REASON_TOFIELD		=0x1	--Duel.GetLocationCount()預設值,凱薩競技場
LOCATION_REASON_CONTROL		=0x2	--Card.IsControlerCanBeChanged()使用
--Summon Type --召唤类型
SUMMON_TYPE_NORMAL		=0x10000000 --通常召唤(EFFECT_SUMMON_PROC,EFFECT_SET_PROC 可用Value修改數值)
SUMMON_TYPE_ADVANCE		=0x11000000 --上级召唤
SUMMON_TYPE_DUAL		=0x12000000	--再度召唤（二重）
SUMMON_TYPE_FLIP		=0x20000000	--翻转召唤
SUMMON_TYPE_SPECIAL		=0x40000000	--特殊召唤(EFFECT_SPSUMMON_PROC,EFFECT_SPSUMMON_PROC_G 可用Value修改數值)
SUMMON_TYPE_FUSION		=0x43000000	--融合召唤
SUMMON_TYPE_RITUAL		=0x45000000	--仪式召唤
SUMMON_TYPE_SYNCHRO		=0x46000000	--同调召唤
SUMMON_TYPE_XYZ			=0x49000000	--超量召唤
SUMMON_TYPE_PENDULUM	=0x4a000000 --灵摆召唤
SUMMON_TYPE_LINK		=0x4c000000 --连接召唤
--Summon Value --特定的召唤方式
SUMMON_VALUE_SELF					=0x1	--自身效果或条件
SUMMON_VALUE_BLACK_GARDEN			=0x10	--黑色花园
SUMMON_VALUE_SYNCHRO_MATERIAL		=0x11	--特殊召唤并作为同调素材（黑羽-东云之东风检查）
SUMMON_VALUE_DARK_SANCTUARY			=0x12	--暗黑圣域
SUMMON_VALUE_MONSTER_REBORN			=0x13	--死者苏生（千年的启示）
SUMMON_VALUE_LV						=0x1000	--对应LV怪兽的效果
SUMMON_VALUE_GLADIATOR				=0x2000	--剑斗兽
SUMMON_VALUE_EVOLTILE				=0x4000	--进化虫
--Status	--卡片当前状态
STATUS_DISABLED				=0x0001		--效果被无效
STATUS_TO_ENABLE			=0x0002		--将变成有效
STATUS_TO_DISABLE			=0x0004		--将变成无效
STATUS_PROC_COMPLETE		=0x0008		--完成正规召唤（解除苏生限制）
STATUS_SET_TURN				=0x0010		--在本回合覆盖
STATUS_NO_LEVEL				=0x0020		--无等级
STATUS_BATTLE_RESULT		=0x0040		--傷害計算結果預計要破壞的怪獸
STATUS_SPSUMMON_STEP		=0x0080		--效果特召處理中
STATUS_FORM_CHANGED			=0x0100		--改变过表示形式
STATUS_SUMMONING			=0x0200		--召唤中
STATUS_EFFECT_ENABLED		=0x0400		--卡片準備就緒(不在移動、召喚、魔法陷阱發動中)
STATUS_SUMMON_TURN			=0x0800		--在本回合召喚/SET
STATUS_DESTROY_CONFIRMED	=0x1000		--破坏确定
STATUS_LEAVE_CONFIRMED		=0x2000		--連鎖處理完後送去墓地的魔法陷阱
STATUS_BATTLE_DESTROYED		=0x4000		--战斗破坏确定後尚未移動
STATUS_COPYING_EFFECT		=0x8000		--复制效果
STATUS_CHAINING				=0x10000	--正在連鎖串中
STATUS_SUMMON_DISABLED		=0x20000	--召唤无效後尚未移動
STATUS_ACTIVATE_DISABLED	=0x40000	--发动无效後尚未移動
STATUS_EFFECT_REPLACED		=0x80000	--效果被替代(红莲霸权)
STATUS_FUTURE_FUSION		=0x100000	--未来融合特殊召唤(不触发融合素材效果)
STATUS_ATTACK_CANCELED		=0x200000	--若其為攻擊者，則攻擊中止
STATUS_INITIALIZING			=0x400000	--初始化..
STATUS_TO_HAND_WITHOUT_CONFIRM	=0x800000	--非公开的卡被效果加入手卡但未给对方确认
STATUS_JUST_POS				=0x1000000	--已改變表示形式(用於STATUS_CONTINUOUS_POS判定)
STATUS_CONTINUOUS_POS		=0x2000000	--改變後再次設定成其他表示形式
STATUS_FORBIDDEN			=0x4000000	--不能play
STATUS_ACT_FROM_HAND		=0x8000000	--從手牌发动
STATUS_OPPO_BATTLE			=0x10000000	--和對手的怪兽戰鬥
STATUS_FLIP_SUMMON_TURN		=0x20000000	--在本回合反转召唤
STATUS_SPSUMMON_TURN		=0x40000000	--在本回合特殊召唤
--Assume
ASSUME_CODE			=1
ASSUME_TYPE			=2
ASSUME_LEVEL		=3
ASSUME_RANK			=4
ASSUME_ATTRIBUTE	=5
ASSUME_RACE			=6
ASSUME_ATTACK		=7
ASSUME_DEFENSE		=8
--Link Marker
LINK_MARKER_BOTTOM_LEFT		=0x001 -- ↙
LINK_MARKER_BOTTOM			=0x002 -- ↓
LINK_MARKER_BOTTOM_RIGHT	=0x004 -- ↘
LINK_MARKER_LEFT			=0x008 -- ←
LINK_MARKER_RIGHT			=0x020 -- →
LINK_MARKER_TOP_LEFT		=0x040 -- ↖
LINK_MARKER_TOP				=0x080 -- ↑
LINK_MARKER_TOP_RIGHT		=0x100 -- ↗
--Counter	--指示物
COUNTER_WITHOUT_PERMIT		=0x1000	--可以放置在非特定對象的指示物
COUNTER_NEED_ENABLE			=0x2000	--N/A
--Phase	--阶段
PHASE_DRAW			=0x01	--抽卡阶段
PHASE_STANDBY		=0x02	--准备阶段
PHASE_MAIN1			=0x04	--主要阶段1
PHASE_BATTLE_START	=0x08	--战斗阶段开始
PHASE_BATTLE_STEP	=0x10	--战斗步驟
PHASE_DAMAGE		=0x20	--伤害步驟
PHASE_DAMAGE_CAL	=0x40	--伤害计算时
PHASE_BATTLE		=0x80	--战斗阶段結束
PHASE_MAIN2			=0x100	--主要阶段2
PHASE_END			=0x200	--结束阶段
--Player	--玩家
PLAYER_NONE			=2		--2个玩家都不是
PLAYER_ALL			=3		--2个玩家都是
--Chain info	--连锁信息
CHAININFO_CHAIN_COUNT			=0x01	--连锁数
CHAININFO_TRIGGERING_EFFECT		=0x02	--连锁的效果
CHAININFO_TRIGGERING_PLAYER		=0x04	--连锁的玩家
CHAININFO_TRIGGERING_CONTROLER	=0x08	--连锁的卡的控制者
CHAININFO_TRIGGERING_LOCATION	=0x10	--连锁的位置
CHAININFO_TRIGGERING_SEQUENCE	=0x20	--连锁的位置的编号（指怪兽和魔陷区的格子）
CHAININFO_TARGET_CARDS			=0x40	--连锁的效果的对象（以下3个需要在target函数里设置）
CHAININFO_TARGET_PLAYER			=0x80	--连锁的效果的对象（玩家）
CHAININFO_TARGET_PARAM			=0x100	--连锁的效果的参数值
CHAININFO_DISABLE_REASON		=0x200	--无效的原因
CHAININFO_DISABLE_PLAYER		=0x400	--无效的玩家
CHAININFO_CHAIN_ID				=0x800	--连锁ID
CHAININFO_TYPE					=0x1000	--连锁类型
CHAININFO_EXTTYPE				=0x2000	--连锁额外类型
CHAININFO_TRIGGERING_POSITION	=0x4000	--连锁发生时的表示形式
CHAININFO_TRIGGERING_CODE		=0x8000	--连锁发生时的密码
CHAININFO_TRIGGERING_CODE2		=0x10000	--连锁发生时的其他密码
CHAININFO_TRIGGERING_LEVEL		=0x40000	--连锁发生时的等级
CHAININFO_TRIGGERING_RANK		=0x80000	--连锁发生时的阶级
CHAININFO_TRIGGERING_ATTRIBUTE	=0x100000	--连锁发生时的属性
CHAININFO_TRIGGERING_RACE		=0x200000	--连锁发生时的种族
CHAININFO_TRIGGERING_ATTACK		=0x400000	--连锁发生时的攻击力
CHAININFO_TRIGGERING_DEFENSE	=0x800000	--连锁发生时的守备力
--========== Reset ==========	--重置条件（注意：重置条件可以多个相加）
RESET_SELF_TURN		=0x10000000			--自己回合的階段重置
RESET_OPPO_TURN		=0x20000000			--对方回合的階段重置
RESET_PHASE			=0x40000000			--阶段结束重置(一般和上面那些阶段配合使用)
RESET_CHAIN			=0x80000000			--连锁结束重置
RESET_EVENT			=0x1000				--指定的條件下重置(一般和下面这些事件配合使用)
RESET_CARD			=0x2000				--重置Owner為指定卡片的效果
RESET_CODE			=0x4000				--重置指定Code的single效果(不含EFFECT_FLAG_SINGLE_RANGE)
RESET_COPY			=0x8000				--重置以复制取得的效果
RESET_DISABLE		=0x00010000			--效果无效重置(只適用於owner==handler的效果)
RESET_TURN_SET		=0x00020000			--变里侧重置(皆為事件觸發前重置)
RESET_TOGRAVE		=0x00040000			--去墓地重置
RESET_REMOVE		=0x00080000			--除外重置
RESET_TEMP_REMOVE	=0x00100000			--暂时除外重置
RESET_TOHAND		=0x00200000			--回手牌或加入手牌重置
RESET_TODECK		=0x00400000			--回卡组重置
RESET_LEAVE			=0x00800000			--从怪兽区或魔法区到不同区域
RESET_TOFIELD		=0x01000000			--除了返回场上以外，从不同区域移动到怪兽区或魔法区
RESET_CONTROL		=0x02000000			--控制者变更重置
RESET_OVERLAY		=0x04000000			--超量叠放重置
RESET_MSCHANGE		=0x08000000			--从怪兽区到魔法区，或者从魔法区到怪兽区(move_to_field()、寶玉獸)
----组合时点
RESETS_STANDARD				=0x1fe0000	--RESET_TOFIELD+RESET_LEAVE+RESET_TODECK+RESET_TOHAND+RESET_TEMP_REMOVE+RESET_REMOVE+RESET_TOGRAVE+RESET_TURN_SET
RESETS_REDIRECT				=0xc7e0000	--RESETS_STANDARD+RESET_OVERLAY+RESET_MSCHANGE-RESET_TOFIELD-RESET_LEAVE (EFFECT_LEAVE_FIELD_REDIRECT)
RESETS_WITHOUT_TEMP_REMOVE	=0x56e0000	--RESETS_STANDARD-RESET_TEMP_REMOVE-RESET_LEAVE+RESET_OVERLAY
--========== Types ==========	--效果类型（定义效果触发类型，和codes一起使用）
EFFECT_TYPE_SINGLE			=0x0001		--自己状态变化时触发
EFFECT_TYPE_FIELD			=0x0002		--场上所有卡状态变化时触发
EFFECT_TYPE_EQUIP			=0x0004		--装备效果
EFFECT_TYPE_ACTIONS			=0x0008		--触发型，以下類型會自動添加此屬性（对峙的G）
EFFECT_TYPE_ACTIVATE		=0x0010		--魔陷发动
EFFECT_TYPE_FLIP			=0x0020		--翻转效果
EFFECT_TYPE_IGNITION		=0x0040		--起动效果
EFFECT_TYPE_TRIGGER_O		=0x0080		--诱发选发效果
EFFECT_TYPE_QUICK_O			=0x0100		--诱发即时效果
EFFECT_TYPE_TRIGGER_F		=0x0200		--诱发必发效果
EFFECT_TYPE_QUICK_F			=0x0400		--诱发即时必发效果（熊猫龙等）
EFFECT_TYPE_CONTINUOUS		=0x0800		--由事件觸發的輔助用效果/永續效果
EFFECT_TYPE_XMATERIAL		=0x1000		--作为超量素材时超量怪兽获得的效果（十二兽）
EFFECT_TYPE_GRANT			=0x2000		--使其他卡片获得效果（天气模样）
EFFECT_TYPE_TARGET          =0x4000     --影响持续取的对象的效果（基本只用于魔陷）
--========== Flags ==========	--效果的特殊性质
EFFECT_FLAG_INITIAL			=0x0001		--可以发动的
EFFECT_FLAG_FUNC_VALUE		=0x0002		--此效果的Value属性是函数
EFFECT_FLAG_COUNT_LIMIT		=0x0004		--发动次数限制
EFFECT_FLAG_FIELD_ONLY		=0x0008		--此效果是注册给全局环境的
EFFECT_FLAG_CARD_TARGET		=0x0010		--取对象效果
EFFECT_FLAG_IGNORE_RANGE	=0x0020		--影响所有区域的卡（大宇宙）
EFFECT_FLAG_ABSOLUTE_TARGET	=0x0040		--Target Range固定為某個玩家的視角所見的自己/對方(SetAbsoluteRange()專用)
EFFECT_FLAG_IGNORE_IMMUNE	=0x0080		--无视效果免疫
EFFECT_FLAG_SET_AVAILABLE	=0x0100		--裡側狀態可發動的效果、影响场上里侧的卡的永續型效果
EFFECT_FLAG_CANNOT_NEGATE	=0x0200		--含有"此效果不會被無效"的敘述
EFFECT_FLAG_CANNOT_DISABLE	=0x0400		--效果不会被无效
EFFECT_FLAG_PLAYER_TARGET	=0x0800		--含有"以玩家为对象"的特性（精靈之鏡）、影響玩家的永續型效果(SetTargetRange()改成指定玩家)
EFFECT_FLAG_BOTH_SIDE		=0x1000		--双方都能使用（部分场地，弹压）
EFFECT_FLAG_COPY_INHERIT	=0x2000		--若由复制的效果產生則继承其Reset属性
EFFECT_FLAG_DAMAGE_STEP		=0x4000		--可以在伤害步骤发动
EFFECT_FLAG_DAMAGE_CAL		=0x8000		--可以在伤害计算时发动
EFFECT_FLAG_DELAY			=0x10000	--場合型誘發效果、用於永續效果的EFFECT_TYPE_CONTINUOUS
EFFECT_FLAG_SINGLE_RANGE	=0x20000	--只对自己有效
EFFECT_FLAG_UNCOPYABLE		=0x40000	--不能复制的原始效果（效果外文本）
EFFECT_FLAG_OATH			=0x80000	--誓约效果
EFFECT_FLAG_SPSUM_PARAM		=0x100000	--指定召喚/规则特殊召唤的位置和表示形式(熔岩魔神)
EFFECT_FLAG_REPEAT			=0x200000	--N/A
EFFECT_FLAG_NO_TURN_RESET	=0x400000	--发条等“这张卡在场上只能发动一次”的效果
EFFECT_FLAG_EVENT_PLAYER	=0x800000	--视为对方玩家的效果（动作？）
EFFECT_FLAG_OWNER_RELATE	=0x1000000	--与效果owner关联的效果
EFFECT_FLAG_CANNOT_INACTIVATE	=0x2000000	--發動不會被無效
EFFECT_FLAG_CLIENT_HINT			=0x4000000	--客户端提示
EFFECT_FLAG_CONTINUOUS_TARGET	=0x8000000	--建立持續對象的永續魔法/永續陷阱/早埋系以外的裝備魔法卡
EFFECT_FLAG_LIMIT_ZONE			=0x10000000 --限制魔法·陷阱卡发动时可以放置的区域
EFFECT_FLAG_COF					=0x20000000 --N/A
EFFECT_FLAG_CVAL_CHECK			=0x40000000	--N/A
EFFECT_FLAG_IMMEDIATELY_APPLY	=0x80000000	--卡在发动时效果就立即适用

EFFECT_FLAG2_MILLENNIUM_RESTRICT	=0x0001 --N/A
EFFECT_FLAG2_COF					=0x0002 --通常魔法卡在MP1以外发动（邪恶的仪式的特殊处理）
EFFECT_FLAG2_WICKED					=0x0004	--神之化身/恐惧之源的攻击力变化最后计算
EFFECT_FLAG2_OPTION					=0x0008	--子機

--========== Codes ==========	--对永续性效果表示效果类型(EFFECT开头)，对诱发型效果表示触发效果的事件/时点(EVENT开头)
EFFECT_IMMUNE_EFFECT			=1		--效果免疫
EFFECT_DISABLE					=2		--效果无效（技能抽取）
EFFECT_CANNOT_DISABLE			=3		--效果不能被无效
EFFECT_SET_CONTROL				=4		--设置控制权
EFFECT_CANNOT_CHANGE_CONTROL	=5		--不能改变控制权
EFFECT_CANNOT_ACTIVATE			=6		--玩家不能发动效果
EFFECT_CANNOT_TRIGGER			=7		--卡不能发动效果
EFFECT_DISABLE_EFFECT			=8		--效果无效（聖杯）
EFFECT_DISABLE_CHAIN			=9		--在連鎖串中無效(processor.cpp)
EFFECT_DISABLE_TRAPMONSTER		=10		--陷阱怪兽无效
EFFECT_CANNOT_INACTIVATE		=12		--发动不能被无效
EFFECT_CANNOT_DISEFFECT			=13		--效果處理時不能被无效
EFFECT_CANNOT_CHANGE_POSITION	=14		--不能改变表示形式
EFFECT_TRAP_ACT_IN_HAND			=15		--陷阱可以从手牌发动
EFFECT_TRAP_ACT_IN_SET_TURN		=16		--陷阱可以在盖放的回合发动
EFFECT_REMAIN_FIELD				=17		--X回合内留在场上（光之护封剑等）
EFFECT_MONSTER_SSET				=18		--怪兽可以在魔陷区放置
EFFECT_CANNOT_SUMMON			=20		--不能召唤怪兽
EFFECT_CANNOT_FLIP_SUMMON		=21		--不能翻转召唤怪兽
EFFECT_CANNOT_SPECIAL_SUMMON	=22		--不能特殊召唤怪兽
EFFECT_CANNOT_MSET				=23		--不能覆盖怪兽
EFFECT_CANNOT_SSET				=24		--不能覆盖魔陷
EFFECT_CANNOT_DRAW				=25		--不能抽卡
EFFECT_CANNOT_DISABLE_SUMMON	=26		--召唤不会无效
EFFECT_CANNOT_DISABLE_SPSUMMON	=27		--特殊召唤不会无效
EFFECT_SET_SUMMON_COUNT_LIMIT	=28		--限制每回合放置怪兽次数
EFFECT_EXTRA_SUMMON_COUNT		=29		--增加召唤（通常召唤）次数
EFFECT_SPSUMMON_CONDITION		=30		--特殊召唤条件
EFFECT_REVIVE_LIMIT				=31		--有苏生限制的怪獸(Card.EnableReviveLimit())
EFFECT_SUMMON_PROC				=32		--召唤规则效果
EFFECT_LIMIT_SUMMON_PROC		=33		--召唤规则限制
EFFECT_SPSUMMON_PROC			=34		--特殊召唤规则
EFFECT_EXTRA_SET_COUNT			=35		--增加盖放（通常召唤）次数
EFFECT_SET_PROC					=36		--放置（通常召唤）规则
EFFECT_LIMIT_SET_PROC			=37		--放置（通常召唤）规则限制
EFFECT_DIVINE_LIGHT				=38		--神圣光辉
EFFECT_CANNOT_DISABLE_FLIP_SUMMON	=39	--翻转召唤不会无效
EFFECT_INDESTRUCTABLE			=40		--不会被破坏
EFFECT_INDESTRUCTABLE_EFFECT	=41		--不会被效果破坏
EFFECT_INDESTRUCTABLE_BATTLE	=42		--不会被战斗破坏
EFFECT_UNRELEASABLE_SUM			=43		--不能做上级召唤的祭品
EFFECT_UNRELEASABLE_NONSUM		=44		--不能做上级召唤以外的祭品
EFFECT_DESTROY_SUBSTITUTE		=45		--必選的代替破壞(此卡被破壞時用其他卡代替)
EFFECT_CANNOT_RELEASE			=46		--不能进行解放行为
EFFECT_INDESTRUCTABLE_COUNT		=47 	--一回合几次不会被破坏
EFFECT_UNRELEASABLE_EFFECT		=48		--不能被解放
EFFECT_DESTROY_REPLACE			=50		--可選的代替破壞(將破壞改成其他動作)
EFFECT_RELEASE_REPLACE			=51		--代替解放
EFFECT_SEND_REPLACE				=52		--可以不送去XX而送去OO（甜点城堡等）
EFFECT_CANNOT_DISCARD_HAND		=55		--不能丢弃手牌
EFFECT_CANNOT_DISCARD_DECK		=56		--不能把卡组的卡送去墓地
EFFECT_CANNOT_USE_AS_COST		=57		--不能作为COST使用
EFFECT_CANNOT_PLACE_COUNTER		=58		--不能放置counter
EFFECT_CANNOT_TO_GRAVE_AS_COST	=59		--不能作为COST送去墓地
EFFECT_LEAVE_FIELD_REDIRECT		=60		--离场时重新指定去向
EFFECT_TO_HAND_REDIRECT			=61		--回手牌时重新指定去向
EFFECT_TO_DECK_REDIRECT			=62		--回卡组时重新指定去向
EFFECT_TO_GRAVE_REDIRECT		=63		--去墓地时重新指定去向
EFFECT_REMOVE_REDIRECT			=64		--除外时重新指定去向
EFFECT_CANNOT_TO_HAND			=65		--不能加入手牌
EFFECT_CANNOT_TO_DECK			=66		--不能回卡组
EFFECT_CANNOT_REMOVE			=67		--不能除外
EFFECT_CANNOT_TO_GRAVE			=68		--不能去墓地
EFFECT_CANNOT_TURN_SET			=69		--不能变里侧
EFFECT_CANNOT_BE_BATTLE_TARGET	=70		--不能成为攻击对象
EFFECT_CANNOT_BE_EFFECT_TARGET	=71		--不能成为效果对象
EFFECT_IGNORE_BATTLE_TARGET		=72		--不能成为攻击对象-鶸型（传说的渔人）
EFFECT_CANNOT_DIRECT_ATTACK		=73		--不能直接攻击
EFFECT_DIRECT_ATTACK			=74		--可以直接攻击
EFFECT_DUAL_STATUS				=75		--二重状态
EFFECT_EQUIP_LIMIT				=76		--装备对象限制
EFFECT_DUAL_SUMMONABLE			=77		--可以再度召唤
EFFECT_UNION_LIMIT				=78		--
EFFECT_REVERSE_DAMAGE			=80		--伤害变回复
EFFECT_REVERSE_RECOVER			=81		--回复变伤害
EFFECT_CHANGE_DAMAGE			=82		--改变伤害数值
EFFECT_REFLECT_DAMAGE			=83		--反射伤害
EFFECT_CANNOT_ATTACK			=85		--不能攻击
EFFECT_CANNOT_ATTACK_ANNOUNCE	=86		--不能攻击宣言
EFFECT_CANNOT_CHANGE_POS_E		=87 	--不会被卡的效果变成守备表示（攻击性云魔物）
EFFECT_ACTIVATE_COST			=90		--发动代价（魔力之枷）
EFFECT_SUMMON_COST				=91		--召唤代价
EFFECT_SPSUMMON_COST			=92		--特殊召唤代价（暴君龙）
EFFECT_FLIPSUMMON_COST			=93		--翻转召唤代价
EFFECT_MSET_COST				=94		--怪兽放置代价
EFFECT_SSET_COST				=95		--魔陷放置代价
EFFECT_ATTACK_COST				=96		--攻击代价（霞之谷猎鹰）

EFFECT_UPDATE_ATTACK			=100	--增减攻击力
EFFECT_SET_ATTACK				=101	--设置自身攻击力、攻击力变成X特殊召唤、持续改变攻击力
EFFECT_SET_ATTACK_FINAL			=102	--暂时改变攻击力（所有置入连锁的效果）
EFFECT_SET_BASE_ATTACK			=103	--设置原本攻击力
EFFECT_UPDATE_DEFENSE			=104	--增减守备力
EFFECT_SET_DEFENSE				=105	--设置自身守备力、守备力变成X特殊召唤、持续改变攻击力
EFFECT_SET_DEFENSE_FINAL		=106	--暂时改变攻击力（所有置入连锁的效果）
EFFECT_SET_BASE_DEFENSE			=107	--设置原本防御力
EFFECT_REVERSE_UPDATE			=108	--倒置改变攻击力、防御力（天邪鬼）
EFFECT_SWAP_AD					=109	--交换攻防(超級漏洞人)
EFFECT_SWAP_BASE_AD				=110	--交换原本攻防
EFFECT_SET_BASE_ATTACK_FINAL	=111	--设置最终原本攻击力
EFFECT_SET_BASE_DEFENSE_FINAL	=112	--设置最终原本防御力
EFFECT_ADD_CODE					=113	--增加卡名
EFFECT_CHANGE_CODE				=114	--改变卡名
EFFECT_ADD_TYPE					=115	--增加卡片种类（types）
EFFECT_REMOVE_TYPE				=116	--删除卡片种类
EFFECT_CHANGE_TYPE				=117	--改变卡片种类
EFFECT_ADD_RACE					=120	--增加种族
EFFECT_REMOVE_RACE				=121	--删除种族
EFFECT_CHANGE_RACE				=122	--改变种族
EFFECT_ADD_ATTRIBUTE			=125	--增加属性
EFFECT_REMOVE_ATTRIBUTE			=126	--删除属性
EFFECT_CHANGE_ATTRIBUTE			=127	--改变属性
EFFECT_UPDATE_LEVEL				=130	--改变等级
EFFECT_CHANGE_LEVEL				=131	--设置等级
EFFECT_UPDATE_RANK				=132	--改变阶级
EFFECT_CHANGE_RANK				=133	--设置阶级
EFFECT_UPDATE_LSCALE			=134	--改变左刻度
EFFECT_CHANGE_LSCALE			=135	--设置左刻度
EFFECT_UPDATE_RSCALE			=136	--改变右刻度
EFFECT_CHANGE_RSCALE			=137	--设置右刻度
EFFECT_SET_POSITION				=140 	--設定表示形式
EFFECT_SELF_DESTROY				=141 	--不入連鎖的破壞（罪系列等）
EFFECT_SELF_TOGRAVE				=142 	--不入連鎖的送墓
EFFECT_DOUBLE_TRIBUTE			=150	--可以作为2个祭品
EFFECT_DECREASE_TRIBUTE			=151	--减少祭品
EFFECT_DECREASE_TRIBUTE_SET		=152	--减少放置怪兽的祭品
EFFECT_EXTRA_RELEASE			=153	--必須使用的代替解放（灵魂交错）
EFFECT_TRIBUTE_LIMIT			=154	--祭品限制
EFFECT_EXTRA_RELEASE_SUM		=155	--代替召唤解放（帝王的烈旋）
EFFECT_TRIPLE_TRIBUTE			=156	--N/A
EFFECT_ADD_EXTRA_TRIBUTE		=157	--增加可使用的祭品（真龙）
EFFECT_EXTRA_RELEASE_NONSUM		=158	--代替效果COST的解放（闇黒世界）
EFFECT_PUBLIC					=160	--公开手牌
EFFECT_COUNTER_PERMIT			=0x10000--允许放置指示物类型
EFFECT_COUNTER_LIMIT			=0x20000--允许放置指示物数量
EFFECT_RCOUNTER_REPLACE			=0x30000--代替取除指示物
EFFECT_LPCOST_CHANGE			=170	--改变生命值代价數值
EFFECT_LPCOST_REPLACE			=171	--以其他動作代替生命值代价
EFFECT_SKIP_DP					=180	--跳过抽卡阶段
EFFECT_SKIP_SP					=181	--跳过准备阶段
EFFECT_SKIP_M1					=182	--跳过主要阶段1
EFFECT_SKIP_BP					=183	--跳过战斗阶段
EFFECT_SKIP_M2					=184	--跳过主要阶段2
EFFECT_CANNOT_BP				=185	--不能进入战斗阶段
EFFECT_CANNOT_M2				=186	--不能进入主要阶段2
EFFECT_CANNOT_EP				=187	--不能进入结束阶段
EFFECT_SKIP_TURN				=188	--跳过整个回合
EFFECT_DEFENSE_ATTACK			=190	--可以守备表示攻击
EFFECT_MUST_ATTACK				=191	--必须攻击
EFFECT_FIRST_ATTACK				=192	--必须第一个攻击
EFFECT_ATTACK_ALL				=193	--可以攻击所有怪兽
EFFECT_EXTRA_ATTACK				=194	--增加攻击次数
EFFECT_MUST_BE_ATTACKED			=195	--N/A
EFFECT_ONLY_BE_ATTACKED			=196	--只能攻击此卡
EFFECT_ATTACK_DISABLED			=197	--攻击已被無效(Duel.NegateAttack()成功的標記)
EFFECT_NO_BATTLE_DAMAGE			=200	--不会给对方造成战斗伤害
EFFECT_AVOID_BATTLE_DAMAGE		=201	--不会对自己造成战斗伤害
EFFECT_REFLECT_BATTLE_DAMAGE	=202	--战斗伤害由对方代为承受
EFFECT_PIERCE					=203	--贯穿伤害
EFFECT_BATTLE_DESTROY_REDIRECT	=204	--战斗破坏时重新指定去向
EFFECT_BATTLE_DAMAGE_TO_EFFECT	=205	--战斗伤害视为效果伤害
EFFECT_BOTH_BATTLE_DAMAGE		=206    --战斗伤害由双方承受
EFFECT_ALSO_BATTLE_DAMAGE		=207    --对自己的战斗伤害让对方也承受
EFFECT_CHANGE_BATTLE_DAMAGE		=208    --改变此卡给予的战斗伤害、改变玩家受到的战斗伤害
EFFECT_TOSS_COIN_REPLACE		=220	--重新抛硬币
EFFECT_TOSS_DICE_REPLACE		=221	--重新掷骰子
EFFECT_FUSION_MATERIAL			=230	--指定融合素材的條件
EFFECT_CHAIN_MATERIAL			=231	--玩家受到連鎖物質的效果影響
EFFECT_SYNCHRO_MATERIAL			=232	--可以当作同调素材
EFFECT_XYZ_MATERIAL				=233	--可以当作超量素材
EFFECT_FUSION_SUBSTITUTE		=234	--代替融合素材
EFFECT_CANNOT_BE_FUSION_MATERIAL	=235--不能做融合素材
EFFECT_CANNOT_BE_SYNCHRO_MATERIAL	=236--不能做同调素材
EFFECT_SYNCHRO_MATERIAL_CUSTOM		=237--自定义Tuner的同调过程
EFFECT_CANNOT_BE_XYZ_MATERIAL		=238--不能做超量素材
EFFECT_CANNOT_BE_LINK_MATERIAL		=239--不能做连接素材
EFFECT_SYNCHRO_LEVEL				=240--做同调素材时的等级
EFFECT_RITUAL_LEVEL					=241--做仪式祭品时的等级
EFFECT_XYZ_LEVEL					=242--做超量素材时的等级
EFFECT_EXTRA_RITUAL_MATERIAL		=243--在墓地当做仪式祭品
EFFECT_NONTUNER						=244--同时当作调整以外的怪兽（幻影王 幽骑）
EFFECT_OVERLAY_REMOVE_REPLACE		=245--代替去除超量素材
EFFECT_SCRAP_CHIMERA				=246--废铁奇美拉
EFFECT_TUNE_MAGICIAN_X				=247--调弦之魔术师超量素材限制
EFFECT_TUNE_MAGICIAN_F				=248--调弦之魔术师融合素材限制
EFFECT_PRE_MONSTER				=250	--可存取怪獸的各項數值(Card.AddMonsterAttribute()專用)
EFFECT_MATERIAL_CHECK			=251	--检查素材
EFFECT_DISABLE_FIELD			=260	--无效区域（扰乱王等）
EFFECT_USE_EXTRA_MZONE			=261	--怪兽区域封锁
EFFECT_USE_EXTRA_SZONE			=262	--魔法区域封锁
EFFECT_MAX_MZONE				=263	--怪獸区格數上限
EFFECT_MAX_SZONE				=264	--魔陷区格數上限
EFFECT_MUST_USE_MZONE			=265	--必须使用怪兽区的格子
EFFECT_HAND_LIMIT				=270	--手牌数量限制
EFFECT_DRAW_COUNT				=271	--抽卡阶段的抽卡数
EFFECT_SPIRIT_DONOT_RETURN		=280	--灵魂怪兽不返回手牌
EFFECT_SPIRIT_MAYNOT_RETURN		=281	--灵魂怪兽可以不返回手牌
EFFECT_CHANGE_ENVIRONMENT		=290	--改变场地
EFFECT_NECRO_VALLEY				=291	--王家长眠之谷
EFFECT_FORBIDDEN				=292	--不能Play(禁止令)
EFFECT_NECRO_VALLEY_IM			=293	--不受「王家长眠之谷」的影响
EFFECT_REVERSE_DECK				=294	--翻转卡组
EFFECT_REMOVE_BRAINWASHING		=295	--洗脑解除
EFFECT_BP_TWICE					=296	--2次战斗阶段
EFFECT_UNIQUE_CHECK				=297	--場上只能存在1張(Card.SetUniqueOnField()專用)
EFFECT_MATCH_KILL				=300	--Match胜利(胜利龙)
EFFECT_SYNCHRO_CHECK			=310	--基因组斗士
EFFECT_QP_ACT_IN_NTPHAND		=311	--对方回合从自己手卡发动（失乐的圣女）
EFFECT_MUST_BE_SMATERIAL		=312	--必须作为同调素材（波动龙 声子龙）
EFFECT_TO_GRAVE_REDIRECT_CB		=313	--重新指定去向(寶玉獸)
EFFECT_CHANGE_INVOLVING_BATTLE_DAMAGE	=314	--改变此卡的战斗产生的战斗伤害
EFFECT_CHANGE_RANK_FINAL		=315	--N/A
EFFECT_MUST_BE_FMATERIAL		=316	--必须作为融合素材
EFFECT_MUST_BE_XMATERIAL		=317	--必须作为超量素材
EFFECT_MUST_BE_LMATERIAL		=318	--必须作为连接素材
EFFECT_SPSUMMON_PROC_G			=320	--P召唤规则
EFFECT_SPSUMMON_COUNT_LIMIT		=330	--特殊召唤次数限制
EFFECT_LEFT_SPSUMMON_COUNT		=331	--剩餘召喚次數(召喚限制網)
EFFECT_CANNOT_SELECT_BATTLE_TARGET	=332	--對手不能選擇為攻擊對象
EFFECT_CANNOT_SELECT_EFFECT_TARGET	=333	--對手不能選擇為效果對象
EFFECT_ADD_SETCODE				=334	--视为「XX」字段的效果
EFFECT_NO_EFFECT_DAMAGE			=335	--玩家已受到"效果傷害變成0"的效果影響
EFFECT_UNSUMMONABLE_CARD		=336	--N/A
EFFECT_DISABLE_CHAIN_FIELD		=337	--N/A
EFFECT_DISCARD_COST_CHANGE		=338	--反制陷阱捨棄手牌的代價改變(解放之阿里阿德涅)
EFFECT_HAND_SYNCHRO				=339	--用手牌的怪獸當作同步素材
EFFECT_ADD_FUSION_CODE			=340	--作为融合素材时可以当作某一卡名(融合识别)
EFFECT_ADD_FUSION_SETCODE		=341	--作为融合素材时可以当作某一字段(魔玩具改造)
EFFECT_RISE_TO_FULL_HEIGHT		=342	--N/A
EFFECT_ONLY_ATTACK_MONSTER		=343	--只能攻擊X
EFFECT_MUST_ATTACK_MONSTER		=344	--若攻擊則必須攻擊X
EFFECT_PATRICIAN_OF_DARKNESS	=345	--由對手選擇攻擊對象(黑暗貴族)
EFFECT_EXTRA_ATTACK_MONSTER		=346	--對怪獸攻擊X次
EFFECT_UNION_STATUS				=347	--同盟状态
EFFECT_OLDUNION_STATUS			=348	--旧同盟状态
EFFECT_ADD_FUSION_ATTRIBUTE		=349	--reserve
EFFECT_REMOVE_FUSION_ATTRIBUTE	=350	--reserve
EFFECT_CHANGE_FUSION_ATTRIBUTE	=351	--用作融合素材时的属性
EFFECT_EXTRA_FUSION_MATERIAL	=352	--增加融合素材(万溶炼金师)
EFFECT_TUNER_MATERIAL_LIMIT		=353	--同调素材限制
EFFECT_ADD_LINK_CODE				=354	--用作连接素材时的卡名
EFFECT_ADD_LINK_SETCODE			=355	--reserve
EFFECT_ADD_LINK_ATTRIBUTE		=356	--用作连接素材时的属性
EFFECT_ADD_LINK_RACE				=357	--用作连接素材时的种族
EFFECT_EXTRA_LINK_MATERIAL		=358	--手卡的连接素材
EFFECT_QP_ACT_IN_SET_TURN		=359	--速攻魔法可以在盖放的回合发动
EFFECT_EXTRA_PENDULUM_SUMMON	=360	--extra pendulum summon
EFFECT_MATERIAL_LIMIT			=361	--
EFFECT_SET_BATTLE_ATTACK		=362    --战斗的伤害计算用设置的攻击力进行
EFFECT_SET_BATTLE_DEFENSE		=363    --战斗的伤害计算用设置的守备力进行
EFFECT_OVERLAY_RITUAL_MATERIAL  =364    --此卡的超量素材也能用于仪式召唤
EFFECT_CHANGE_GRAVE_ATTRIBUTE	=365	--墓地的卡将会改变属性（升级转变）
EFFECT_CHANGE_GRAVE_RACE		=366	--墓地的卡将会改变种族（升级转变）

--下面是诱发效果的诱发事件、时点 （如果是TYPE_SINGLE则自己发生以下事件后触发，如果TYPE_FIELD则场上任何卡发生以下事件都触发）
EVENT_STARTUP					=1000	--N/A
EVENT_FLIP						=1001	--翻转时
EVENT_FREE_CHAIN				=1002	--自由时点（强脱等，还有昴星团等诱发即时效果）
EVENT_DESTROY					=1010	--確定被破壞的卡片移動前
EVENT_REMOVE					=1011	--除外时
EVENT_TO_HAND					=1012	--加入手牌时
EVENT_TO_DECK					=1013	--回卡组时
EVENT_TO_GRAVE					=1014	--送去墓地时(不含REASON_RETURN)
EVENT_LEAVE_FIELD				=1015	--离场时
EVENT_CHANGE_POS				=1016	--表示形式变更时
EVENT_RELEASE					=1017	--解放时
EVENT_DISCARD					=1018	--丢弃手牌时
EVENT_LEAVE_FIELD_P				=1019	--離場的卡片移動前
EVENT_CHAIN_SOLVING				=1020	--连锁处理开始时（EVENT_CHAIN_ACTIVATING之後）
EVENT_CHAIN_ACTIVATING			=1021	--连锁处理准备中
EVENT_CHAIN_SOLVED				=1022	--连锁处理结束时
EVENT_CHAIN_ACTIVATED			=1023	--N/A
EVENT_CHAIN_NEGATED				=1024	--连锁发动无效时（EVENT_CHAIN_ACTIVATING之後）
EVENT_CHAIN_DISABLED			=1025	--连锁效果无效时
EVENT_CHAIN_END					=1026	--连锁串结束时
EVENT_CHAINING					=1027	--效果发动时
EVENT_BECOME_TARGET				=1028	--成为效果对象时
EVENT_DESTROYED					=1029	--被破坏时
EVENT_MOVE						=1030	--移動卡片(急兔馬)
EVENT_LEAVE_GRAVE				=1031	--离开墓地时
EVENT_ADJUST					=1040	--adjust_all()调整後（御前试合）
EVENT_BREAK_EFFECT				=1050	--Duel.BreakEffect()被调用时
EVENT_SUMMON_SUCCESS			=1100	--通常召唤成功时
EVENT_FLIP_SUMMON_SUCCESS		=1101	--翻转召唤成功时
EVENT_SPSUMMON_SUCCESS			=1102	--特殊召唤成功时
EVENT_SUMMON					=1103	--召唤之际（怪兽还没上场、神宣等时点）
EVENT_FLIP_SUMMON				=1104	--翻转召唤之际
EVENT_SPSUMMON					=1105	--特殊召唤之际
EVENT_MSET						=1106	--放置怪兽时
EVENT_SSET						=1107	--放置魔陷时
EVENT_BE_MATERIAL				=1108	--作为同调/超量/连结素材、用于升级召唤的解放、作为仪式/融合召唤的素材
EVENT_BE_PRE_MATERIAL			=1109	--将要作为同调/超量/连结素材、用于升级召唤的解放
EVENT_DRAW						=1110	--抽卡时
EVENT_DAMAGE					=1111	--造成战斗/效果伤害时
EVENT_RECOVER					=1112	--回复生命值时
EVENT_PREDRAW					=1113	--抽卡阶段通常抽卡前
EVENT_SUMMON_NEGATED			=1114	--召唤被无效时
EVENT_FLIP_SUMMON_NEGATED		=1115	--反转召唤被无效时
EVENT_SPSUMMON_NEGATED			=1116	--特殊召唤被无效时
EVENT_CONTROL_CHANGED			=1120	--控制权变更
EVENT_EQUIP						=1121	--装备卡装备时
EVENT_ATTACK_ANNOUNCE			=1130	--攻击宣言时
EVENT_BE_BATTLE_TARGET			=1131	--被选为攻击对象时
EVENT_BATTLE_START				=1132	--伤害步骤开始时（反转前）
EVENT_BATTLE_CONFIRM			=1133	--伤害计算前（反转後）
EVENT_PRE_DAMAGE_CALCULATE		=1134	--伤害计算时（羽斬）
EVENT_DAMAGE_CALCULATING		=1135	--N/A
EVENT_PRE_BATTLE_DAMAGE			=1136	--即将产生战斗伤害(只能使用EFFECT_TYPE_CONTINUOUS)
EVENT_BATTLE_END				=1137	--N/A
EVENT_BATTLED					=1138	--伤害计算后（异女、同反转效果时点）
EVENT_BATTLE_DESTROYING			=1139	--以战斗破坏怪兽送去墓地时（BF-苍炎之修罗）
EVENT_BATTLE_DESTROYED			=1140	--被战斗破坏送去墓地时（杀人番茄等）
EVENT_DAMAGE_STEP_END			=1141	--伤害步骤结束时
EVENT_ATTACK_DISABLED			=1142	--攻击无效时（翻倍机会）
EVENT_BATTLE_DAMAGE				=1143	--造成战斗伤害时
EVENT_TOSS_DICE					=1150	--掷骰子的结果产生后
EVENT_TOSS_COIN					=1151	--抛硬币的结果产生后
EVENT_TOSS_COIN_NEGATE			=1152	--重新抛硬币
EVENT_TOSS_DICE_NEGATE			=1153	--重新掷骰子
EVENT_LEVEL_UP					=1200	--等级上升时
EVENT_PAY_LPCOST				=1201	--支付生命值时
EVENT_DETACH_MATERIAL			=1202	--去除超量素材时
EVENT_RETURN_TO_GRAVE			=1203	--回到墓地时
EVENT_TURN_END					=1210	--回合结束时
EVENT_PHASE						=0x1000	--阶段结束时
EVENT_PHASE_START				=0x2000	--阶段开始时
EVENT_ADD_COUNTER				=0x10000	--增加指示物时
EVENT_REMOVE_COUNTER			=0x20000	--去除指示物时(A指示物)，Card.RemoveCounter()必須手動觸發此事件
EVENT_CUSTOM					=0x10000000	--自訂事件
--Category	效果分类（表示这个效果将要发生什么事，OperationInfo设置了效果分类才能触发针对这一类型发动的卡，如破坏->星尘龙
CATEGORY_DESTROY			=0x1		--破坏效果
CATEGORY_RELEASE			=0x2    	--解放效果
CATEGORY_REMOVE				=0x4    	--除外效果
CATEGORY_TOHAND				=0x8    	--回手牌效果
CATEGORY_TODECK				=0x10   	--回卡组效果
CATEGORY_TOGRAVE			=0x20		--送去墓地效果
CATEGORY_DECKDES			=0x40   	--包含從卡组送去墓地或特殊召唤效果
CATEGORY_HANDES				=0x80   	--捨棄手牌效果
CATEGORY_SUMMON				=0x100  	--含召唤的效果
CATEGORY_SPECIAL_SUMMON		=0x200  	--含特殊召唤的效果
CATEGORY_TOKEN				=0x400		--含衍生物效果
CATEGORY_GRAVE_ACTION		=0x800  	--包含特殊召喚以外移動墓地的卡的效果（屋敷わらし）
CATEGORY_POSITION			=0x1000 	--改变表示形式效果
CATEGORY_CONTROL			=0x2000 	--改变控制权效果
CATEGORY_DISABLE			=0x4000 	--使效果无效效果
CATEGORY_DISABLE_SUMMON		=0x8000		--无效召唤效果
CATEGORY_DRAW				=0x10000	--抽卡效果
CATEGORY_SEARCH				=0x20000	--检索卡组效果
CATEGORY_EQUIP				=0x40000	--装备效果
CATEGORY_DAMAGE				=0x80000	--伤害效果
CATEGORY_RECOVER			=0x100000	--回复效果
CATEGORY_ATKCHANGE			=0x200000	--改变攻击效果
CATEGORY_DEFCHANGE			=0x400000	--改变防御效果
CATEGORY_COUNTER			=0x800000	--指示物效果
CATEGORY_COIN				=0x1000000	--硬币效果
CATEGORY_DICE				=0x2000000	--骰子效果
CATEGORY_LEAVE_GRAVE		=0x4000000	--涉及墓地的效果(王家長眠之谷)
CATEGORY_GRAVE_SPSUMMON		=0x8000000	--包含從墓地特殊召喚的效果（屋敷わらし、冥神）
CATEGORY_NEGATE				=0x10000000	--使发动无效效果
CATEGORY_ANNOUNCE			=0x20000000	--發動時宣言卡名的效果
CATEGORY_FUSION_SUMMON		=0x40000000	--融合召唤效果（暴走魔法阵）
CATEGORY_TOEXTRA			=0x80000000	--回额外卡组效果
--Hint
HINT_EVENT				=1
HINT_MESSAGE			=2
HINT_SELECTMSG			=3
HINT_OPSELECTED			=4
HINT_EFFECT				=5
HINT_RACE				=6
HINT_ATTRIB				=7
HINT_CODE				=8
HINT_NUMBER				=9
HINT_CARD				=10
HINT_ZONE				=11
--Card Hint
CHINT_TURN				=1
CHINT_CARD				=2
CHINT_RACE				=3
CHINT_ATTRIBUTE			=4
CHINT_NUMBER			=5
CHINT_DESC				=6
--Opcode
OPCODE_ADD				=0x40000000
OPCODE_SUB				=0x40000001
OPCODE_MUL				=0x40000002
OPCODE_DIV				=0x40000003
OPCODE_AND				=0x40000004
OPCODE_OR				=0x40000005
OPCODE_NEG				=0x40000006
OPCODE_NOT				=0x40000007
OPCODE_ISCODE			=0x40000100
OPCODE_ISSETCARD		=0x40000101
OPCODE_ISTYPE			=0x40000102
OPCODE_ISRACE			=0x40000103
OPCODE_ISATTRIBUTE		=0x40000104
--
DOUBLE_DAMAGE			=0x80000000
HALF_DAMAGE				=0x80000001
--Hint Message	--提示消息，显示在窗口的上面
HINTMSG_RELEASE			=500	--请选择要解放的卡
HINTMSG_DISCARD			=501	--请选择要丢弃的手牌
HINTMSG_DESTROY			=502	--请选择要破坏的卡
HINTMSG_REMOVE			=503	--请选择要除外的卡
HINTMSG_TOGRAVE			=504	--请选择要送去墓地的卡
HINTMSG_RTOHAND			=505	--请选择要返回手牌的卡
HINTMSG_ATOHAND			=506	--请选择要加入手牌的卡
HINTMSG_TODECK			=507	--请选择要返回卡组的卡
HINTMSG_SUMMON			=508	--请选择要召唤的卡
HINTMSG_SPSUMMON		=509	--请选择要特殊召唤的卡
HINTMSG_SET				=510	--请选择要盖放的卡
HINTMSG_FMATERIAL		=511	--请选择要作为融合素材的卡
HINTMSG_SMATERIAL		=512	--请选择要作为同调素材的卡
HINTMSG_XMATERIAL		=513	--请选择要作为超量素材的卡
HINTMSG_FACEUP			=514	--请选择表侧表示的卡
HINTMSG_FACEDOWN		=515	--请选择里侧表示的卡
HINTMSG_ATTACK			=516	--请选择攻击表示的怪兽
HINTMSG_DEFENSE			=517	--请选择守备表示的怪兽
HINTMSG_EQUIP			=518	--请选择要装备的卡
HINTMSG_REMOVEXYZ		=519	--请选择要取除的超量素材
HINTMSG_CONTROL			=520	--请选择要改变控制权的怪兽
HINTMSG_DESREPLACE		=521	--请选择要代替破坏的卡
HINTMSG_FACEUPATTACK	=522	--请选择表侧攻击表示的怪兽
HINTMSG_FACEUPDEFENSE	=523	--请选择表侧守备表示的怪兽
HINTMSG_FACEDOWNATTACK	=524	--请选择里侧攻击表示的怪兽
HINTMSG_FACEDOWNDEFENSE	=525	--请选择里侧守备表示的怪兽
HINTMSG_CONFIRM			=526	--请选择给对方确认的卡
HINTMSG_TOFIELD			=527	--请选择要放置到场上的卡
HINTMSG_POSCHANGE		=528	--请选择要改变表示形式的怪兽
HINTMSG_SELF			=529	--请选择自己的卡
HINTMSG_OPPO			=530	--请选择对方的卡
HINTMSG_TRIBUTE			=531	--请选择上级召唤用需要解放的怪兽
HINTMSG_DEATTACHFROM	=532	--请选择要取除超量素材的怪兽
HINTMSG_LMATERIAL   	=533	--请选择要作为连接素材的卡
HINTMSG_ATTACKTARGET	=549	--请选择攻击的对象
HINTMSG_EFFECT			=550	--请选择要发动的效果
HINTMSG_TARGET			=551	--请选择效果的对象
HINTMSG_COIN			=552	--请选择硬币的正反面
HINTMSG_DICE			=553	--请选择骰子的结果
HINTMSG_CARDTYPE		=554	--请选择一个种类
HINTMSG_OPTION			=555	--请选择一个选项
HINTMSG_RESOLVEEFFECT	=556	--请选择要发动/处理的效果
HINTMSG_SELECT			=560	--请选择
HINTMSG_POSITION		=561	--请选择表示形式
HINTMSG_ATTRIBUTE		=562	--请选择要宣言的属性
HINTMSG_RACE			=563	--请选择要宣言的种族
HINTMSG_CODE			=564	--请宣言一个卡名
HINGMSG_NUMBER			=565	--请选择一个数字
HINGMSG_LVRANK			=567	--请宣言一个等级
HINTMSG_RESOLVECARD		=568	--请选择要处理效果的卡
HINTMSG_ZONE			=569	--请选择[%ls]的位置
HINTMSG_DISABLEZONE		=570	--请选择要变成不能使用的卡片区域
HINTMSG_TOZONE			=571	--请选择要移动到的位置
HINTMSG_COUNTER			=572	--请选择要放置指示物的卡
HINTMSG_DISABLE			=573	--请选择要无效的卡
HINTMSG_OPERATECARD		=574	--请选择要操作的卡
--Select	--请选择
SELECT_HEADS				=60	--正面
SELECT_TAILS				=61	--反面
--Timing	--提示时点，可以给freechain卡片增加自动提示时点
TIMING_DRAW_PHASE			=0x1			--抽卡阶段时点
TIMING_STANDBY_PHASE		=0x2        	--准备阶段时点
TIMING_MAIN_END				=0x4        	--主要阶段结束时点
TIMING_BATTLE_START			=0x8        	--战斗阶段开始时点
TIMING_BATTLE_END			=0x10       	--战斗阶段结束时点
TIMING_END_PHASE			=0x20       	--结束阶段时点
TIMING_SUMMON				=0x40       	--召唤时点
TIMING_SPSUMMON				=0x80       	--特殊召唤时点
TIMING_FLIPSUMMON			=0x100      	--翻转召唤时点
TIMING_MSET					=0x200			--放置怪兽时点
TIMING_SSET					=0x400      	--放置魔陷时点
TIMING_POS_CHANGE			=0x800      	--表示形式变更时点
TIMING_ATTACK				=0x1000     	--攻击宣言时点
TIMING_DAMAGE_STEP			=0x2000     	--伤害步骤时点
TIMING_DAMAGE_CAL			=0x4000     	--伤害计算时点
TIMING_CHAIN_END			=0x8000     	--连锁结束时点
TIMING_DRAW					=0x10000    	--抽卡时点（不是抽卡阶段
TIMING_DAMAGE				=0x20000    	--造成伤害时点
TIMING_RECOVER				=0x40000		--回复时点
TIMING_DESTROY				=0x80000    	--破坏时点
TIMING_REMOVE				=0x100000   	--除外时点
TIMING_TOHAND				=0x200000   	--加入手牌时点（检索、回收等）
TIMING_TODECK				=0x400000   	--回卡组时点
TIMING_TOGRAVE				=0x800000   	--进墓地时点
TIMING_BATTLE_PHASE			=0x1000000  	--战斗阶段时点
TIMING_EQUIP				=0x2000000  	--装备时点
TIMING_BATTLE_STEP_END		=0x4000000  	--戰鬥步驟結束時
TIMING_BATTLED				=0x8000000  	--伤害计算后时点
----组合时点
TIMINGS_CHECK_MONSTER       =0x1c0 -- 怪兽正面上场
--Global flag	--特殊标记
GLOBALFLAG_DECK_REVERSE_CHECK	=0x1		--卡组翻转标记
GLOBALFLAG_BRAINWASHING_CHECK	=0x2		--洗脑解除标记
GLOBALFLAG_SCRAP_CHIMERA		=0x4		--废铁奇美拉标记
GLOBALFLAG_DELAYED_QUICKEFFECT	=0x8		--N/A
GLOBALFLAG_DETACH_EVENT			=0x10		--EVENT_DETACH_MATERIAL
GLOBALFLAG_MUST_BE_SMATERIAL	=0x20		--必须作为同调素材（波动龙 声子龙）
GLOBALFLAG_SPSUMMON_COUNT		=0x40		--玩家的特殊召唤次数限制
GLOBALFLAG_XMAT_COUNT_LIMIT		=0x80		--超量素材数量限制标记（光天使 天座）
GLOBALFLAG_SELF_TOGRAVE			=0x100		--不入連鎖的送墓檢查(EFFECT_SELF_TOGRAVE)
GLOBALFLAG_SPSUMMON_ONCE		=0x200		--1回合只能特殊召喚1次(Card.SetSPSummonOnce())
GLOBALFLAG_TUNE_MAGICIAN		=0x400		--超量素材检查标记（调弦之魔术师）
--count_code
EFFECT_COUNT_CODE_OATH			=0x10000000 --发动次数限制(誓约次数, 发动被无效不计数)
EFFECT_COUNT_CODE_DUEL			=0x20000000 --决斗中使用次数
EFFECT_COUNT_CODE_SINGLE		=0x1		--同一张卡的多个效果公共使用次数
--特殊选项
DUEL_TEST_MODE			=0x01		--测试模式(目前暫無)
DUEL_ATTACK_FIRST_TURN	=0x02		--第一回合可以攻击(用于残局)
DUEL_OLD_REPLAY			=0x04		--旧录像
DUEL_OBSOLETE_RULING	=0x08		--使用舊規則
DUEL_PSEUDO_SHUFFLE		=0x10		--不洗牌
DUEL_TAG_MODE			=0x20		--双打PP
DUEL_SIMPLE_AI			=0x40		--AI(用于残局)
DUEL_RETURN_DECK_TOP	=0x80		--回卡组洗切的卡放到卡组最上方（不洗牌模式下曾经的默认行为）
--Activity counter
--global: 1-6 (binary: 5,6)
--custom: 1-5,7 (binary: 1-5)
ACTIVITY_SUMMON			=1		--
ACTIVITY_NORMALSUMMON	=2		--
ACTIVITY_SPSUMMON		=3		--
ACTIVITY_FLIPSUMMON		=4		--
ACTIVITY_ATTACK			=5		--
ACTIVITY_BATTLE_PHASE	=6		-- not available in custom counter
ACTIVITY_CHAIN			=7		-- only available in custom counter
--Special cards
CARD_MARINE_DOLPHIN		=78734254	--海洋海豚(double name)
CARD_TWINKLE_MOSS		=13857930	--光輝苔蘚(double name)
CARD_QUESTION		    =38723936	--谜题
