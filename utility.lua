Auxiliary={}
aux=Auxiliary
POS_FACEUP_DEFENCE=POS_FACEUP_DEFENSE
POS_FACEDOWN_DEFENCE=POS_FACEDOWN_DEFENSE
RACE_CYBERS=RACE_CYBERSE

function GetID()
	local offset=self_code<100000000 and 1 or 100
	return self_table,self_code,offset
end

--the lua version of the bit32 lib, which is deprecated in lua 5.3
bit={}
function bit.band(a,b)
	return a&b
end
function bit.bor(a,b)
	return a|b
end
function bit.bxor(a,b)
	return a~b
end
function bit.lshift(a,b)
	return a<<b
end
function bit.rshift(a,b)
	return a>>b
end
function bit.bnot(a)
	return ~a
end
local function fieldargs(f,width)
	local w=width or 1
	assert(f>=0,"field cannot be negative")
	assert(w>0,"width must be positive")
	assert(f+w<=32,"trying to access non-existent bits")
	return f,~(-1<<w)
end
function bit.extract(r,field,width)
	local f,m=fieldargs(field,width)
	return (r>>f)&m
end
function bit.replace(r,v,field,width)
	local f,m=fieldargs(field,width)
	return (r&~(m<<f))|((v&m)<< f)
end

--the table of xyz number
Auxiliary.xyz_number={}
function Auxiliary.GetXyzNumber(v)
	local id
	if Auxiliary.GetValueType(v)=="Card" then id=v:GetCode() end
	if Auxiliary.GetValueType(v)=="number" then id=v end
	return Auxiliary.xyz_number[id]
end

--iterator for getting playerid of current turn player and the other player
function Auxiliary.TurnPlayers()
	local i=0
	return	function()
				i=i+1
				if i==1 then return Duel.GetTurnPlayer() end
				if i==2 then return 1-Duel.GetTurnPlayer() end
			end
end

--the chain id of the results modified by EVENT_TOSS_DICE_NEGATE
Auxiliary.idx_table=table.pack(1,2,3,4,5,6,7,8)

function Auxiliary.Stringid(code,id)
	return code*16+id
end
function Auxiliary.Next(g)
	local first=true
	return	function()
				if first then first=false return g:GetFirst()
				else return g:GetNext() end
			end
end
function Auxiliary.NULL()
end
function Auxiliary.TRUE()
	return true
end
function Auxiliary.FALSE()
	return false
end
function Auxiliary.AND(...)
	local function_list={...}
	return	function(...)
				local res=false
				for i,f in ipairs(function_list) do
					res=f(...)
					if not res then return res end
				end
				return res
			end
end
function Auxiliary.OR(...)
	local function_list={...}
	return	function(...)
				local res=false
				for i,f in ipairs(function_list) do
					res=f(...)
					if res then return res end
				end
				return res
			end
end
function Auxiliary.NOT(f)
	return	function(...)
				return not f(...)
			end
end
function Auxiliary.BeginPuzzle(effect)
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TURN_END)
	e1:SetCountLimit(1)
	e1:SetOperation(Auxiliary.PuzzleOp)
	Duel.RegisterEffect(e1,0)
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_SKIP_DP)
	e2:SetTargetRange(1,0)
	Duel.RegisterEffect(e2,0)
	local e3=Effect.GlobalEffect()
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_SKIP_SP)
	e3:SetTargetRange(1,0)
	Duel.RegisterEffect(e3,0)
end
function Auxiliary.PuzzleOp(e,tp)
	Duel.SetLP(0,0)
end
--Duel.SelectOption with option condition
--Return value starts from 1, different from Duel.SelectOption
function Auxiliary.SelectFromOptions(tp,...)
	local options={...}
	local ops={}
	local opvals={}
	for i=1,#options do
		if options[i][1] then
			table.insert(ops,options[i][2])
			table.insert(opvals,options[i][3] or i)
		end
	end
	if #ops==0 then return nil end
	local select=Duel.SelectOption(tp,table.unpack(ops))
	return opvals[select+1]
end
--register effect of return to hand for Spirit monsters
function Auxiliary.EnableSpiritReturn(c,event1,...)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(event1)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(Auxiliary.SpiritReturnReg)
	c:RegisterEffect(e1)
	for i,event in ipairs{...} do
		local e2=e1:Clone()
		e2:SetCode(event)
		c:RegisterEffect(e2)
	end
end
function Auxiliary.SpiritReturnReg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(1104)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0xd6e0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(Auxiliary.SpiritReturnConditionForced)
	e1:SetTarget(Auxiliary.SpiritReturnTargetForced)
	e1:SetOperation(Auxiliary.SpiritReturnOperation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(Auxiliary.SpiritReturnConditionOptional)
	e2:SetTarget(Auxiliary.SpiritReturnTargetOptional)
	c:RegisterEffect(e2)
end
function Auxiliary.SpiritReturnConditionForced(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) and not c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN)
end
function Auxiliary.SpiritReturnTargetForced(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function Auxiliary.SpiritReturnConditionOptional(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) and c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN)
end
function Auxiliary.SpiritReturnTargetOptional(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function Auxiliary.SpiritReturnOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function Auxiliary.EnableNeosReturn(c,operation,set_category)
	--return
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1193)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(Auxiliary.NeosReturnConditionForced)
	e1:SetTarget(Auxiliary.NeosReturnTargetForced(set_category))
	e1:SetOperation(operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(Auxiliary.NeosReturnConditionOptional)
	e2:SetTarget(Auxiliary.NeosReturnTargetOptional(set_category))
	c:RegisterEffect(e2)
	return e1,e2
end
function Auxiliary.NeosReturnConditionForced(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsHasEffect(42015635)
end
function Auxiliary.NeosReturnTargetForced(set_category)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then return true end
				Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
				if set_category then set_category(e,tp,eg,ep,ev,re,r,rp) end
			end
end
function Auxiliary.NeosReturnConditionOptional(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsHasEffect(42015635)
end
function Auxiliary.NeosReturnTargetOptional(set_category)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then return e:GetHandler():IsAbleToExtra() end
				Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
				if set_category then set_category(e,tp,eg,ep,ev,re,r,rp) end
			end
end
function Auxiliary.IsUnionState(effect)
	local c=effect:GetHandler()
	return c:IsHasEffect(EFFECT_UNION_STATUS) and c:GetEquipTarget()
end
--set EFFECT_EQUIP_LIMIT after equipping
function Auxiliary.SetUnionState(c)
	local eset={c:IsHasEffect(EFFECT_UNION_LIMIT)}
	if #eset==0 then return end
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_EQUIP_LIMIT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetValue(eset[1]:GetValue())
	e0:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UNION_STATUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	if c.old_union then
		local e2=e1:Clone()
		e2:SetCode(EFFECT_OLDUNION_STATUS)
		c:RegisterEffect(e2)
	end
end
--uc: the union monster to be equipped, tc: the target monster
function Auxiliary.CheckUnionEquip(uc,tc,exclude_modern_count)
	local modern_count,old_count=tc:GetUnionCount()
	if exclude_modern_count then modern_count=modern_count-exclude_modern_count end
	if uc.old_union then return modern_count==0
	else return old_count==0 end
end
--EFFECT_DESTROY_SUBSTITUTE filter for modern union monsters
function Auxiliary.UnionReplaceFilter(e,re,r,rp)
	return r&(REASON_BATTLE+REASON_EFFECT)~=0
end
--add effect to modern union monsters
function Auxiliary.EnableUnionAttribute(c,f)
	--destroy sub
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e1:SetValue(aux.UnionReplaceFilter)
	c:RegisterEffect(e1)
	--limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UNION_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(f)
	c:RegisterEffect(e2)
end
function Auxiliary.EnableChangeCode(c,code,location,condition)
	Auxiliary.AddCodeList(c,code)
	local loc=c:GetOriginalType()&TYPE_MONSTER~=0 and LOCATION_MZONE or LOCATION_SZONE
	loc=location or loc
	if condition==nil then condition=Auxiliary.TRUE end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(loc)
	e1:SetCondition(condition)
	e1:SetValue(code)
	c:RegisterEffect(e1)
	return e1
end
function Auxiliary.TargetEqualFunction(f,value,...)
	local ext_params={...}
	return	function(effect,target)
				return f(target,table.unpack(ext_params))==value
			end
end
function Auxiliary.TargetBoolFunction(f,...)
	local ext_params={...}
	return	function(effect,target)
				return f(target,table.unpack(ext_params))
			end
end
function Auxiliary.FilterEqualFunction(f,value,...)
	local ext_params={...}
	return	function(target)
				return f(target,table.unpack(ext_params))==value
			end
end
function Auxiliary.FilterBoolFunction(f,...)
	local ext_params={...}
	return	function(target)
				return f(target,table.unpack(ext_params))
			end
end
function Auxiliary.GetValueType(v)
	local t=type(v)
	if t=="userdata" then
		local mt=getmetatable(v)
		if mt==Group then return "Group"
		elseif mt==Effect then return "Effect"
		else return "Card" end
	else return t end
end
--Extra Deck summon count
function Auxiliary.EnableExtraDeckSummonCountLimit()
	if Auxiliary.ExtraDeckSummonCountLimit~=nil then return end
	Auxiliary.ExtraDeckSummonCountLimit={}
	Auxiliary.ExtraDeckSummonCountLimit[0]=1
	Auxiliary.ExtraDeckSummonCountLimit[1]=1
	local ge1=Effect.GlobalEffect()
	ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	ge1:SetOperation(Auxiliary.ExtraDeckSummonCountLimitReset)
	Duel.RegisterEffect(ge1,0)
end
function Auxiliary.ExtraDeckSummonCountLimitReset()
	Auxiliary.ExtraDeckSummonCountLimit[0]=1
	Auxiliary.ExtraDeckSummonCountLimit[1]=1
end
--Fusion Monster is unnecessary to use this
function Auxiliary.AddMaterialCodeList(c,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local mat={}
	for _,code in ipairs{...} do
		mat[code]=true
	end
	if c.material==nil then
		local mt=getmetatable(c)
		mt.material=mat
	end
	for index,_ in pairs(mat) do
		Auxiliary.AddCodeList(c,index)
	end
end
function Auxiliary.IsMaterialListCode(c,code)
	return c.material and c.material[code]
end
function Auxiliary.IsMaterialListSetCard(c,setcode)
	if not c.material_setcode then return false end
	if type(c.material_setcode)=='table' then
		for i,scode in ipairs(c.material_setcode) do
			if setcode&0xfff==scode&0xfff and setcode&scode==setcode then return true end
		end
	else
		return setcode&0xfff==c.material_setcode&0xfff and setcode&c.material_setcode==setcode
	end
	return false
end
function Auxiliary.IsMaterialListType(c,type)
	return c.material_type and type&c.material_type==type
end
function Auxiliary.GetMaterialListCount(c)
	if not c.material_count then return 0,0 end
	return c.material_count[1],c.material_count[2]
end
function Auxiliary.AddCodeList(c,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	if c.card_code_list==nil then
		local mt=getmetatable(c)
		mt.card_code_list={}
		for _,code in ipairs{...} do
			mt.card_code_list[code]=true
		end
	else
		for _,code in ipairs{...} do
			c.card_code_list[code]=true
		end
	end
end
function Auxiliary.IsCodeListed(c,code)
	return c.card_code_list and c.card_code_list[code]
end
function Auxiliary.AddSetNameMonsterList(c,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	if c.setcode_monster_list==nil then
		local mt=getmetatable(c)
		mt.setcode_monster_list={}
		for i,scode in ipairs{...} do
			mt.setcode_monster_list[i]=scode
		end
	else
		for i,scode in ipairs{...} do
			c.setcode_monster_list[i]=scode
		end
	end
end
function Auxiliary.IsSetNameMonsterListed(c,setcode)
	if not c.setcode_monster_list then return false end
	for i,scode in ipairs(c.setcode_monster_list) do
		if setcode&0xfff==scode&0xfff and setcode&scode==setcode then return true end
	end
	return false
end
function Auxiliary.IsCounterAdded(c,counter)
	if not c.counter_add_list then return false end
	for i,ccounter in ipairs(c.counter_add_list) do
		if counter==ccounter then return true end
	end
	return false
end
function Auxiliary.IsTypeInText(c,type)
	return c.has_text_type and type&c.has_text_type==type
end
function Auxiliary.GetAttributeCount(g)
	if #g==0 then return 0 end
	local att=0
	for tc in Auxiliary.Next(g) do
		att=att|tc:GetAttribute()
	end
	local ct=0
	while att~=0 do
		if att&0x1~=0 then ct=ct+1 end
		att=att>>1
	end
	return ct
end
function Auxiliary.IsInGroup(c,g)
	return g:IsContains(c)
end
--return the column of card c (from the viewpoint of p)
function Auxiliary.GetColumn(c,p)
	local seq=c:GetSequence()
	if c:IsLocation(LOCATION_MZONE) then
		if seq==5 then
			seq=1
		elseif seq==6 then
			seq=3
		end
	elseif c:IsLocation(LOCATION_SZONE) then
		if seq>4 then
			return nil
		end
	else
		return nil
	end
	if c:IsControler(p or 0) then
		return seq
	else
		return 4-seq
	end
end
--return the column of monster zone seq (from the viewpoint of controller)
function Auxiliary.MZoneSequence(seq)
	if seq==5 then return 1 end
	if seq==6 then return 3 end
	return seq
end
--return the column of spell/trap zone seq (from the viewpoint of controller)
function Auxiliary.SZoneSequence(seq)
	if seq>4 then return nil end
	return seq
end
--generate the value function of EFFECT_CHANGE_BATTLE_DAMAGE on monsters
function Auxiliary.ChangeBattleDamage(player,value)
	return	function(e,damp)
				if player==0 then
					if e:GetOwnerPlayer()==damp then
						return value
					else
						return -1
					end
				elseif player==1 then
					if e:GetOwnerPlayer()==1-damp then
						return value
					else
						return -1
					end
				end
			end
end
--filter for "negate the effects of a face-up monster" (無限泡影/Infinite Impermanence)
function Auxiliary.NegateMonsterFilter(c)
	return c:IsFaceup() and not c:IsDisabled() and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
--filter for "negate the effects of an Effect Monster" (エフェクト・ヴェーラー/Effect Veiler)
function Auxiliary.NegateEffectMonsterFilter(c)
	return c:IsFaceup() and not c:IsDisabled() and c:IsType(TYPE_EFFECT)
end
--filter for "negate the effects of a face-up card"
function Auxiliary.NegateAnyFilter(c)
	if c:IsType(TYPE_TRAPMONSTER) then
		return c:IsFaceup()
	elseif c:IsType(TYPE_SPELL+TYPE_TRAP) then
		return c:IsFaceup() and not c:IsDisabled()
	else
		return aux.NegateMonsterFilter(c)
	end
end
--alias for compatibility
Auxiliary.disfilter1=Auxiliary.NegateAnyFilter
--condition of EVENT_BATTLE_DESTROYING
function Auxiliary.bdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle()
end
--condition of EVENT_BATTLE_DESTROYING + opponent monster
function Auxiliary.bdocon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE)
end
--condition of EVENT_BATTLE_DESTROYING + to_grave
function Auxiliary.bdgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
--condition of EVENT_BATTLE_DESTROYING + opponent monster + to_grave
function Auxiliary.bdogcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE) and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
--condition of EVENT_DAMAGE_STEP_END + this monster is releate to battle
function Auxiliary.dsercon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() or c:IsStatus(STATUS_BATTLE_DESTROYED)
end
--condition of EVENT_TO_GRAVE + destroyed by opponent
function Auxiliary.dogcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousControler(tp) and c:IsReason(REASON_DESTROY) and rp==1-tp
end
--condition of EVENT_TO_GRAVE + destroyed by opponent + from field
function Auxiliary.dogfcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp)
		and c:IsReason(REASON_DESTROY) and rp==1-tp
end
--condition of "except the turn this card was sent to the Graveyard"
function Auxiliary.exccon(e)
	return Duel.GetTurnCount()~=e:GetHandler():GetTurnID() or e:GetHandler():IsReason(REASON_RETURN)
end
--condition of checking battle phase availability
function Auxiliary.bpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP() or (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
--condition of free chain effects changing ATK/DEF
function Auxiliary.dscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
--flag effect for spell counter
function Auxiliary.chainreg(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(1)==0 then
		e:GetHandler():RegisterFlagEffect(1,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
	end
end
--default filter for EFFECT_CANNOT_BE_BATTLE_TARGET
function Auxiliary.imval1(e,c)
	return not c:IsImmuneToEffect(e)
end
--filter for EFFECT_INDESTRUCTABLE_EFFECT + self
function Auxiliary.indsval(e,re,rp)
	return rp==e:GetHandlerPlayer()
end
--filter for EFFECT_INDESTRUCTABLE_EFFECT + opponent
function Auxiliary.indoval(e,re,rp)
	return rp==1-e:GetHandlerPlayer()
end
--filter for EFFECT_CANNOT_BE_EFFECT_TARGET + self
function Auxiliary.tgsval(e,re,rp)
	return rp==e:GetHandlerPlayer()
end
--filter for EFFECT_CANNOT_BE_EFFECT_TARGET + opponent
function Auxiliary.tgoval(e,re,rp)
	return rp==1-e:GetHandlerPlayer()
end
--filter for non-zero ATK
function Auxiliary.nzatk(c)
	return c:IsFaceup() and c:GetAttack()>0
end
--filter for non-zero DEF
function Auxiliary.nzdef(c)
	return c:IsFaceup() and c:GetDefense()>0
end
--flag effect for summon/sp_summon turn
function Auxiliary.sumreg(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local code=e:GetLabel()
	while tc do
		if tc:GetOriginalCode()==code then
			tc:RegisterFlagEffect(code,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
--for EVENT_BE_MATERIAL effect releated to the summoned monster
function Auxiliary.CreateMaterialReasonCardRelation(c,te)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(Auxiliary.MaterialReasonCardReg)
	e1:SetLabelObject(te)
	c:RegisterEffect(e1)
end
function Auxiliary.MaterialReasonCardReg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	c:GetReasonCard():CreateEffectRelation(te)
end
--effects inflicting damage to tp
function Auxiliary.damcon1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_DAMAGE)
	local e2=Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_RECOVER)
	local rd=e1 and not e2
	local rr=not e1 and e2
	local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_DAMAGE)
	if ex and (cp==tp or cp==PLAYER_ALL) and not rd and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NO_EFFECT_DAMAGE) then
		return true
	end
	ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_RECOVER)
	return ex and (cp==tp or cp==PLAYER_ALL) and rr and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NO_EFFECT_DAMAGE)
end
--filter for the immune effect of qli monsters
function Auxiliary.qlifilter(e,te)
	if te:IsActiveType(TYPE_MONSTER) and te:IsActivated() then
		local lv=e:GetHandler():GetLevel()
		local ec=te:GetOwner()
		if ec:IsType(TYPE_LINK) then
			return false
		elseif ec:IsType(TYPE_XYZ) then
			return ec:GetOriginalRank()<lv
		else
			return ec:GetOriginalLevel()<lv
		end
	else
		return false
	end
end
--sp_summon condition for gladiator beast monsters
function Auxiliary.gbspcon(e,tp,eg,ep,ev,re,r,rp)
	local st=e:GetHandler():GetSummonType()
	return st&SUMMON_VALUE_GLADIATOR>0
end
--sp_summon condition for evolsaur monsters
function Auxiliary.evospcon(e,tp,eg,ep,ev,re,r,rp)
	local st=e:GetHandler():GetSummonType()
	return st&SUMMON_VALUE_EVOLTILE>0
end
--filter for necro_valley test
function Auxiliary.NecroValleyFilter(f)
	return	function(target,...)
				return (not f or f(target,...)) and not target:IsHasEffect(EFFECT_NECRO_VALLEY)
			end
end
--Necrovalley test for effect with not certain target or not certain action
function Auxiliary.NecroValleyNegateCheck(v)
	if not Duel.IsChainDisablable(0) then return false end
	local g=Group.CreateGroup()
	if Auxiliary.GetValueType(v)=="Card" then g:AddCard(v) end
	if Auxiliary.GetValueType(v)=="Group" then g:Merge(v) end
	if g:IsExists(Card.IsHasEffect,1,nil,EFFECT_NECRO_VALLEY) then
		Duel.NegateEffect(0)
		return true
	end
	return false
end
--Ursarctic common summon from hand effect
function Auxiliary.AddUrsarcticSpSummonEffect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCondition(Auxiliary.UrsarcticSpSummonCondition)
	e1:SetCost(Auxiliary.UrsarcticSpSummonCost)
	e1:SetTarget(Auxiliary.UrsarcticSpSummonTarget)
	e1:SetOperation(Auxiliary.UrsarcticSpSummonOperation)
	c:RegisterEffect(e1)
	return e1
end
function Auxiliary.UrsarcticSpSummonCondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function Auxiliary.UrsarcticReleaseFilter(c)
	return c:IsLevelAbove(7) and c:IsLocation(LOCATION_HAND)
end
function Auxiliary.UrsarcticExCostFilter(c,tp)
	return c:IsAbleToRemoveAsCost() and (c:IsHasEffect(16471775,tp) or c:IsHasEffect(89264428,tp))
end
function Auxiliary.UrsarcticSpSummonCost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetReleaseGroup(tp,true):Filter(Auxiliary.UrsarcticReleaseFilter,e:GetHandler())
	local g2=Duel.GetMatchingGroup(Auxiliary.UrsarcticExCostFilter,tp,LOCATION_GRAVE,0,nil,tp)
	g1:Merge(g2)
	if chk==0 then return g1:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g1:Select(tp,1,1,nil):GetFirst()
	local te=tc:IsHasEffect(16471775,tp) or tc:IsHasEffect(89264428,tp)
	if te then
		te:UseCountLimit(tp)
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
	else
		Duel.Release(tc,REASON_COST)
	end
end
function Auxiliary.UrsarcticSpSummonTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function Auxiliary.UrsarcticSpSummonOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(Auxiliary.UrsarcticSpSummonLimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function Auxiliary.UrsarcticSpSummonLimit(e,c)
	return c:IsLevel(0)
end
--Drytron common summon effect
function Auxiliary.AddDrytronSpSummonEffect(c,func)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCost(Auxiliary.DrytronSpSummonCost)
	e1:SetTarget(Auxiliary.DrytronSpSummonTarget)
	e1:SetOperation(Auxiliary.DrytronSpSummonOperation(func))
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(97148796,ACTIVITY_SPSUMMON,Auxiliary.DrytronCounterFilter)
	return e1
end
function Auxiliary.DrytronCounterFilter(c)
	return not c:IsSummonableCard()
end
function Auxiliary.DrytronCostFilter(c,tp)
	return (c:IsSetCard(0x154) or c:IsType(TYPE_RITUAL)) and c:IsType(TYPE_MONSTER) and Duel.GetMZoneCount(tp,c)>0
		and (c:IsControler(tp) or c:IsFaceup())
end
function Auxiliary.DrytronExtraCostFilter(c,tp)
	return c:IsAbleToRemove() and c:IsHasEffect(89771220,tp)
end
function Auxiliary.DrytronSpSummonCost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	local g1=Duel.GetReleaseGroup(tp,true):Filter(Auxiliary.DrytronCostFilter,e:GetHandler(),tp)
	local g2=Duel.GetMatchingGroup(Auxiliary.DrytronExtraCostFilter,tp,LOCATION_GRAVE,0,nil,tp)
	g1:Merge(g2)
	if chk==0 then return #g1>0 and Duel.GetCustomActivityCount(97148796,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(Auxiliary.DrytronSpSummonLimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--cant special summon summonable card check
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(97148796)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g1:Select(tp,1,1,nil)
	local tc=rg:GetFirst()
	local te=tc:IsHasEffect(89771220,tp)
	if te then
		te:UseCountLimit(tp)
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
	else
		Auxiliary.UseExtraReleaseCount(rg,tp)
		Duel.Release(tc,REASON_COST)
	end
end
function Auxiliary.DrytronSpSummonLimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsSummonableCard()
end
function Auxiliary.DrytronSpSummonTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=e:GetLabel()==100 or Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then
		e:SetLabel(0)
		return res and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
	end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function Auxiliary.DrytronSpSummonOperation(func)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) then return end
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then func(e,tp) end
	end
end
--additional destroy effect for the Labrynth field
function Auxiliary.LabrynthDestroyOp(e,tp,res)
	local c=e:GetHandler()
	local chk=not c:IsStatus(STATUS_ACT_FROM_HAND) and c:IsSetCard(0x117e) and c:GetType()==TYPE_TRAP and e:IsHasType(EFFECT_TYPE_ACTIVATE)
	local exc=nil
	if c:IsStatus(STATUS_LEAVE_CONFIRMED) then exc=c end
	local te=Duel.IsPlayerAffectedByEffect(tp,33407125)
	if chk and te
		and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,exc)
		and Duel.SelectYesNo(tp,aux.Stringid(33407125,0)) then
		if res>0 then Duel.BreakEffect() end
		Duel.Hint(HINT_CARD,0,33407125)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,exc)
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
		te:UseCountLimit(tp)
	end
end
--shortcut for Gizmek cards
function Auxiliary.AtkEqualsDef(c)
	if not c:IsType(TYPE_MONSTER) or c:IsType(TYPE_LINK) then return false end
	if c:GetAttack()~=c:GetDefense() then return false end
	return c:IsLocation(LOCATION_MZONE) or c:GetTextAttack()>=0 and c:GetTextDefense()>=0
end
--shortcut for self-banish costs
function Auxiliary.bfgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
--check for cards with different names
function Auxiliary.dncheck(g)
	return g:GetClassCount(Card.GetCode)==#g
end
--check for cards with different levels
function Auxiliary.dlvcheck(g)
	return g:GetClassCount(Card.GetLevel)==#g
end
--check for cards with different ranks
function Auxiliary.drkcheck(g)
	return g:GetClassCount(Card.GetRank)==#g
end
--check for cards with different links
function Auxiliary.dlkcheck(g)
	return g:GetClassCount(Card.GetLink)==#g
end
--check for cards with different attributes
function Auxiliary.dabcheck(g)
	return g:GetClassCount(Card.GetAttribute)==#g
end
--check for cards with different races
function Auxiliary.drccheck(g)
	return g:GetClassCount(Card.GetRace)==#g
end
--check for group with 2 cards, each card match f with a1/a2 as argument
function Auxiliary.gfcheck(g,f,a1,a2)
	if #g~=2 then return false end
	local c1=g:GetFirst()
	local c2=g:GetNext()
	return f(c1,a1) and f(c2,a2) or f(c2,a1) and f(c1,a2)
end
--check for group with 2 cards, each card match f1 with a1, f2 with a2 as argument
function Auxiliary.gffcheck(g,f1,a1,f2,a2)
	if #g~=2 then return false end
	local c1=g:GetFirst()
	local c2=g:GetNext()
	return f1(c1,a1) and f2(c2,a2) or f1(c2,a1) and f2(c1,a2)
end
function Auxiliary.mzctcheck(g,tp)
	return Duel.GetMZoneCount(tp,g)>0
end
function Auxiliary.mzctcheckrel(g,tp)
	return Duel.GetMZoneCount(tp,g)>0 and Duel.CheckReleaseGroup(tp,Auxiliary.IsInGroup,#g,nil,g)
end
--used for "except this card"
function Auxiliary.ExceptThisCard(e)
	local c=e:GetHandler()
	if c:IsRelateToChain() then return c else return nil end
end
--used for multi-linked zone(zone linked by two or more link monsters)
function Auxiliary.GetMultiLinkedZone(tp)
	local f=function(c)
		return c:IsFaceup() and c:IsType(TYPE_LINK)
	end
	local lg=Duel.GetMatchingGroup(f,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local multi_linked_zone=0
	local single_linked_zone=0
	for tc in aux.Next(lg) do
		local zone=tc:GetLinkedZone(tp)&0x7f
		multi_linked_zone=single_linked_zone&zone|multi_linked_zone
		single_linked_zone=single_linked_zone~zone
	end
	return multi_linked_zone
end
Auxiliary.SubGroupCaptured=nil
Auxiliary.GCheckAdditional=nil
function Auxiliary.CheckGroupRecursive(c,sg,g,f,min,max,ext_params)
	sg:AddCard(c)
	if Auxiliary.GCheckAdditional and not Auxiliary.GCheckAdditional(sg,c,g,f,min,max,ext_params) then
		sg:RemoveCard(c)
		return false
	end
	local res=(#sg>=min and #sg<=max and f(sg,table.unpack(ext_params)))
		or (#sg<max and g:IsExists(Auxiliary.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params))
	sg:RemoveCard(c)
	return res
end
function Auxiliary.CheckGroupRecursiveCapture(c,sg,g,f,min,max,ext_params)
	sg:AddCard(c)
	if Auxiliary.GCheckAdditional and not Auxiliary.GCheckAdditional(sg,c,g,f,min,max,ext_params) then
		sg:RemoveCard(c)
		return false
	end
	local res=#sg>=min and #sg<=max and f(sg,table.unpack(ext_params))
	if res then
		Auxiliary.SubGroupCaptured:Clear()
		Auxiliary.SubGroupCaptured:Merge(sg)
	else
		res=#sg<max and g:IsExists(Auxiliary.CheckGroupRecursiveCapture,1,sg,sg,g,f,min,max,ext_params)
	end
	sg:RemoveCard(c)
	return res
end
function Group.CheckSubGroup(g,f,min,max,...)
	local min=min or 1
	local max=max or #g
	if min>max then return false end
	local ext_params={...}
	local sg=Duel.GrabSelectedCard()
	if #sg>max or #(g+sg)<min then return false end
	if #sg==max and (not f(sg,...) or Auxiliary.GCheckAdditional and not Auxiliary.GCheckAdditional(sg,nil,g,f,min,max,ext_params)) then return false end
	if #sg>=min and #sg<=max and f(sg,...) and (not Auxiliary.GCheckAdditional or Auxiliary.GCheckAdditional(sg,nil,g,f,min,max,ext_params)) then return true end
	local eg=g:Clone()
	for c in aux.Next(g-sg) do
		if Auxiliary.CheckGroupRecursive(c,sg,eg,f,min,max,ext_params) then return true end
		eg:RemoveCard(c)
	end
	return false
end
function Group.SelectSubGroup(g,tp,f,cancelable,min,max,...)
	Auxiliary.SubGroupCaptured=Group.CreateGroup()
	local min=min or 1
	local max=max or #g
	local ext_params={...}
	local sg=Group.CreateGroup()
	local fg=Duel.GrabSelectedCard()
	if #fg>max or min>max or #(g+fg)<min then return nil end
	for tc in aux.Next(fg) do
		fg:SelectUnselect(sg,tp,false,false,min,max)
	end
	sg:Merge(fg)
	local finish=(#sg>=min and #sg<=max and f(sg,...))
	while #sg<max do
		local cg=Group.CreateGroup()
		local eg=g:Clone()
		for c in aux.Next(g-sg) do
			if not cg:IsContains(c) then
				if Auxiliary.CheckGroupRecursiveCapture(c,sg,eg,f,min,max,ext_params) then
					cg:Merge(Auxiliary.SubGroupCaptured)
				else
					eg:RemoveCard(c)
				end
			end
		end
		cg:Sub(sg)
		finish=(#sg>=min and #sg<=max and f(sg,...))
		if #cg==0 then break end
		local cancel=not finish and cancelable
		local tc=cg:SelectUnselect(sg,tp,finish,cancel,min,max)
		if not tc then break end
		if not fg:IsContains(tc) then
			if not sg:IsContains(tc) then
				sg:AddCard(tc)
				if #sg==max then finish=true end
			else
				sg:RemoveCard(tc)
			end
		elseif cancelable then
			return nil
		end
	end
	if finish then
		return sg
	else
		return nil
	end
end
function Auxiliary.CreateChecks(f,list)
	local checks={}
	for i=1,#list do
		checks[i]=function(c) return f(c,list[i]) end
	end
	return checks
end
function Auxiliary.CheckGroupRecursiveEach(c,sg,g,f,checks,ext_params)
	if not checks[1+#sg](c) then
		return false
	end
	sg:AddCard(c)
	if Auxiliary.GCheckAdditional and not Auxiliary.GCheckAdditional(sg,c,g,f,min,max,ext_params) then
		sg:RemoveCard(c)
		return false
	end
	local res
	if #sg==#checks then
		res=f(sg,table.unpack(ext_params))
	else
		res=g:IsExists(Auxiliary.CheckGroupRecursiveEach,1,sg,sg,g,f,checks,ext_params)
	end
	sg:RemoveCard(c)
	return res
end
function Group.CheckSubGroupEach(g,checks,f,...)
	if f==nil then f=Auxiliary.TRUE end
	if #g<#checks then return false end
	local ext_params={...}
	local sg=Group.CreateGroup()
	return g:IsExists(Auxiliary.CheckGroupRecursiveEach,1,sg,sg,g,f,checks,ext_params)
end
function Group.SelectSubGroupEach(g,tp,checks,cancelable,f,...)
	if cancelable==nil then cancelable=false end
	if f==nil then f=Auxiliary.TRUE end
	local ct=#checks
	local ext_params={...}
	local sg=Group.CreateGroup()
	local finish=false
	while #sg<ct do
		local cg=g:Filter(Auxiliary.CheckGroupRecursiveEach,sg,sg,g,f,checks,ext_params)
		if #cg==0 then break end
		local tc=cg:SelectUnselect(sg,tp,false,cancelable,ct,ct)
		if not tc then break end
		if not sg:IsContains(tc) then
			sg:AddCard(tc)
			if #sg==ct then finish=true end
		else
			sg:Clear()
		end
	end
	if finish then
		return sg
	else
		return nil
	end
end
--condition of "negate activation and banish"
function Auxiliary.nbcon(tp,re)
	local rc=re:GetHandler()
	return Duel.IsPlayerCanRemove(tp)
		and (not rc:IsRelateToEffect(re) or rc:IsAbleToRemove())
end
function Auxiliary.nbtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
	if re:GetActivateLocation()==LOCATION_GRAVE then
		e:SetCategory(e:GetCategory()|CATEGORY_GRAVE_ACTION)
	else
		e:SetCategory(e:GetCategory()&~CATEGORY_GRAVE_ACTION)
	end
end
--condition of "negate activation and return to deck"
function Auxiliary.ndcon(tp,re)
	local rc=re:GetHandler()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) or not rc:IsRelateToEffect(re) or rc:IsAbleToDeck()
end
--return the global index of the zone in (p,loc,seq)
function Auxiliary.SequenceToGlobal(p,loc,seq)
	if p~=0 and p~=1 then
		return 0
	end
	if loc==LOCATION_MZONE then
		if seq<=6 then
			return 0x0001<<(16*p+seq)
		else
			return 0
		end
	elseif loc == LOCATION_SZONE then
		if seq<=4 then
			return 0x0100<<(16*p+seq)
		else
			return 0
		end
	else
		return 0
	end
end
--use the count limit of Lair of Darkness if the tributes are not selected by Duel.SelectReleaseGroup
function Auxiliary.UseExtraReleaseCount(g,tp)
	local eg=g:Filter(Auxiliary.ExtraReleaseFilter,nil,tp)
	for ec in Auxiliary.Next(eg) do
		local te=ec:IsHasEffect(EFFECT_EXTRA_RELEASE_NONSUM,tp)
		if te then te:UseCountLimit(tp) end
	end
end
function Auxiliary.ExtraReleaseFilter(c,tp)
	return c:IsControler(1-tp) and c:IsHasEffect(EFFECT_EXTRA_RELEASE_NONSUM,tp)
end
function Auxiliary.IsSpecialSummonedByEffect(e)
	return not ((e:GetCode()==EFFECT_SPSUMMON_PROC or e:GetCode()==EFFECT_SPSUMMON_PROC_G) and e:GetProperty()&(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)==(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE))
end
--
function Auxiliary.GetCappedLevel(c)
	local lv=c:GetLevel()
	if lv>MAX_PARAMETER then
		return MAX_PARAMETER
	else
		return lv
	end
end
--
function Auxiliary.GetCappedAttack(c)
	local x=c:GetAttack()
	if x>MAX_PARAMETER then
		return MAX_PARAMETER
	else
		return x
	end
end
--when this card is sent to grave, record the reason effect
--to check whether the reason effect do something simultaneously
--so the "while this card is in your GY" condition isn't met
function Auxiliary.AddThisCardInGraveAlreadyCheck(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(Auxiliary.ThisCardInGraveAlreadyCheckReg)
	c:RegisterEffect(e1)
	return e1
end
function Auxiliary.ThisCardInGraveAlreadyCheckReg(e,tp,eg,ep,ev,re,r,rp)
	--condition of continous effect will be checked before other effects
	if re==nil then return false end
	if e:GetLabelObject()~=nil then return false end
	if (r&REASON_EFFECT)>0 then
		e:SetLabelObject(re)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_END)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetOperation(Auxiliary.ThisCardInGraveAlreadyReset1)
		e1:SetLabelObject(e)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_BREAK_EFFECT)
		e2:SetOperation(Auxiliary.ThisCardInGraveAlreadyReset2)
		e2:SetReset(RESET_CHAIN)
		e2:SetLabelObject(e1)
		Duel.RegisterEffect(e2,tp)
	elseif (r&REASON_MATERIAL)>0 or not re:IsActivated() and (r&REASON_COST)>0 then
		e:SetLabelObject(re)
		local reset_event=EVENT_SPSUMMON
		if re:GetCode()~=EFFECT_SPSUMMON_PROC then reset_event=EVENT_SUMMON end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(reset_event)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetOperation(Auxiliary.ThisCardInGraveAlreadyReset1)
		e1:SetLabelObject(e)
		Duel.RegisterEffect(e1,tp)
	end
	return false
end
function Auxiliary.ThisCardInGraveAlreadyReset1(e)
	--this will run after EVENT_SPSUMMON_SUCCESS
	e:GetLabelObject():SetLabelObject(nil)
	e:Reset()
end
function Auxiliary.ThisCardInGraveAlreadyReset2(e)
	local e1=e:GetLabelObject()
	e1:GetLabelObject():SetLabelObject(nil)
	e1:Reset()
	e:Reset()
end
--Player p place g on the top of Deck in any order
function Auxiliary.PlaceCardsOnDeckTop(p,g,reason)
	if reason==nil then reason=REASON_EFFECT end
	Duel.SendtoDeck(g,nil,SEQ_DECKTOP,reason)
	local rg=Duel.GetOperatedGroup()
	local og=rg:Filter(Card.IsLocation,nil,LOCATION_DECK)
	local ct1=og:FilterCount(Card.IsControler,nil,p)
	local ct2=og:FilterCount(Card.IsControler,nil,1-p)
	if ct1>1 then
		Duel.SortDecktop(p,p,ct1)
	end
	if ct2>1 then
		Duel.SortDecktop(p,1-p,ct2)
	end
	return #rg
end
--Player p place g on the bottom of Deck in any order
function Auxiliary.PlaceCardsOnDeckBottom(p,g,reason)
	if reason==nil then reason=REASON_EFFECT end
	Duel.SendtoDeck(g,nil,SEQ_DECKTOP,reason)
	local rg=Duel.GetOperatedGroup()
	local og=rg:Filter(Card.IsLocation,nil,LOCATION_DECK)
	local ct1=og:FilterCount(Card.IsControler,nil,p)
	local ct2=og:FilterCount(Card.IsControler,nil,1-p)
	if ct1>0 then
		if ct1>1 then
			Duel.SortDecktop(p,p,ct1)
		end
		for i=1,ct1 do
			local tc=Duel.GetDecktopGroup(p,1):GetFirst()
			Duel.MoveSequence(tc,SEQ_DECKBOTTOM)
		end
	end
	if ct2>0 then
		if ct2>1 then
			Duel.SortDecktop(p,1-p,ct2)
		end
		for i=1,ct2 do
			local tc=Duel.GetDecktopGroup(1-p,1):GetFirst()
			Duel.MoveSequence(tc,SEQ_DECKBOTTOM)
		end
	end
	return #rg
end
--The event is triggered multiple times in a chain
--but only 1 event with EVENT_CUSTOM+code will be triggered at EVENT_CHAIN_END, or immediately if not in chain
--NOTE: re,r,rp,ep,ev of that custom event ARE NOT releated to the real event that trigger this custom event
function Auxiliary.RegisterMergedDelayedEvent(c,code,event,g)
	local mt=getmetatable(c)
	if mt[event]==true then return end
	mt[event]=true
	if not g then g=Group.CreateGroup() end
	g:KeepAlive()
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(event)
	ge1:SetLabel(code)
	ge1:SetLabelObject(g)
	ge1:SetOperation(Auxiliary.MergedDelayEventCheck1)
	Duel.RegisterEffect(ge1,0)
	local ge2=ge1:Clone()
	ge2:SetCode(EVENT_CHAIN_END)
	ge2:SetOperation(Auxiliary.MergedDelayEventCheck2)
	Duel.RegisterEffect(ge2,0)
end
function Auxiliary.MergedDelayEventCheck1(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	g:Merge(eg)
	if Duel.GetCurrentChain()==0 and not Duel.CheckEvent(EVENT_CHAIN_END) then
		local _eg=g:Clone()
		Duel.RaiseEvent(_eg,EVENT_CUSTOM+e:GetLabel(),re,r,rp,ep,ev)
		g:Clear()
	end
end
function Auxiliary.MergedDelayEventCheck2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if #g>0 then
		local _eg=g:Clone()
		Duel.RaiseEvent(_eg,EVENT_CUSTOM+e:GetLabel(),re,r,rp,ep,ev)
		g:Clear()
	end
end
--B.E.S. remove counter
function Auxiliary.EnableBESRemove(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(10)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(Auxiliary.RemoveCondtion)
	e1:SetTarget(Auxiliary.RemoveTarget)
	e1:SetOperation(Auxiliary.RemoveOperation)
	c:RegisterEffect(e1)
end
function Auxiliary.RemoveCondtion(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle()
end
function Auxiliary.RemoveTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if not e:GetHandler():IsCanRemoveCounter(tp,0x1f,1,REASON_EFFECT) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	end
end
function Auxiliary.RemoveOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if c:IsCanRemoveCounter(tp,0x1f,1,REASON_EFFECT) then
			c:RemoveCounter(tp,0x1f,1,REASON_EFFECT)
		else
			Duel.Destroy(c,REASON_EFFECT)
		end
	end
end
--The operation function of "destroy during End Phase"
function Auxiliary.EPDestroyOperation(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT,LOCATION_GRAVE,tc:GetControler())
end
