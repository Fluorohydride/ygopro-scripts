--センサー万別
function c24207889.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetTarget(c24207889.acttg)
	e1:SetOperation(c24207889.actop)
	c:RegisterEffect(e1)
	--adjust
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c24207889.adjustop)
	c:RegisterEffect(e2)
	--cannot summon,spsummon,flipsummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
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
end
c24207889[0]=nil
c24207889[1]=nil
function c24207889.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	if sumpos and bit.band(sumpos,POS_FACEDOWN)>0 then return false end
	local tp=sump
	if targetp then tp=targetp end
	return Duel.IsExistingMatchingCard(c24207889.rmfilter,tp,LOCATION_MZONE,0,1,nil,c:GetRace())
end
function c24207889.rmfilter(c,rc)
	return c:IsFaceup() and c:IsRace(rc)
end
function c24207889.filter(c,g,pg)
	if pg:IsContains(c) then return false end
	local rc=c:GetRace()
	return g:IsExists(Card.IsRace,1,c,rc) or pg:IsExists(Card.IsRace,1,c,rc)
end
function c24207889.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	c24207889[0]=Group.CreateGroup()
	c24207889[0]:KeepAlive()
	c24207889[1]=Group.CreateGroup()
	c24207889[1]:KeepAlive()
end
function c24207889.actop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		local g=Duel.GetMatchingGroup(Card.IsFaceup,p,LOCATION_MZONE,0,nil)
		local race=1
		while bit.band(RACE_ALL,race)~=0 do
			local rg=g:Filter(Card.IsRace,nil,race)
			local rc=rg:GetCount()
			if rc>1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local dg=rg:Select(p,rc-1,rc-1,nil)
				Duel.SendtoGrave(dg,REASON_EFFECT)
				local g=Duel.GetMatchingGroup(Card.IsFaceup,p,LOCATION_MZONE,0,nil)
			end
			race=race*2
		end
	end
end
function c24207889.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local c=e:GetHandler()
	if c:GetFlagEffect(24207889)==0 then
		c:RegisterFlagEffect(24207889,RESET_EVENT+0x1ff0000,0,1)
		c24207889[0]:Clear()
		c24207889[1]:Clear()
	end
	for p=0,1 do
		local pg=c24207889[p]
		local g=Duel.GetMatchingGroup(Card.IsFaceup,p,LOCATION_MZONE,0,nil)
		local dg=g:Filter(c24207889.filter,nil,g,pg)
		if dg:GetCount()==0 or Duel.SendtoGrave(dg,REASON_EFFECT)==0 then
			pg:Clear()
			pg:Merge(g)
			pg:Sub(dg)
		else
			g=Duel.GetMatchingGroup(Card.IsFaceup,p,LOCATION_MZONE,0,nil)
			pg:Clear()
			pg:Merge(g)
			pg:Sub(dg)
			Duel.Readjust()
		end
	end
end
