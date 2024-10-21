--御前試合
function c53334471.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetTarget(c53334471.acttg)
	c:RegisterEffect(e1)
	--adjust
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c53334471.adjustop)
	c:RegisterEffect(e2)
	--cannot summon,spsummon,flipsummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetTarget(c53334471.sumlimit)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EFFECT_CANNOT_SUMMON)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,1)
	e5:SetTarget(c53334471.sumlimit)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,1)
	e6:SetTarget(c53334471.sumlimit)
	c:RegisterEffect(e6)
end
c53334471[0]=0
c53334471[1]=0
function c53334471.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	c53334471[0]=0
	c53334471[1]=0
end
function c53334471.limfilter(c)
	return c:IsFaceup() and c:IsStatus(STATUS_EFFECT_ENABLED)
end
function c53334471.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	if sumpos and bit.band(sumpos,POS_FACEDOWN)>0 then return false end
	local at=c53334471.getattribute(Duel.GetMatchingGroup(c53334471.limfilter,targetp or sump,LOCATION_MZONE,0,nil))
	if at==0 then return false end
	return c:GetAttribute()~=at
end
function c53334471.getattribute(g)
	local aat=0
	local tc=g:GetFirst()
	while tc do
		aat=bit.bor(aat,tc:GetAttribute())
		tc=g:GetNext()
	end
	return aat
end
function c53334471.rmfilter(c,at)
	return c:GetAttribute()==at
end
function c53334471.isonlyone(val)
	return val&(val-1)==0
end
function c53334471.tgselect(sg,g)
	local att=c53334471.getattribute(g-sg)
	return att>0 and c53334471.isonlyone(att) and not sg:IsExists(c53334471.rmfilter,1,nil,att)
end
function c53334471.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local c=e:GetHandler()
	if g1:GetCount()==0 then c53334471[tp]=0
	else
		local att=c53334471.getattribute(g1)
		if not c53334471.isonlyone(att) then
			if c53334471[tp]==0 or bit.band(c53334471[tp],att)==0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local sg=g1:SelectSubGroup(tp,c53334471.tgselect,false,1,#g1,g1)
				if not sg then
					att=0
				else
					att=c53334471.getattribute(g1-sg)
				end
			else att=c53334471[tp] end
		end
		g1:Remove(c53334471.rmfilter,nil,att)
		c53334471[tp]=att
	end
	if g2:GetCount()==0 then c53334471[1-tp]=0
	else
		local att=c53334471.getattribute(g2)
		if not c53334471.isonlyone(att) then
			if c53334471[1-tp]==0 or bit.band(c53334471[1-tp],att)==0 then
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
				local sg=g2:SelectSubGroup(1-tp,c53334471.tgselect,false,1,#g2,g2)
				if not sg then
					att=0
				else
					att=c53334471.getattribute(g2-sg)
				end
			else att=c53334471[1-tp] end
		end
		g2:Remove(c53334471.rmfilter,nil,att)
		c53334471[1-tp]=att
	end
	g1:Merge(g2)
	if g1:GetCount()>0 then
		Duel.SendtoGrave(g1,REASON_RULE)
		Duel.Readjust()
	end
end
