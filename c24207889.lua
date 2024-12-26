--センサー万別
---@param c Card
function c24207889.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	c:RegisterEffect(e1)
	--only one
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(24207889)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	c:RegisterEffect(e2)
	--cannot summon,spsummon,flipsummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetTarget(c24207889.sumlimit)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e6)
	if not c24207889.global_check then
		c24207889.global_check=true
		c24207889.is_empty=true
		c24207889[0]={}
		c24207889[1]={}
		local race=1
		while race<RACE_ALL do
			c24207889[0][race]=Group.CreateGroup()
			c24207889[0][race]:KeepAlive()
			c24207889[1][race]=Group.CreateGroup()
			c24207889[1][race]:KeepAlive()
			race=race<<1
		end
		--adjust
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(c24207889.adjustop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c24207889.rmfilter(c,rc)
	return c:IsFaceup() and c:IsRace(rc) and c:IsStatus(STATUS_EFFECT_ENABLED)
end
function c24207889.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	if sumtype==SUMMON_TYPE_DUAL then return false end
	if sumpos and bit.band(sumpos,POS_FACEDOWN)>0 then return false end
	local tp=sump
	if targetp then tp=targetp end
	return Duel.IsExistingMatchingCard(c24207889.rmfilter,tp,LOCATION_MZONE,0,1,nil,c:GetRace())
end
function c24207889.adjustop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerAffectedByEffect(0,24207889) then
		if not c24207889.is_empty then
			local race=1
			while race<RACE_ALL do
				c24207889[0][race]:Clear()
				c24207889[1][race]:Clear()
				race=race<<1
			end
			c24207889.is_empty=true
		end
		return
	end
	c24207889.is_empty=false
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local sg=Group.CreateGroup()
	for p=0,1 do
		local g=Duel.GetMatchingGroup(Card.IsFaceup,p,LOCATION_MZONE,0,nil)
		local race=1
		while race<RACE_ALL do
			local rg=g:Filter(Card.IsRace,nil,race)
			local rc=rg:GetCount()
			if rc>1 then
				rg:Sub(c24207889[p][race]:Filter(Card.IsRace,nil,race))
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
				local dg=rg:Select(p,rc-1,rc-1,nil)
				sg:Merge(dg)
			end
			race=race<<1
		end
	end
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_RULE)
		Duel.Readjust()
	end
	for p=0,1 do
		local g=Duel.GetMatchingGroup(Card.IsFaceup,p,LOCATION_MZONE,0,nil)
		local race=1
		while race<RACE_ALL do
			c24207889[p][race]:Clear()
			c24207889[p][race]:Merge(g:Filter(Card.IsRace,nil,race))
			race=race<<1
		end
	end
end
