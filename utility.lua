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
	w=width or 1
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
function Auxiliary.IsDualState(effect)
	local c=effect:GetHandler()
	return not c:IsDisabled() and c:IsDualState()
end
function Auxiliary.IsNotDualState(effect)
	local c=effect:GetHandler()
	return c:IsDisabled() or not c:IsDualState()
end
function Auxiliary.DualNormalCondition(effect)
	local c=effect:GetHandler()
	return c:IsFaceup() and not c:IsDualState()
end
function Auxiliary.EnableDualAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DUAL_SUMMONABLE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCondition(aux.DualNormalCondition)
	e2:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_REMOVE_TYPE)
	e3:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e3)
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
function Auxiliary.Tuner(f,...)
	local ext_params={...}
	return	function(target)
				return target:IsType(TYPE_TUNER) and (not f or f(target,table.unpack(ext_params)))
			end
end
function Auxiliary.NonTuner(f,...)
	local ext_params={...}
	return	function(target,syncard)
				return target:IsNotTuner(syncard) and (not f or f(target,table.unpack(ext_params)))
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
function Auxiliary.GetMustMaterialGroup(tp,code)
	local g=Group.CreateGroup()
	local ce={Duel.IsPlayerAffectedByEffect(tp,code)}
	for _,te in ipairs(ce) do
		local tc=te:GetHandler()
		if tc then g:AddCard(tc) end
	end
	return g
end
function Auxiliary.MustMaterialCheck(v,tp,code)
	local g=Auxiliary.GetMustMaterialGroup(tp,code)
	if not v then
		if code==EFFECT_MUST_BE_XMATERIAL and Duel.IsPlayerAffectedByEffect(tp,67120578) then return false end
		return #g==0
	end
	local t=Auxiliary.GetValueType(v)
	for tc in Auxiliary.Next(g) do
		if (t=="Card" and v~=tc)
			or (t=="Group" and not v:IsContains(tc)) then return false end
	end
	return true
end
function Auxiliary.MustMaterialCounterFilter(c,g)
	return not g:IsContains(c)
end
--Synchro monster, using min to max monsters that fits a goal
--filter: function(c,sync) cards that do not pass this filter are never considered potential materials, unless any assumes are in effect (genomix fighter)
--goal: function(g,sync) a group restriction imposed on the whole synchro material group
function Auxiliary.AddSynchroProcedureUltimate(c,filter,goal,minc,maxc)
	if maxc==nil then maxc=99 end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1164)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Auxiliary.SynConditionUltimate(filter,goal,minc,maxc))
	e1:SetTarget(Auxiliary.SynTargetUltimate(filter,goal,minc,maxc))
	e1:SetOperation(Auxiliary.SynOperationUltimate(filter,goal,minc,maxc))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	return e1
end
function Auxiliary.SynMaterialFilter(c,sync,filter,hassyncheck,he,hf)
	return c:IsFaceupEx() and c:IsCanBeSynchroMaterial(sync) and (hassyncheck or not filter or not sync or filter(c,sync))
		and (not c:IsLocation(LOCATION_MZONE) or c:GetControler()==sync:GetControler() or c:IsHasEffect(EFFECT_SYNCHRO_MATERIAL))
		and (not hf or hf(he,c,sync))
end
function Auxiliary.SynHandMaterialFilter(c,sync,he,hf)
	return c:IsLocation(LOCATION_HAND) and (not hf or hf(he,c,sync))
end
Auxiliary.SynMaterialForceInclude=nil
Auxiliary.SynMaterialForceExclude=nil
function Auxiliary.GetSynMaterials(tp,sync,lv,filter,hassyncheck,smat,og)
	local mg=nil
	if og then
		mg=og:Filter(Auxiliary.SynMaterialFilter,nil,sync,filter,hassyncheck)
	else
		mg=Duel.GetMatchingGroup(Auxiliary.SynMaterialFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,sync,filter,hassyncheck)
	end

	if smat then
		if not Auxiliary.SynMaterialFilter(smat,sync,filter,hassyncheck) then return nil end
		mg:AddCard(smat)
	end

	local fi=Auxiliary.SynMaterialForceInclude
	local vfi=Auxiliary.GetValueType(fi)
	if vfi=="Card" then
		if Auxiliary.SynMaterialFilter(fi,sync,filter,hassyncheck) then
			mg:AddCard(fi)
		end
	elseif vfi=="Group" then
		local mgi=fi:Filter(Auxiliary.SynMaterialFilter,nil,sync,filter,hassyncheck)
		if #mgi>0 then
			mg:Merge(mgi)
		end
	end

	local fe=Auxiliary.SynMaterialForceExclude
	local vfe=Auxiliary.GetValueType(fe)
	if vfe=="Card" then
		if smat==fe then return nil end
		mg:RemoveCard(fe)
	elseif vfe=="Group" then
		if smat and vfe:IsContains(smat) then return nil end
		mg:Sub(vfe)
	end

	--check hand synchro
	local mg2=nil
	local mga=nil
	local hand_max=0
	for mc in aux.Next(mg) do
		local he,hf,hmin,hmax=mc:GetHandSynchro()
		if he then
			local mgx=nil
			if og then
				mgx=mg:Filter(Auxiliary.SynHandMaterialFilter,nil,sync,he,hf)
			else
				mgx=Duel.GetMatchingGroup(Auxiliary.SynMaterialFilter,tp,LOCATION_HAND,0,nil,sync,filter,he,hf)
			end
			local mgxc=#mgx
			if mgxc<hmin then
				if smat==mc then return nil end
				if mga then mga:AddCard(mc) else mga=Group.FromCards(mc) end
			elseif mgxc>0 then
				hand_max=math.max(hand_max,math.min(hmax,#mgx))
				if not og then
					if mg2 then mg2:Merge(mgx) else mg2=mgx end
				end
			end
		end
	end
	if mga then mg:Sub(mga) end

	--check mono synchron
	local check_mono=mg:IsExists(Card.IsHasEffect,1,nil,56897896)
		or mg2 and mg2:IsExists(Card.IsHasEffect,1,nil,56897896)
	if check_mono and lv>(#mg+hand_max) then
		if smat and smat:IsHasEffect(56897896) then return false end
		check_mono=false
		mg=mg:Filter(aux.NOT(Card.IsHasEffect),nil,56897896)
		if mg2 then
			mg2=mg2:Filter(aux.NOT(Card.IsHasEffect),nil,56897896)
		end
	end

	local field_count=#mg
	if mg2 then mg:Merge(mg2) end
	return mg,field_count,hand_max,check_mono
end
Auxiliary.SCheckAdditional=nil
Auxiliary.SCheckAdditionalLimbo={}
Auxiliary.SGCheckAdditional=nil
function Auxiliary.SynCheckAdditionalLevel(c,sync)
	local raw_level=c:GetSynchroLevel(sync)
	local lv1=raw_level&0xffff
	local lv2=raw_level>>16
	if lv2>0 then
		return math.min(lv1,lv2)
	else
		return lv1
	end
end
function Auxiliary.SynCheckAdditional(sync,lv,minc,maxc,syncheck,check_mono,check_cardian,check_hand,hand_max)
	return function (sg)
		Auxiliary.ApplyAssume(sg,syncheck)

		if Auxiliary.SGCheckAdditional and not Auxiliary.SGCheckAdditional(sg,sync) then
			Duel.AssumeReset()
			return false
		end

		--simple hand synchro check
		if check_hand and sg:IsExists(Card.IsLocation,hand_max+1,nil,LOCATION_HAND) then
			Duel.AssumeReset()
			return false
		end

		--simple synchro level check
		if not Auxiliary.SynCheckAdditionalLevelCheck(sg,sync,lv,minc,maxc,check_mono,check_cardian) then
			Duel.AssumeReset()
			return false
		end

		Duel.AssumeReset()
		return true
	end
end
function Auxiliary.SynCheckAdditionalLevelCheck(sg,sync,lv,minc,maxc,check_mono,check_cardian)
	if check_mono then
		local sum=#sg
		if sum<lv or sum==lv and sum>=minc and sum<=maxc and sg:IsExists(Card.IsHasEffect,1,nil,56897896) then return true end
	end
	if check_cardian then
		local sum=(#sg*2)
		if sum<lv or sum==lv and #sg>=minc and #sg<=maxc and sg:IsExists(Card.IsHasEffect,1,nil,89818984) then return true end
	end
	local sum=sg:GetSum(Auxiliary.SynCheckAdditionalLevel,sync)
	return sum<lv or sum==lv and #sg>=minc and #sg<=maxc
end
function Auxiliary.SynUltimateGoal(sg,tp,sync,lv,goal,smat,syncheck,check_mono,check_cardian,check_hand,check_tuner_limit)
	--misc
	if smat and not sg:IsContains(smat) then return false end
	if Duel.GetLocationCountFromEx(tp,tp,sg,sync)<=0 then return false end

	Auxiliary.ApplyAssume(sg,syncheck)

	if (Auxiliary.SCheckAdditional and not Auxiliary.SCheckAdditional(sg,sync,tp)) then
		Duel.AssumeReset()
		return false
	end

	local limbo=Auxiliary.SCheckAdditionalLimbo[sync:GetFieldID()]
	if limbo and not limbo(sg,sync,tp) then
		Duel.AssumeReset()
		return false
	end

	--mono synchron level check
	local used_any_mono=false
	if check_mono then
		local mc=sg:SearchCard(Card.IsHasEffect,56897896)
		if mc then
			used_any_mono=true
			if sg:IsExists(Card.IsHasEffect,1,mc,56897896) then
				if lv~=#sg then
					Duel.AssumeReset()
					return false
				end
			else
				local raw_level=mc:GetSynchroLevel(sync)
				local lv1=raw_level&0xffff
				local lv2=raw_level>>16
				if not (lv==(lv1+#sg-1) or lv2>0 and lv==(lv2+#sg-1)) then
					Duel.AssumeReset()
					return false
				end
			end
		end
	end

	--ordinary & cardian level check
	if not used_any_mono then
		if not (sg:CheckWithSumEqual(Card.GetSynchroLevel,lv,#sg,#sg,sync)
			or check_cardian and sg:IsExists(Card.IsHasEffect,1,nil,89818984) and (lv==#sg*2)) then
			Duel.AssumeReset()
			return false
		end
	end

	--synchro material requirement
	if (goal and not goal(sg,sync))
		or (check_hand and not Auxiliary.SynGoalHandSynchro(sg,sync))
		or (check_tuner_limit and not Auxiliary.SynGoalTunerLimit(sg,sync)) then
		Duel.AssumeReset()
		return false
	end

	Duel.AssumeReset()
	return true
end
function Auxiliary.ApplyAssume(sg,syncheck)
	if #syncheck>0 then
		for _, sce in pairs(syncheck) do
			if sg:IsContains(sce:GetHandler()) then
				local f=sce:GetValue()
				for c in aux.Next(sg) do
					f(sce,c)
				end
			end
		end
	end
end
function Auxiliary.SynGoalHandSynchro(sg,sync)
	local hg=sg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	local hct=#hg
	if hct>0 then
		for c in aux.Next(sg-hg) do
			local he,hf,hmin,hmax=c:GetHandSynchro()
			if he then
				if hf and hg:IsExists(Auxiliary.SynLimitFilter,1,c,hf,he,sync) then return false end
				if (hmin and hct<hmin) or (hmax and hct>hmax) then return false end
			end
		end
	end
	return true
end
function Auxiliary.SynGoalTunerLimit(sg,sync)
	for c in aux.Next(sg) do
		local le,lf,lloc,lmin,lmax=c:GetTunerLimit()
		if le then
			if lloc and sg:IsExists(aux.NOT(Card.IsLocation,lloc),1,c) then return false end
			if lf and sg:IsExists(Auxiliary.SynLimitFilter,1,c,lf,le,sync) then return false end
			local lct=#sg-1
			if (lmin and lct<lmin) or (lmax and lct>lmax) then return false end
		end
	end
	return true
end
function Auxiliary.SynLimitFilter(c,f,e,sync)
	return f and not f(e,c,sync)
end
function Auxiliary.SynConditionUltimate(filter,goal,minc,maxc)
	return	function(e,c,smat,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local tp=c:GetControler()
				local lv=c:GetLevel()
				local syncheck={Duel.IsPlayerAffectedByEffect(tp,EFFECT_SYNCHRO_CHECK)}
				local mg,field_count,hand_max,check_mono=Auxiliary.GetSynMaterials(tp,c,lv,filter,#syncheck>0,smat,og)
				if mg==nil then return false end
				maxc=math.min(maxc,field_count+hand_max)
				if maxc<minc then return false end
				local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_SMATERIAL)
				if fg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(fg)
				local check_cardian=(lv%2)==0 and mg:IsExists(Card.IsHasEffect,1,nil,89818984)
				local check_hand=hand_max>0
				local check_tuner_limit=mg:IsExists(Card.GetTunerLimit,1,nil)
				Auxiliary.GCheckAdditional=Auxiliary.SynCheckAdditional(c,lv,minc,maxc,syncheck,check_mono,check_cardian,check_hand,hand_max)
				local res=mg:CheckSubGroup(Auxiliary.SynUltimateGoal,minc,maxc,tp,c,lv,goal,smat,syncheck,check_mono,check_cardian,check_hand,check_tuner_limit)
				Auxiliary.GCheckAdditional=nil
				return res
			end
end
function Auxiliary.SynTargetUltimate(filter,goal,minc,maxc)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,og,min,max)
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local lv=c:GetLevel()
				local syncheck={Duel.IsPlayerAffectedByEffect(tp,EFFECT_SYNCHRO_CHECK)}
				local mg,field_count,hand_max,check_mono=Auxiliary.GetSynMaterials(tp,c,lv,filter,#syncheck>0,smat,og)
				if mg==nil then return false end
				maxc=math.min(maxc,field_count+hand_max)
				if maxc<minc then return false end
				local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_SMATERIAL)
				Duel.SetSelectedCard(fg)
				local check_cardian=(lv%2)==0 and mg:IsExists(Card.IsHasEffect,1,nil,89818984)
				local check_hand=hand_max>0
				local check_tuner_limit=mg:IsExists(Card.GetTunerLimit,1,nil)
				Auxiliary.GCheckAdditional=Auxiliary.SynCheckAdditional(c,lv,minc,maxc,syncheck,check_mono,check_cardian,check_hand,hand_max)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				local sg=mg:SelectSubGroup(tp,Auxiliary.SynUltimateGoal,cancel,minc,maxc,tp,c,lv,goal,smat,syncheck,check_mono,check_cardian,check_hand,check_tuner_limit)
				Auxiliary.GCheckAdditional=nil
				if sg and #sg>0 then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					Auxiliary.SCheckAdditionalLimbo[c:GetFieldID()]=nil
					return true
				else return false end
			end
end
function Auxiliary.SynHandSynchroAdditionalOperation(mg,sync,tp)
	local hg=mg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	local hct=#hg
	if hct>0 then
		for c in aux.Next(mg-hg) do
			local he,hf,hmin,hmax=c:GetHandSynchro()
			if he then
				if (not hmin or hct>=hmin) and (not hmax or hct<=hmax)
					and (not hf or not hg:IsExists(Auxiliary.SynLimitFilter,1,c,hf,he,sync)) then
					local op=he:GetOperation()
					if op then op(te,tp,c,g) end
					break
				end
			end
		end
	end
end
function Auxiliary.SynOperationUltimate(filter,goal,minc,maxc)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,smat,og,min,max)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				Auxiliary.SynHandSynchroAdditionalOperation(g,c,tp)
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
				g:DeleteGroup()
			end
end
--Synchro monster, 1 tuner + min to max monsters
--additionalGoal: a group restriction imposed on the whole synchro material group
--tunerAlterable: if true, disables the default behavior which requires f1 to be a tuner
function Auxiliary.AddSynchroProcedure(c,f1,f2,minc,maxc,additionalGoal,tunerAlterable)
	if not tunerAlterable then f1=aux.Tuner(f1) end
	local filter=function(c,sync) return not f1 or f1(c,sync) or not f2 or f2(c,sync) end
	local goal_filter=function(c,sync,g) return (not f1 or f1(c,sync)) and (not f2 or not g:IsExists(aux.NOT(f2),1,c,sync)) end
	local goal=function(g,sync) return g:IsExists(goal_filter,1,nil,sync,g) and (not additionalGoal or additionalGoal(g,sync)) end
	if maxc==nil then maxc=99 end
	return Auxiliary.AddSynchroProcedureUltimate(c,filter,goal,minc+1,maxc+1)
end
--Synchro monster, 1 tuner + 1 monster
--backward compatibility
function Auxiliary.AddSynchroProcedure2(c,f1,f2,additionalGoal,tunerAlterable)
	return Auxiliary.AddSynchroProcedure(c,f1,f2,1,1,additionalGoal,tunerAlterable)
end
--Synchro monster, f1~f3 each 1 MONSTER + f4 min to max monsters
function Auxiliary.AddSynchroMixProcedure(c,f1,f2,f3,f4,minc,maxc,additionalGoal)
	local checks={}
	if f1 then table.insert(checks,f1) end
	if f2 then table.insert(checks,f2) end
	if f3 then table.insert(checks,f3) end
	local filter=nil
	local goal=nil
	if #checks>0 then
		filter=Auxiliary.SynchroMixFilter(f4,aux.OR(table.unpack(checks)))
		goal=Auxiliary.SynchroMixGoal(checks,f4,additionalGoal)
	elseif f4 then
		filter=f4
		goal=Auxiliary.SynchroMixGoalDowngraded(f4,additionalGoal)
	else
		goal=additionalGoal
	end
	return Auxiliary.AddSynchroProcedureUltimate(c,filter,goal,minc+#checks,maxc+#checks)
end
function Auxiliary.SynchroMixFilter(f4,subfilter)
	return function(c,sync)
		return not f4 or f4(c,sync) or subfilter(c,sync)
	end
end
function Auxiliary.SynchroMixGoal(checks,otherFilter,additionalGoal)
	return function(g,sync)
		if additionalGoal and not additionalGoal(g,sync) then return false end
		local sg=Group.CreateGroup()
		return g:IsExists(Auxiliary.SynchroMixGoalRecursiveEach,1,sg,sg,g,sync,checks,otherFilter)
	end
end
function Auxiliary.SynchroMixGoalDowngraded(otherFilter,additionalGoal)
	return function(g,sync)
		if additionalGoal and not additionalGoal(g,sync) then return false end
		return not g:IsExists(aux.NOT(otherFilter),1,nil,sync)
	end
end
function Auxiliary.SynchroMixGoalRecursiveEach(c,sg,g,sync,checks,otherFilter)
	local check=checks[1+#sg]
	if check then
		if not check(c,sync,sg) then return false end
		sg:AddCard(c)
		local res=g:IsExists(Auxiliary.SynchroMixGoalRecursiveEach,1,sg,sg,g,sync,checks,otherFilter)
		sg:RemoveCard(c)
		return res
	else
		return not otherFilter or not g:IsExists(aux.NOT(otherFilter),1,sg,sync)
	end
end
--Checking Tune Magician
function Auxiliary.TuneMagicianFilter(c,e)
	local f=e:GetValue()
	return f(e,c)
end
function Auxiliary.TuneMagicianCheckX(c,sg,ecode)
	local eset={c:IsHasEffect(ecode)}
	for _,te in pairs(eset) do
		if sg:IsExists(Auxiliary.TuneMagicianFilter,1,c,te) then return true end
	end
	return false
end
function Auxiliary.TuneMagicianCheckAdditionalX(ecode)
	return	function(g)
				return not g:IsExists(Auxiliary.TuneMagicianCheckX,1,nil,g,ecode)
			end
end
function Auxiliary.XyzAlterFilter(c,alterf,xyzc,e,tp,alterop)
	return alterf(c) and c:IsCanBeXyzMaterial(xyzc) and Duel.GetLocationCountFromEx(tp,tp,c,xyzc)>0 and Auxiliary.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) and (not alterop or alterop(e,tp,0,c))
end
--Xyz monster, lv k*n
function Auxiliary.AddXyzProcedure(c,f,lv,ct,alterf,alterdesc,maxct,alterop)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1165)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	if not maxct then maxct=ct end
	if alterf then
		e1:SetCondition(Auxiliary.XyzConditionAlter(f,lv,ct,maxct,alterf,alterdesc,alterop))
		e1:SetTarget(Auxiliary.XyzTargetAlter(f,lv,ct,maxct,alterf,alterdesc,alterop))
		e1:SetOperation(Auxiliary.XyzOperationAlter(f,lv,ct,maxct,alterf,alterdesc,alterop))
	else
		e1:SetCondition(Auxiliary.XyzCondition(f,lv,ct,maxct))
		e1:SetTarget(Auxiliary.XyzTarget(f,lv,ct,maxct))
		e1:SetOperation(Auxiliary.XyzOperation(f,lv,ct,maxct))
	end
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
end
--Xyz Summon(normal)
function Auxiliary.XyzCondition(f,lv,minc,maxc)
	--og: use special material
	return	function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				return Duel.CheckXyzMaterial(c,f,lv,minc,maxc,og)
			end
end
function Auxiliary.XyzTarget(f,lv,minc,maxc)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local g=Duel.SelectXyzMaterial(tp,c,f,lv,minc,maxc,og)
				if g then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function Auxiliary.XyzOperation(f,lv,minc,maxc)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				if og and not min then
					local sg=Group.CreateGroup()
					local tc=og:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=og:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(og)
					Duel.Overlay(c,og)
				else
					local mg=e:GetLabelObject()
					local sg=Group.CreateGroup()
					local tc=mg:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=mg:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(mg)
					Duel.Overlay(c,mg)
					mg:DeleteGroup()
				end
			end
end
--Xyz summon(alterf)
function Auxiliary.XyzConditionAlter(f,lv,minc,maxc,alterf,alterdesc,alterop)
	return	function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				end
				if (not min or min<=1) and mg:IsExists(Auxiliary.XyzAlterFilter,1,nil,alterf,c,e,tp,alterop) then
					return true
				end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				return Duel.CheckXyzMaterial(c,f,lv,minc,maxc,og)
			end
end
function Auxiliary.XyzTargetAlter(f,lv,minc,maxc,alterf,alterdesc,alterop)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				end
				local b1=Duel.CheckXyzMaterial(c,f,lv,minc,maxc,og)
				local b2=(not min or min<=1) and mg:IsExists(Auxiliary.XyzAlterFilter,1,nil,alterf,c,e,tp,alterop)
				local g=nil
				if b2 and (not b1 or Duel.SelectYesNo(tp,alterdesc)) then
					e:SetLabel(1)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					g=mg:FilterSelect(tp,Auxiliary.XyzAlterFilter,1,1,nil,alterf,c,e,tp,alterop)
					if alterop then alterop(e,tp,1,g:GetFirst()) end
				else
					e:SetLabel(0)
					g=Duel.SelectXyzMaterial(tp,c,f,lv,minc,maxc,og)
				end
				if g then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function Auxiliary.XyzOperationAlter(f,lv,minc,maxc,alterf,alterdesc,alterop)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				if og and not min then
					local sg=Group.CreateGroup()
					local tc=og:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=og:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(og)
					Duel.Overlay(c,og)
				else
					local mg=e:GetLabelObject()
					if e:GetLabel()==1 then
						local mg2=mg:GetFirst():GetOverlayGroup()
						if mg2:GetCount()~=0 then
							Duel.Overlay(c,mg2)
						end
					else
						local sg=Group.CreateGroup()
						local tc=mg:GetFirst()
						while tc do
							local sg1=tc:GetOverlayGroup()
							sg:Merge(sg1)
							tc=mg:GetNext()
						end
						Duel.SendtoGrave(sg,REASON_RULE)
					end
					c:SetMaterial(mg)
					Duel.Overlay(c,mg)
					mg:DeleteGroup()
				end
			end
end
function Auxiliary.AddXyzProcedureLevelFree(c,f,gf,minc,maxc,alterf,alterdesc,alterop)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1165)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	if alterf then
		e1:SetCondition(Auxiliary.XyzLevelFreeConditionAlter(f,gf,minc,maxc,alterf,alterdesc,alterop))
		e1:SetTarget(Auxiliary.XyzLevelFreeTargetAlter(f,gf,minc,maxc,alterf,alterdesc,alterop))
		e1:SetOperation(Auxiliary.XyzLevelFreeOperationAlter(f,gf,minc,maxc,alterf,alterdesc,alterop))
	else
		e1:SetCondition(Auxiliary.XyzLevelFreeCondition(f,gf,minc,maxc))
		e1:SetTarget(Auxiliary.XyzLevelFreeTarget(f,gf,minc,maxc))
		e1:SetOperation(Auxiliary.XyzLevelFreeOperation(f,gf,minc,maxc))
	end
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
end
--Xyz Summon(level free)
function Auxiliary.XyzLevelFreeFilter(c,xyzc,f)
	return (not c:IsOnField() or c:IsFaceup()) and c:IsCanBeXyzMaterial(xyzc) and (not f or f(c,xyzc))
end
function Auxiliary.XyzLevelFreeGoal(g,tp,xyzc,gf)
	return (not gf or gf(g)) and Duel.GetLocationCountFromEx(tp,tp,g,xyzc)>0
end
function Auxiliary.XyzLevelFreeCondition(f,gf,minct,maxct)
	return	function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local minc=minct
				local maxc=maxct
				if min then
					minc=math.max(minc,min)
					maxc=math.min(maxc,max)
				end
				if maxc<minc then return false end
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.XyzLevelFreeFilter,nil,c,f)
				else
					mg=Duel.GetMatchingGroup(Auxiliary.XyzLevelFreeFilter,tp,LOCATION_MZONE,0,nil,c,f)
				end
				local sg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_XMATERIAL)
				if sg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(sg)
				Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
				local res=mg:CheckSubGroup(Auxiliary.XyzLevelFreeGoal,minc,maxc,tp,c,gf)
				Auxiliary.GCheckAdditional=nil
				return res
			end
end
function Auxiliary.XyzLevelFreeTarget(f,gf,minct,maxct)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.XyzLevelFreeFilter,nil,c,f)
				else
					mg=Duel.GetMatchingGroup(Auxiliary.XyzLevelFreeFilter,tp,LOCATION_MZONE,0,nil,c,f)
				end
				local sg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_XMATERIAL)
				Duel.SetSelectedCard(sg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
				local g=mg:SelectSubGroup(tp,Auxiliary.XyzLevelFreeGoal,cancel,minc,maxc,tp,c,gf)
				Auxiliary.GCheckAdditional=nil
				if g and g:GetCount()>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function Auxiliary.XyzLevelFreeOperation(f,gf,minct,maxct)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				if og and not min then
					local sg=Group.CreateGroup()
					local tc=og:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=og:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(og)
					Duel.Overlay(c,og)
				else
					local mg=e:GetLabelObject()
					if e:GetLabel()==1 then
						local mg2=mg:GetFirst():GetOverlayGroup()
						if mg2:GetCount()~=0 then
							Duel.Overlay(c,mg2)
						end
					else
						local sg=Group.CreateGroup()
						local tc=mg:GetFirst()
						while tc do
							local sg1=tc:GetOverlayGroup()
							sg:Merge(sg1)
							tc=mg:GetNext()
						end
						Duel.SendtoGrave(sg,REASON_RULE)
					end
					c:SetMaterial(mg)
					Duel.Overlay(c,mg)
					mg:DeleteGroup()
				end
			end
end
--Xyz summon(level free&alterf)
function Auxiliary.XyzLevelFreeConditionAlter(f,gf,minct,maxct,alterf,alterdesc,alterop)
	return	function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				end
				local altg=mg:Filter(Auxiliary.XyzAlterFilter,nil,alterf,c,e,tp,alterop):Filter(Auxiliary.MustMaterialCheck,nil,tp,EFFECT_MUST_BE_XMATERIAL)
				if (not min or min<=1) and altg:GetCount()>0 then
					return true
				end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				mg=mg:Filter(Auxiliary.XyzLevelFreeFilter,nil,c,f)
				local sg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_XMATERIAL)
				if sg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(sg)
				Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
				local res=mg:CheckSubGroup(Auxiliary.XyzLevelFreeGoal,minc,maxc,tp,c,gf)
				Auxiliary.GCheckAdditional=nil
				return res
			end
end
function Auxiliary.XyzLevelFreeTargetAlter(f,gf,minct,maxct,alterf,alterdesc,alterop)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				end
				local sg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_XMATERIAL)
				local mg2=mg:Filter(Auxiliary.XyzLevelFreeFilter,nil,c,f)
				Duel.SetSelectedCard(sg)
				local b1=mg2:CheckSubGroup(Auxiliary.XyzLevelFreeGoal,minc,maxc,tp,c,gf)
				local b2=(not min or min<=1) and mg:IsExists(Auxiliary.XyzAlterFilter,1,nil,alterf,c,e,tp,alterop)
				local g=nil
				if b2 and (not b1 or Duel.SelectYesNo(tp,alterdesc)) then
					e:SetLabel(1)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					g=mg:FilterSelect(tp,Auxiliary.XyzAlterFilter,1,1,nil,alterf,c,e,tp,alterop)
					if alterop then alterop(e,tp,1,g:GetFirst()) end
				else
					e:SetLabel(0)
					Duel.SetSelectedCard(sg)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					local cancel=Duel.IsSummonCancelable()
					Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
					g=mg2:SelectSubGroup(tp,Auxiliary.XyzLevelFreeGoal,cancel,minc,maxc,tp,c,gf)
					Auxiliary.GCheckAdditional=nil
				end
				if g and g:GetCount()>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function Auxiliary.XyzLevelFreeOperationAlter(f,gf,minct,maxct,alterf,alterdesc,alterop)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				if og and not min then
					local sg=Group.CreateGroup()
					local tc=og:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=og:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(og)
					Duel.Overlay(c,og)
				else
					local mg=e:GetLabelObject()
					if e:GetLabel()==1 then
						local mg2=mg:GetFirst():GetOverlayGroup()
						if mg2:GetCount()~=0 then
							Duel.Overlay(c,mg2)
						end
					else
						local sg=Group.CreateGroup()
						local tc=mg:GetFirst()
						while tc do
							local sg1=tc:GetOverlayGroup()
							sg:Merge(sg1)
							tc=mg:GetNext()
						end
						Duel.SendtoGrave(sg,REASON_RULE)
					end
					c:SetMaterial(mg)
					Duel.Overlay(c,mg)
					mg:DeleteGroup()
				end
			end
end
--material: names in material list
--Fusion monster, mixed materials
function Auxiliary.AddFusionProcMix(c,sub,insf,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local val={...}
	local fun={}
	local mat={}
	for i=1,#val do
		if type(val[i])=='function' then
			fun[i]=function(c,fc,sub,mg,sg) return val[i](c,fc,sub,mg,sg) and not c:IsHasEffect(6205579) end
		elseif type(val[i])=='table' then
			fun[i]=function(c,fc,sub,mg,sg)
					for _,fcode in ipairs(val[i]) do
						if type(fcode)=='function' then
							if fcode(c,fc,sub,mg,sg) and not c:IsHasEffect(6205579) then return true end
						else
							if c:IsFusionCode(fcode) or (sub and c:CheckFusionSubstitute(fc)) then return true end
						end
					end
					return false
			end
			for _,fcode in ipairs(val[i]) do
				if type(fcode)~='function' then mat[fcode]=true end
			end
		else
			fun[i]=function(c,fc,sub) return c:IsFusionCode(val[i]) or (sub and c:CheckFusionSubstitute(fc)) end
			mat[val[i]]=true
		end
	end
	local mt=getmetatable(c)
	if mt.material==nil then
		mt.material=mat
	end
	if mt.material_count==nil then
		mt.material_count={#fun,#fun}
	end
	for index,_ in pairs(mat) do
		Auxiliary.AddCodeList(c,index)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(Auxiliary.FConditionMix(insf,sub,table.unpack(fun)))
	e1:SetOperation(Auxiliary.FOperationMix(insf,sub,table.unpack(fun)))
	c:RegisterEffect(e1)
end
function Auxiliary.FConditionMix(insf,sub,...)
	--g:Material group(nil for Instant Fusion)
	--gc:Material already used
	--chkf: check field, default:PLAYER_NONE
	--chkf&0x100: Not fusion summon
	--chkf&0x200: Concat fusion
	local funs={...}
	return	function(e,g,gc,chkfnf)
				if g==nil then return insf and Auxiliary.MustMaterialCheck(nil,e:GetHandlerPlayer(),EFFECT_MUST_BE_FMATERIAL) end
				local c=e:GetHandler()
				local tp=c:GetControler()
				local notfusion=chkfnf&0x100>0
				local concat_fusion=chkfnf&0x200>0
				local sub=(sub or notfusion) and not concat_fusion
				local mg=g:Filter(Auxiliary.FConditionFilterMix,c,c,sub,concat_fusion,table.unpack(funs))
				if gc then
					if not mg:IsContains(gc) then return false end
					Duel.SetSelectedCard(Group.FromCards(gc))
				end
				return mg:CheckSubGroup(Auxiliary.FCheckMixGoal,#funs,#funs,tp,c,sub,chkfnf,table.unpack(funs))
			end
end
function Auxiliary.FOperationMix(insf,sub,...)
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
				local c=e:GetHandler()
				local tp=c:GetControler()
				local notfusion=chkfnf&0x100>0
				local concat_fusion=chkfnf&0x200>0
				local sub=(sub or notfusion) and not concat_fusion
				local mg=eg:Filter(Auxiliary.FConditionFilterMix,c,c,sub,concat_fusion,table.unpack(funs))
				if gc then Duel.SetSelectedCard(Group.FromCards(gc)) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				local sg=mg:SelectSubGroup(tp,Auxiliary.FCheckMixGoal,false,#funs,#funs,tp,c,sub,chkfnf,table.unpack(funs))
				Duel.SetFusionMaterial(sg)
			end
end
function Auxiliary.FConditionFilterMix(c,fc,sub,concat_fusion,...)
	local fusion_type=concat_fusion and SUMMON_TYPE_SPECIAL or SUMMON_TYPE_FUSION
	if not c:IsCanBeFusionMaterial(fc,fusion_type) then return false end
	for i,f in ipairs({...}) do
		if f(c,fc,sub) then return true end
	end
	return false
end
function Auxiliary.FCheckMix(c,mg,sg,fc,sub,fun1,fun2,...)
	if fun2 then
		sg:AddCard(c)
		local res=false
		if fun1(c,fc,false,mg,sg) then
			res=mg:IsExists(Auxiliary.FCheckMix,1,sg,mg,sg,fc,sub,fun2,...)
		elseif sub and fun1(c,fc,true,mg,sg) then
			res=mg:IsExists(Auxiliary.FCheckMix,1,sg,mg,sg,fc,false,fun2,...)
		end
		sg:RemoveCard(c)
		return res
	else
		return fun1(c,fc,sub,mg,sg)
	end
end
--if sg1 is subset of sg2 then not Auxiliary.FCheckAdditional(tp,sg1,fc) -> not Auxiliary.FCheckAdditional(tp,sg2,fc)
Auxiliary.FCheckAdditional=nil
Auxiliary.FGoalCheckAdditional=nil
function Auxiliary.FCheckMixGoal(sg,tp,fc,sub,chkfnf,...)
	local chkf=chkfnf&0xff
	local concat_fusion=chkfnf&0x200>0
	if not concat_fusion and sg:IsExists(Auxiliary.TuneMagicianCheckX,1,nil,sg,EFFECT_TUNE_MAGICIAN_F) then return false end
	if not Auxiliary.MustMaterialCheck(sg,tp,EFFECT_MUST_BE_FMATERIAL) then return false end
	local g=Group.CreateGroup()
	return sg:IsExists(Auxiliary.FCheckMix,1,nil,sg,g,fc,sub,...) and (chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0)
		and (not Auxiliary.FCheckAdditional or Auxiliary.FCheckAdditional(tp,sg,fc))
		and (not Auxiliary.FGoalCheckAdditional or Auxiliary.FGoalCheckAdditional(tp,sg,fc))
end
--Fusion monster, mixed material * minc to maxc + material + ...
function Auxiliary.AddFusionProcMixRep(c,sub,insf,fun1,minc,maxc,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local val={fun1,...}
	local fun={}
	local mat={}
	for i=1,#val do
		if type(val[i])=='function' then
			fun[i]=function(c,fc,sub,mg,sg) return val[i](c,fc,sub,mg,sg) and not c:IsHasEffect(6205579) end
		elseif type(val[i])=='table' then
			fun[i]=function(c,fc,sub,mg,sg)
					for _,fcode in ipairs(val[i]) do
						if type(fcode)=='function' then
							if fcode(c,fc,sub,mg,sg) and not c:IsHasEffect(6205579) then return true end
						else
							if c:IsFusionCode(fcode) or (sub and c:CheckFusionSubstitute(fc)) then return true end
						end
					end
					return false
			end
			for _,fcode in ipairs(val[i]) do
				if type(fcode)~='function' then mat[fcode]=true end
			end
		else
			fun[i]=function(c,fc,sub) return c:IsFusionCode(val[i]) or (sub and c:CheckFusionSubstitute(fc)) end
			mat[val[i]]=true
		end
	end
	local mt=getmetatable(c)
	if mt.material==nil then
		mt.material=mat
	end
	if mt.material_count==nil then
		mt.material_count={#fun+minc-1,#fun+maxc-1}
	end
	for index,_ in pairs(mat) do
		Auxiliary.AddCodeList(c,index)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(Auxiliary.FConditionMixRep(insf,sub,fun[1],minc,maxc,table.unpack(fun,2)))
	e1:SetOperation(Auxiliary.FOperationMixRep(insf,sub,fun[1],minc,maxc,table.unpack(fun,2)))
	c:RegisterEffect(e1)
end
function Auxiliary.FConditionMixRep(insf,sub,fun1,minc,maxc,...)
	local funs={...}
	return	function(e,g,gc,chkfnf)
				if g==nil then return insf and Auxiliary.MustMaterialCheck(nil,e:GetHandlerPlayer(),EFFECT_MUST_BE_FMATERIAL) end
				local c=e:GetHandler()
				local tp=c:GetControler()
				local notfusion=chkfnf&0x100>0
				local concat_fusion=chkfnf&0x200>0
				local sub=(sub or notfusion) and not concat_fusion
				local mg=g:Filter(Auxiliary.FConditionFilterMix,c,c,sub,concat_fusion,fun1,table.unpack(funs))
				if gc then
					if not mg:IsContains(gc) then return false end
					local sg=Group.CreateGroup()
					return Auxiliary.FSelectMixRep(gc,tp,mg,sg,c,sub,chkfnf,fun1,minc,maxc,table.unpack(funs))
				end
				local sg=Group.CreateGroup()
				return mg:IsExists(Auxiliary.FSelectMixRep,1,nil,tp,mg,sg,c,sub,chkfnf,fun1,minc,maxc,table.unpack(funs))
			end
end
function Auxiliary.FOperationMixRep(insf,sub,fun1,minc,maxc,...)
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
				local c=e:GetHandler()
				local tp=c:GetControler()
				local notfusion=chkfnf&0x100>0
				local concat_fusion=chkfnf&0x200>0
				local sub=(sub or notfusion) and not concat_fusion
				local mg=eg:Filter(Auxiliary.FConditionFilterMix,c,c,sub,concat_fusion,fun1,table.unpack(funs))
				local sg=Group.CreateGroup()
				if gc then sg:AddCard(gc) end
				while sg:GetCount()<maxc+#funs do
					local cg=mg:Filter(Auxiliary.FSelectMixRep,sg,tp,mg,sg,c,sub,chkfnf,fun1,minc,maxc,table.unpack(funs))
					if cg:GetCount()==0 then break end
					local finish=Auxiliary.FCheckMixRepGoal(tp,sg,c,sub,chkfnf,fun1,minc,maxc,table.unpack(funs))
					local cancel_group=sg:Clone()
					if gc then cancel_group:RemoveCard(gc) end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
					local tc=cg:SelectUnselect(cancel_group,tp,finish,false,minc+#funs,maxc+#funs)
					if not tc then break end
					if sg:IsContains(tc) then
						sg:RemoveCard(tc)
					else
						sg:AddCard(tc)
					end
				end
				Duel.SetFusionMaterial(sg)
			end
end
function Auxiliary.FCheckMixRep(sg,g,fc,sub,chkf,fun1,minc,maxc,fun2,...)
	if fun2 then
		return sg:IsExists(Auxiliary.FCheckMixRepFilter,1,g,sg,g,fc,sub,chkf,fun1,minc,maxc,fun2,...)
	else
		local ct1=sg:FilterCount(fun1,g,fc,sub,mg,sg)
		local ct2=sg:FilterCount(fun1,g,fc,false,mg,sg)
		return ct1==sg:GetCount()-g:GetCount() and ct1-ct2<=1
	end
end
function Auxiliary.FCheckMixRepFilter(c,sg,g,fc,sub,chkf,fun1,minc,maxc,fun2,...)
	if fun2(c,fc,sub,mg,sg) then
		g:AddCard(c)
		local sub=sub and fun2(c,fc,false,mg,sg)
		local res=Auxiliary.FCheckMixRep(sg,g,fc,sub,chkf,fun1,minc,maxc,...)
		g:RemoveCard(c)
		return res
	end
	return false
end
function Auxiliary.FCheckMixRepGoalCheck(tp,sg,fc,chkfnf)
	local concat_fusion=chkfnf&0x200>0
	if not concat_fusion and sg:IsExists(Auxiliary.TuneMagicianCheckX,1,nil,sg,EFFECT_TUNE_MAGICIAN_F) then return false end
	if not Auxiliary.MustMaterialCheck(sg,tp,EFFECT_MUST_BE_FMATERIAL) then return false end
	if Auxiliary.FGoalCheckAdditional and not Auxiliary.FGoalCheckAdditional(tp,sg,fc) then return false end
	return true
end
function Auxiliary.FCheckMixRepGoal(tp,sg,fc,sub,chkfnf,fun1,minc,maxc,...)
	local chkf=chkfnf&0xff
	if sg:GetCount()<minc+#{...} or sg:GetCount()>maxc+#{...} then return false end
	if not (chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0) then return false end
	if Auxiliary.FCheckAdditional and not Auxiliary.FCheckAdditional(tp,sg,fc) then return false end
	if not Auxiliary.FCheckMixRepGoalCheck(tp,sg,fc,chkfnf) then return false end
	local g=Group.CreateGroup()
	return Auxiliary.FCheckMixRep(sg,g,fc,sub,chkf,fun1,minc,maxc,...)
end
function Auxiliary.FCheckMixRepTemplate(c,cond,tp,mg,sg,g,fc,sub,chkfnf,fun1,minc,maxc,...)
	for i,f in ipairs({...}) do
		if f(c,fc,sub,mg,sg) then
			g:AddCard(c)
			local sub=sub and f(c,fc,false,mg,sg)
			local t={...}
			table.remove(t,i)
			local res=cond(tp,mg,sg,g,fc,sub,chkfnf,fun1,minc,maxc,table.unpack(t))
			g:RemoveCard(c)
			if res then return true end
		end
	end
	if maxc>0 then
		if fun1(c,fc,sub,mg,sg) then
			g:AddCard(c)
			local sub=sub and fun1(c,fc,false,mg,sg)
			local res=cond(tp,mg,sg,g,fc,sub,chkfnf,fun1,minc-1,maxc-1,...)
			g:RemoveCard(c)
			if res then return true end
		end
	end
	return false
end
function Auxiliary.FCheckMixRepSelectedCond(tp,mg,sg,g,...)
	if g:GetCount()<sg:GetCount() then
		return sg:IsExists(Auxiliary.FCheckMixRepSelected,1,g,tp,mg,sg,g,...)
	else
		return Auxiliary.FCheckSelectMixRep(tp,mg,sg,g,...)
	end
end
function Auxiliary.FCheckMixRepSelected(c,...)
	return Auxiliary.FCheckMixRepTemplate(c,Auxiliary.FCheckMixRepSelectedCond,...)
end
function Auxiliary.FCheckSelectMixRep(tp,mg,sg,g,fc,sub,chkfnf,fun1,minc,maxc,...)
	local chkf=chkfnf&0xff
	if Auxiliary.FCheckAdditional and not Auxiliary.FCheckAdditional(tp,g,fc) then return false end
	if chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,g,fc)>0 then
		if minc<=0 and #{...}==0 and Auxiliary.FCheckMixRepGoalCheck(tp,g,fc,chkfnf) then return true end
		return mg:IsExists(Auxiliary.FCheckSelectMixRepAll,1,g,tp,mg,sg,g,fc,sub,chkfnf,fun1,minc,maxc,...)
	else
		return mg:IsExists(Auxiliary.FCheckSelectMixRepM,1,g,tp,mg,sg,g,fc,sub,chkfnf,fun1,minc,maxc,...)
	end
end
function Auxiliary.FCheckSelectMixRepAll(c,tp,mg,sg,g,fc,sub,chkf,fun1,minc,maxc,fun2,...)
	if fun2 then
		if fun2(c,fc,sub,mg,sg) then
			g:AddCard(c)
			local sub=sub and fun2(c,fc,false,mg,sg)
			local res=Auxiliary.FCheckSelectMixRep(tp,mg,sg,g,fc,sub,chkf,fun1,minc,maxc,...)
			g:RemoveCard(c)
			return res
		end
	elseif maxc>0 and fun1(c,fc,sub,mg,sg) then
		g:AddCard(c)
		local sub=sub and fun1(c,fc,false,mg,sg)
		local res=Auxiliary.FCheckSelectMixRep(tp,mg,sg,g,fc,sub,chkf,fun1,minc-1,maxc-1)
		g:RemoveCard(c)
		return res
	end
	return false
end
function Auxiliary.FCheckSelectMixRepM(c,tp,...)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and Auxiliary.FCheckMixRepTemplate(c,Auxiliary.FCheckSelectMixRep,tp,...)
end
function Auxiliary.FSelectMixRep(c,tp,mg,sg,fc,sub,chkfnf,...)
	sg:AddCard(c)
	local res=false
	if Auxiliary.FCheckAdditional and not Auxiliary.FCheckAdditional(tp,sg,fc) then
		res=false
	elseif Auxiliary.FCheckMixRepGoal(tp,sg,fc,sub,chkfnf,...) then
		res=true
	else
		local g=Group.CreateGroup()
		res=sg:IsExists(Auxiliary.FCheckMixRepSelected,1,nil,tp,mg,sg,g,fc,sub,chkfnf,...)
	end
	sg:RemoveCard(c)
	return res
end
--Fusion monster, name + name
function Auxiliary.AddFusionProcCode2(c,code1,code2,sub,insf)
	Auxiliary.AddFusionProcMix(c,sub,insf,code1,code2)
end
--Fusion monster, name + name + name
function Auxiliary.AddFusionProcCode3(c,code1,code2,code3,sub,insf)
	Auxiliary.AddFusionProcMix(c,sub,insf,code1,code2,code3)
end
--Fusion monster, name + name + name + name
function Auxiliary.AddFusionProcCode4(c,code1,code2,code3,code4,sub,insf)
	Auxiliary.AddFusionProcMix(c,sub,insf,code1,code2,code3,code4)
end
--Fusion monster, name * n
function Auxiliary.AddFusionProcCodeRep(c,code1,cc,sub,insf)
	local code={}
	for i=1,cc do
		code[i]=code1
	end
	Auxiliary.AddFusionProcMix(c,sub,insf,table.unpack(code))
end
--Fusion monster, name * minc to maxc
function Auxiliary.AddFusionProcCodeRep2(c,code1,minc,maxc,sub,insf)
	Auxiliary.AddFusionProcMixRep(c,sub,insf,code1,minc,maxc)
end
--Fusion monster, name + condition * n
function Auxiliary.AddFusionProcCodeFun(c,code1,f,cc,sub,insf)
	local fun={}
	for i=1,cc do
		fun[i]=f
	end
	Auxiliary.AddFusionProcMix(c,sub,insf,code1,table.unpack(fun))
end
--Fusion monster, condition + condition
function Auxiliary.AddFusionProcFun2(c,f1,f2,insf)
	Auxiliary.AddFusionProcMix(c,false,insf,f1,f2)
end
--Fusion monster, condition * n
function Auxiliary.AddFusionProcFunRep(c,f,cc,insf)
	local fun={}
	for i=1,cc do
		fun[i]=f
	end
	Auxiliary.AddFusionProcMix(c,false,insf,table.unpack(fun))
end
--Fusion monster, condition * minc to maxc
function Auxiliary.AddFusionProcFunRep2(c,f,minc,maxc,insf)
	Auxiliary.AddFusionProcMixRep(c,false,insf,f,minc,maxc)
end
--Fusion monster, condition1 + condition2 * n
function Auxiliary.AddFusionProcFunFun(c,f1,f2,cc,insf)
	local fun={}
	for i=1,cc do
		fun[i]=f2
	end
	Auxiliary.AddFusionProcMix(c,false,insf,f1,table.unpack(fun))
end
--Fusion monster, condition1 + condition2 * minc to maxc
function Auxiliary.AddFusionProcFunFunRep(c,f1,f2,minc,maxc,insf)
	Auxiliary.AddFusionProcMixRep(c,false,insf,f2,minc,maxc,f1)
end
--Fusion monster, name + condition * minc to maxc
function Auxiliary.AddFusionProcCodeFunRep(c,code1,f,minc,maxc,sub,insf)
	Auxiliary.AddFusionProcMixRep(c,sub,insf,f,minc,maxc,code1)
end
--Fusion monster, name + name + condition * minc to maxc
function Auxiliary.AddFusionProcCode2FunRep(c,code1,code2,f,minc,maxc,sub,insf)
	Auxiliary.AddFusionProcMixRep(c,sub,insf,f,minc,maxc,code1,code2)
end
--Fusion monster, Shaddoll materials
function Auxiliary.AddFusionProcShaddoll(c,attr)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(Auxiliary.FShaddollCondition(attr))
	e1:SetOperation(Auxiliary.FShaddollOperation(attr))
	c:RegisterEffect(e1)
end
function Auxiliary.FShaddollFilter(c,fc,attr)
	return (Auxiliary.FShaddollFilter1(c) or Auxiliary.FShaddollFilter2(c,attr)) and c:IsCanBeFusionMaterial(fc) and not c:IsHasEffect(6205579)
end
function Auxiliary.FShaddollExFilter(c,fc,attr,fe)
	return c:IsFaceup() and not c:IsImmuneToEffect(fe) and Auxiliary.FShaddollFilter(c,fc,attr)
end
function Auxiliary.FShaddollFilter1(c)
	return c:IsFusionSetCard(0x9d)
end
function Auxiliary.FShaddollFilter2(c,attr)
	return c:IsFusionAttribute(attr) or c:IsHasEffect(4904633)
end
function Auxiliary.FShaddollSpFilter1(c,fc,tp,mg,exg,attr,chkf)
	return mg:IsExists(Auxiliary.FShaddollSpFilter2,1,c,fc,tp,c,attr,chkf)
		or (exg and exg:IsExists(Auxiliary.FShaddollSpFilter2,1,c,fc,tp,c,attr,chkf))
end
function Auxiliary.FShaddollSpFilter2(c,fc,tp,mc,attr,chkf)
	local sg=Group.FromCards(c,mc)
	if sg:IsExists(Auxiliary.TuneMagicianCheckX,1,nil,sg,EFFECT_TUNE_MAGICIAN_F) then return false end
	if not Auxiliary.MustMaterialCheck(sg,tp,EFFECT_MUST_BE_FMATERIAL) then return false end
	if Auxiliary.FCheckAdditional and not Auxiliary.FCheckAdditional(tp,sg,fc)
		or Auxiliary.FGoalCheckAdditional and not Auxiliary.FGoalCheckAdditional(tp,sg,fc) then return false end
	return ((Auxiliary.FShaddollFilter1(c) and Auxiliary.FShaddollFilter2(mc,attr))
		or (Auxiliary.FShaddollFilter2(c,attr) and Auxiliary.FShaddollFilter1(mc)))
		and (chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0)
end
function Auxiliary.FShaddollCondition(attr)
	return 	function(e,g,gc,chkf)
				if g==nil then return Auxiliary.MustMaterialCheck(nil,e:GetHandlerPlayer(),EFFECT_MUST_BE_FMATERIAL) end
				local c=e:GetHandler()
				local mg=g:Filter(Auxiliary.FShaddollFilter,nil,c,attr)
				local tp=e:GetHandlerPlayer()
				local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
				local exg=nil
				if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
					local fe=fc:IsHasEffect(81788994)
					exg=Duel.GetMatchingGroup(Auxiliary.FShaddollExFilter,tp,0,LOCATION_MZONE,mg,c,attr,fe)
				end
				if gc then
					if not mg:IsContains(gc) then return false end
					return Auxiliary.FShaddollSpFilter1(gc,c,tp,mg,exg,attr,chkf)
				end
				return mg:IsExists(Auxiliary.FShaddollSpFilter1,1,nil,c,tp,mg,exg,attr,chkf)
			end
end
function Auxiliary.FShaddollOperation(attr)
	return	function(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
				local c=e:GetHandler()
				local mg=eg:Filter(Auxiliary.FShaddollFilter,nil,c,attr)
				local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
				local exg=nil
				if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
					local fe=fc:IsHasEffect(81788994)
					exg=Duel.GetMatchingGroup(Auxiliary.FShaddollExFilter,tp,0,LOCATION_MZONE,mg,c,attr,fe)
				end
				local g=nil
				if gc then
					g=Group.FromCards(gc)
					mg:RemoveCard(gc)
				else
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
					g=mg:FilterSelect(tp,Auxiliary.FShaddollSpFilter1,1,1,nil,c,tp,mg,exg,attr,chkf)
					mg:Sub(g)
				end
				if exg and exg:IsExists(Auxiliary.FShaddollSpFilter2,1,nil,c,tp,g:GetFirst(),attr,chkf)
					and (mg:GetCount()==0 or (exg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81788994,0)))) then
					fc:RemoveCounter(tp,0x16,3,REASON_EFFECT)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
					local sg=exg:FilterSelect(tp,Auxiliary.FShaddollSpFilter2,1,1,nil,c,tp,g:GetFirst(),attr,chkf)
					g:Merge(sg)
				else
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
					local sg=mg:FilterSelect(tp,Auxiliary.FShaddollSpFilter2,1,1,nil,c,tp,g:GetFirst(),attr,chkf)
					g:Merge(sg)
				end
				Duel.SetFusionMaterial(g)
			end
end
function Auxiliary.AddContactFusionProcedure(c,filter,self_location,opponent_location,mat_operation,...)
	local self_location=self_location or 0
	local opponent_location=opponent_location or 0
	local operation_params={...}
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(Auxiliary.ContactFusionCondition(filter,self_location,opponent_location))
	e2:SetOperation(Auxiliary.ContactFusionOperation(filter,self_location,opponent_location,mat_operation,operation_params))
	c:RegisterEffect(e2)
	return e2
end
function Auxiliary.ContactFusionMaterialFilter(c,fc,filter)
	return c:IsCanBeFusionMaterial(fc,SUMMON_TYPE_SPECIAL) and (not filter or filter(c,fc))
end
function Auxiliary.ContactFusionCondition(filter,self_location,opponent_location)
	return	function(e,c)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=Duel.GetMatchingGroup(Auxiliary.ContactFusionMaterialFilter,tp,self_location,opponent_location,c,c,filter)
				return c:CheckFusionMaterial(mg,nil,tp|0x200)
			end
end
function Auxiliary.ContactFusionOperation(filter,self_location,opponent_location,mat_operation,operation_params)
	return	function(e,tp,eg,ep,ev,re,r,rp,c)
				local mg=Duel.GetMatchingGroup(Auxiliary.ContactFusionMaterialFilter,tp,self_location,opponent_location,c,c,filter)
				local g=Duel.SelectFusionMaterial(tp,c,mg,nil,tp|0x200)
				c:SetMaterial(g)
				mat_operation(g,table.unpack(operation_params))
			end
end
function Auxiliary.AddRitualProcUltimate(c,filter,level_function,greater_or_equal,summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
	summon_location=summon_location or LOCATION_HAND
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(Auxiliary.RitualUltimateTarget(filter,level_function,greater_or_equal,summon_location,grave_filter,mat_filter,extra_target))
	e1:SetOperation(Auxiliary.RitualUltimateOperation(filter,level_function,greater_or_equal,summon_location,grave_filter,mat_filter,extra_operation))
	if not pause then
		c:RegisterEffect(e1)
	end
	return e1
end
function Auxiliary.RitualCheckGreater(g,c,lv)
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetRitualLevel,lv,c)
end
function Auxiliary.RitualCheckEqual(g,c,lv)
	return g:CheckWithSumEqual(Card.GetRitualLevel,lv,#g,#g,c)
end
Auxiliary.RCheckAdditional=nil
function Auxiliary.RitualCheck(g,tp,c,lv,greater_or_equal)
	return Auxiliary["RitualCheck"..greater_or_equal](g,c,lv) and Duel.GetMZoneCount(tp,g,tp)>0 and (not c.mat_group_check or c.mat_group_check(g,tp))
		and (not Auxiliary.RCheckAdditional or Auxiliary.RCheckAdditional(tp,g,c))
end
function Auxiliary.RitualCheckAdditionalLevel(c,rc)
	local raw_level=c:GetRitualLevel(rc)
	local lv1=raw_level&0xffff
	local lv2=raw_level>>16
	if lv2>0 then
		return math.min(lv1,lv2)
	else
		return lv1
	end
end
Auxiliary.RGCheckAdditional=nil
function Auxiliary.RitualCheckAdditional(c,lv,greater_or_equal)
	if greater_or_equal=="Equal" then
		return	function(g)
					return (not Auxiliary.RGCheckAdditional or Auxiliary.RGCheckAdditional(g)) and g:GetSum(Auxiliary.RitualCheckAdditionalLevel,c)<=lv
				end
	else
		return	function(g,ec)
					if ec then
						return (not Auxiliary.RGCheckAdditional or Auxiliary.RGCheckAdditional(g,ec)) and g:GetSum(Auxiliary.RitualCheckAdditionalLevel,c)-Auxiliary.RitualCheckAdditionalLevel(ec,c)<=lv
					else
						return not Auxiliary.RGCheckAdditional or Auxiliary.RGCheckAdditional(g)
					end
				end
	end
end
function Auxiliary.RitualUltimateFilter(c,filter,e,tp,m1,m2,level_function,greater_or_equal,chk)
	if bit.band(c:GetType(),0x81)~=0x81 or (filter and not filter(c,e,tp,chk)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if m2 then
		mg:Merge(m2)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	local lv=level_function(c)
	Auxiliary.GCheckAdditional=Auxiliary.RitualCheckAdditional(c,lv,greater_or_equal)
	local res=mg:CheckSubGroup(Auxiliary.RitualCheck,1,lv,tp,c,lv,greater_or_equal)
	Auxiliary.GCheckAdditional=nil
	return res
end
function Auxiliary.RitualExtraFilter(c,f)
	return c:GetLevel()>0 and f(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function Auxiliary.RitualUltimateTarget(filter,level_function,greater_or_equal,summon_location,grave_filter,mat_filter,extra_target)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then
					local mg=Duel.GetRitualMaterial(tp)
					if mat_filter then mg=mg:Filter(mat_filter,nil,e,tp,true) end
					local exg=nil
					if grave_filter then
						exg=Duel.GetMatchingGroup(Auxiliary.RitualExtraFilter,tp,LOCATION_GRAVE,0,nil,grave_filter)
					end
					return Duel.IsExistingMatchingCard(Auxiliary.RitualUltimateFilter,tp,summon_location,0,1,nil,filter,e,tp,mg,exg,level_function,greater_or_equal,true)
				end
				Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,summon_location)
				if grave_filter then
					Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)
				end
				if extra_target then
					extra_target(e,tp,eg,ep,ev,re,r,rp)
				end
			end
end
function Auxiliary.RitualUltimateOperation(filter,level_function,greater_or_equal,summon_location,grave_filter,mat_filter,extra_operation)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local mg=Duel.GetRitualMaterial(tp)
				if mat_filter then mg=mg:Filter(mat_filter,nil,e,tp) end
				local exg=nil
				if grave_filter then
					exg=Duel.GetMatchingGroup(Auxiliary.RitualExtraFilter,tp,LOCATION_GRAVE,0,nil,grave_filter)
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=Duel.SelectMatchingCard(tp,Auxiliary.NecroValleyFilter(Auxiliary.RitualUltimateFilter),tp,summon_location,0,1,1,nil,filter,e,tp,mg,exg,level_function,greater_or_equal)
				local tc=tg:GetFirst()
				local mat
				if tc then
					mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
					if exg then
						mg:Merge(exg)
					end
					if tc.mat_filter then
						mg=mg:Filter(tc.mat_filter,tc,tp)
					else
						mg:RemoveCard(tc)
					end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
					local lv=level_function(tc)
					Auxiliary.GCheckAdditional=Auxiliary.RitualCheckAdditional(tc,lv,greater_or_equal)
					mat=mg:SelectSubGroup(tp,Auxiliary.RitualCheck,false,1,lv,tp,tc,lv,greater_or_equal)
					Auxiliary.GCheckAdditional=nil
					tc:SetMaterial(mat)
					Duel.ReleaseRitualMaterial(mat)
					Duel.BreakEffect()
					Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
					tc:CompleteProcedure()
				end
				if extra_operation then
					extra_operation(e,tp,eg,ep,ev,re,r,rp,tc,mat)
				end
			end
end
--Ritual Summon, geq fixed lv
function Auxiliary.AddRitualProcGreater(c,filter,summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
	return Auxiliary.AddRitualProcUltimate(c,filter,Card.GetOriginalLevel,"Greater",summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
end
function Auxiliary.AddRitualProcGreaterCode(c,code1,summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
	Auxiliary.AddCodeList(c,code1)
	return Auxiliary.AddRitualProcGreater(c,Auxiliary.FilterBoolFunction(Card.IsCode,code1),summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
end
--Ritual Summon, equal to fixed lv
function Auxiliary.AddRitualProcEqual(c,filter,summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
	return Auxiliary.AddRitualProcUltimate(c,filter,Card.GetOriginalLevel,"Equal",summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
end
function Auxiliary.AddRitualProcEqualCode(c,code1,summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
	Auxiliary.AddCodeList(c,code1)
	return Auxiliary.AddRitualProcEqual(c,Auxiliary.FilterBoolFunction(Card.IsCode,code1),summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
end
--Ritual Summon, equal to monster lv
function Auxiliary.AddRitualProcEqual2(c,filter,summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
	return Auxiliary.AddRitualProcUltimate(c,filter,Card.GetLevel,"Equal",summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
end
function Auxiliary.AddRitualProcEqual2Code(c,code1,summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
	Auxiliary.AddCodeList(c,code1)
	return Auxiliary.AddRitualProcEqual2(c,Auxiliary.FilterBoolFunction(Card.IsCode,code1),summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
end
function Auxiliary.AddRitualProcEqual2Code2(c,code1,code2,summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
	Auxiliary.AddCodeList(c,code1,code2)
	return Auxiliary.AddRitualProcEqual2(c,Auxiliary.FilterBoolFunction(Card.IsCode,code1,code2),summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
end
--Ritual Summon, geq monster lv
function Auxiliary.AddRitualProcGreater2(c,filter,summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
	return Auxiliary.AddRitualProcUltimate(c,filter,Card.GetLevel,"Greater",summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
end
function Auxiliary.AddRitualProcGreater2Code(c,code1,summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
	Auxiliary.AddCodeList(c,code1)
	return Auxiliary.AddRitualProcGreater2(c,Auxiliary.FilterBoolFunction(Card.IsCode,code1),summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
end
function Auxiliary.AddRitualProcGreater2Code2(c,code1,code2,summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
	Auxiliary.AddCodeList(c,code1,code2)
	return Auxiliary.AddRitualProcGreater2(c,Auxiliary.FilterBoolFunction(Card.IsCode,code1,code2),summon_location,grave_filter,mat_filter,pause,extra_operation,extra_target)
end
--add procedure to Pendulum monster, also allows registeration of activation effect
function Auxiliary.EnablePendulumAttribute(c,reg)
	if not Auxiliary.PendulumChecklist then
		Auxiliary.PendulumChecklist=0
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(Auxiliary.PendulumReset)
		Duel.RegisterEffect(ge1,0)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1163)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(Auxiliary.PendCondition())
	e1:SetOperation(Auxiliary.PendOperation())
	e1:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e1)
	--register by default
	if reg==nil or reg then
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(1160)
		e2:SetType(EFFECT_TYPE_ACTIVATE)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetRange(LOCATION_HAND)
		c:RegisterEffect(e2)
	end
end
function Auxiliary.PendulumReset(e,tp,eg,ep,ev,re,r,rp)
	Auxiliary.PendulumChecklist=0
end
function Auxiliary.PConditionExtraFilterSpecific(c,e,tp,lscale,rscale,te)
	if not te then return true end
	local f=te:GetValue()
	return not f or f(te,c,e,tp,lscale,rscale)
end
function Auxiliary.PConditionExtraFilter(c,e,tp,lscale,rscale,eset)
	for _,te in ipairs(eset) do
		if Auxiliary.PConditionExtraFilterSpecific(c,e,tp,lscale,rscale,te) then return true end
	end
	return false
end
function Auxiliary.PConditionFilter(c,e,tp,lscale,rscale,eset)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	local bool=Auxiliary.PendulumSummonableBool(c)
	return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and lv>lscale and lv<rscale and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,bool,bool)
		and not c:IsForbidden()
		and (Auxiliary.PendulumChecklist&(0x1<<tp)==0 or Auxiliary.PConditionExtraFilter(c,e,tp,lscale,rscale,eset))
end
function Auxiliary.PendCondition()
	return	function(e,c,og)
				if c==nil then return true end
				local tp=c:GetControler()
				local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
				if Auxiliary.PendulumChecklist&(0x1<<tp)~=0 and #eset==0 then return false end
				local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
				if rpz==nil or c==rpz then return false end
				local lscale=c:GetLeftScale()
				local rscale=rpz:GetRightScale()
				if lscale>rscale then lscale,rscale=rscale,lscale end
				local loc=0
				if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
				if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0 then loc=loc+LOCATION_EXTRA end
				if loc==0 then return false end
				local g=nil
				if og then
					g=og:Filter(Card.IsLocation,nil,loc)
				else
					g=Duel.GetFieldGroup(tp,loc,0)
				end
				return g:IsExists(Auxiliary.PConditionFilter,1,nil,e,tp,lscale,rscale,eset)
			end
end
function Auxiliary.PendOperationCheck(ft1,ft2,ft)
	return	function(g)
				local exg=g:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
				local mg=g-exg
				return #g<=ft and #exg<=ft2 and #mg<=ft1
			end
end
function Auxiliary.PendOperation()
	return	function(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
				local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
				local lscale=c:GetLeftScale()
				local rscale=rpz:GetRightScale()
				if lscale>rscale then lscale,rscale=rscale,lscale end
				local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
				local tg=nil
				local loc=0
				local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
				local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
				local ft=Duel.GetUsableMZoneCount(tp)
				local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
				if ect and ect<ft2 then ft2=ect end
				if Duel.IsPlayerAffectedByEffect(tp,59822133) then
					if ft1>0 then ft1=1 end
					if ft2>0 then ft2=1 end
					ft=1
				end
				if ft1>0 then loc=loc|LOCATION_HAND end
				if ft2>0 then loc=loc|LOCATION_EXTRA end
				if og then
					tg=og:Filter(Card.IsLocation,nil,loc):Filter(Auxiliary.PConditionFilter,nil,e,tp,lscale,rscale,eset)
				else
					tg=Duel.GetMatchingGroup(Auxiliary.PConditionFilter,tp,loc,0,nil,e,tp,lscale,rscale,eset)
				end
				local ce=nil
				local b1=Auxiliary.PendulumChecklist&(0x1<<tp)==0
				local b2=#eset>0
				if b1 and b2 then
					local options={1163}
					for _,te in ipairs(eset) do
						table.insert(options,te:GetDescription())
					end
					local op=Duel.SelectOption(tp,table.unpack(options))
					if op>0 then
						ce=eset[op]
					end
				elseif b2 and not b1 then
					local options={}
					for _,te in ipairs(eset) do
						table.insert(options,te:GetDescription())
					end
					local op=Duel.SelectOption(tp,table.unpack(options))
					ce=eset[op+1]
				end
				if ce then
					tg=tg:Filter(Auxiliary.PConditionExtraFilterSpecific,nil,e,tp,lscale,rscale,ce)
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				Auxiliary.GCheckAdditional=Auxiliary.PendOperationCheck(ft1,ft2,ft)
				local g=tg:SelectSubGroup(tp,aux.TRUE,true,1,math.min(#tg,ft))
				Auxiliary.GCheckAdditional=nil
				if not g then return end
				if ce then
					Duel.Hint(HINT_CARD,0,ce:GetOwner():GetOriginalCode())
					ce:UseCountLimit(tp)
				else
					Auxiliary.PendulumChecklist=Auxiliary.PendulumChecklist|(0x1<<tp)
				end
				sg:Merge(g)
				Duel.HintSelection(Group.FromCards(c))
				Duel.HintSelection(Group.FromCards(rpz))
			end
end
--enable revive limit for monsters that are also pendulum sumonable from certain locations (Odd-Eyes Revolution Dragon)
function Auxiliary.EnableReviveLimitPendulumSummonable(c, loc)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	c:EnableReviveLimit()
	local mt=getmetatable(c)
	if loc==nil then loc=0xff end
	mt.psummonable_location=loc
	--complete procedure on pendulum summon success
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(Auxiliary.PSSCompleteProcedure)
	c:RegisterEffect(e1)
end
function Auxiliary.PendulumSummonableBool(c)
	return c.psummonable_location~=nil and c:GetLocation()&c.psummonable_location>0
end
function Auxiliary.PSSCompleteProcedure(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsSummonType(SUMMON_TYPE_PENDULUM) then
		c:CompleteProcedure()
	end
end
--Link Summon
function Auxiliary.AddLinkProcedure(c,f,min,max,gf)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1166)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	if max==nil then max=c:GetLink() end
	e1:SetCondition(Auxiliary.LinkCondition(f,min,max,gf))
	e1:SetTarget(Auxiliary.LinkTarget(f,min,max,gf))
	e1:SetOperation(Auxiliary.LinkOperation(f,min,max,gf))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	return e1
end
function Auxiliary.LConditionFilter(c,f,lc,e)
	return (c:IsFaceup() or not c:IsOnField() or e:IsHasProperty(EFFECT_FLAG_SET_AVAILABLE))
		and c:IsCanBeLinkMaterial(lc) and (not f or f(c))
end
function Auxiliary.LExtraFilter(c,f,lc,tp)
	if c:IsOnField() and c:IsFacedown() then return false end
	if not c:IsCanBeLinkMaterial(lc) or f and not f(c) then return false end
	local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
	for _,te in pairs(le) do
		local tf=te:GetValue()
		local related,valid=tf(te,lc,nil,c,tp)
		if related then return true end
	end
	return false
end
function Auxiliary.GetLinkCount(c)
	if c:IsType(TYPE_LINK) and c:GetLink()>1 then
		return 1+0x10000*c:GetLink()
	else return 1 end
end
function Auxiliary.GetLinkMaterials(tp,f,lc,e)
	local mg=Duel.GetMatchingGroup(Auxiliary.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,lc,e)
	local mg2=Duel.GetMatchingGroup(Auxiliary.LExtraFilter,tp,LOCATION_HAND+LOCATION_SZONE,LOCATION_ONFIELD,nil,f,lc,tp)
	if mg2:GetCount()>0 then mg:Merge(mg2) end
	return mg
end
function Auxiliary.LCheckOtherMaterial(c,mg,lc,tp)
	local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
	local res1=false
	local res2=true
	for _,te in pairs(le) do
		local f=te:GetValue()
		local related,valid=f(te,lc,mg,c,tp)
		if related then res2=false end
		if related and valid then res1=true end
	end
	return res1 or res2
end
function Auxiliary.LUncompatibilityFilter(c,sg,lc,tp)
	local mg=sg:Filter(aux.TRUE,c)
	return not Auxiliary.LCheckOtherMaterial(c,mg,lc,tp)
end
function Auxiliary.LCheckGoal(sg,tp,lc,gf,lmat)
	return sg:CheckWithSumEqual(Auxiliary.GetLinkCount,lc:GetLink(),#sg,#sg)
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and (not gf or gf(sg))
		and not sg:IsExists(Auxiliary.LUncompatibilityFilter,1,nil,sg,lc,tp)
		and (not lmat or sg:IsContains(lmat))
end
function Auxiliary.LExtraMaterialCount(mg,lc,tp)
	for tc in aux.Next(mg) do
		local le={tc:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
		for _,te in pairs(le) do
			local sg=mg:Filter(aux.TRUE,tc)
			local f=te:GetValue()
			local related,valid=f(te,lc,sg,tc,tp)
			if related and valid then
				te:UseCountLimit(tp)
			end
		end
	end
end
function Auxiliary.LinkCondition(f,minc,maxc,gf)
	return	function(e,c,og,lmat,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.LConditionFilter,nil,f,c,e)
				else
					mg=Auxiliary.GetLinkMaterials(tp,f,c,e)
				end
				if lmat~=nil then
					if not Auxiliary.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
				if fg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(fg)
				return mg:CheckSubGroup(Auxiliary.LCheckGoal,minc,maxc,tp,c,gf,lmat)
			end
end
function Auxiliary.LinkTarget(f,minc,maxc,gf)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.LConditionFilter,nil,f,c,e)
				else
					mg=Auxiliary.GetLinkMaterials(tp,f,c,e)
				end
				if lmat~=nil then
					if not Auxiliary.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
				Duel.SetSelectedCard(fg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				local sg=mg:SelectSubGroup(tp,Auxiliary.LCheckGoal,cancel,minc,maxc,tp,c,gf,lmat)
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function Auxiliary.LinkOperation(f,minc,maxc,gf)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				Auxiliary.LExtraMaterialCount(g,c,tp)
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
				g:DeleteGroup()
			end
end
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
--sp_summon condition for fusion monster
function Auxiliary.fuslimit(e,se,sp,st)
	return st&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION
end
--sp_summon condition for ritual monster
function Auxiliary.ritlimit(e,se,sp,st)
	return st&SUMMON_TYPE_RITUAL==SUMMON_TYPE_RITUAL
end
--sp_summon condition for synchro monster
function Auxiliary.synlimit(e,se,sp,st)
	return st&SUMMON_TYPE_SYNCHRO==SUMMON_TYPE_SYNCHRO
end
--sp_summon condition for xyz monster
function Auxiliary.xyzlimit(e,se,sp,st)
	return st&SUMMON_TYPE_XYZ==SUMMON_TYPE_XYZ
end
--sp_summon condition for pendulum monster
function Auxiliary.penlimit(e,se,sp,st)
	return st&SUMMON_TYPE_PENDULUM==SUMMON_TYPE_PENDULUM
end
--sp_summon condition for link monster
function Auxiliary.linklimit(e,se,sp,st)
	return st&SUMMON_TYPE_LINK==SUMMON_TYPE_LINK
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
	if c:IsRelateToEffect(e) then return c else return nil end
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
--send to deck of contact fusion
function Auxiliary.tdcfop(c)
	return	function(g)
				local cg=g:Filter(Card.IsFacedown,nil)
				if cg:GetCount()>0 then
					Duel.ConfirmCards(1-c:GetControler(),cg)
				end
				Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
			end
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
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(Auxiliary.ThisCardInGraveAlreadyCheckOperation)
	c:RegisterEffect(e1)
	return e1
end
function Auxiliary.ThisCardInGraveAlreadyCheckOperation(e,tp,eg,ep,ev,re,r,rp)
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
	end
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
