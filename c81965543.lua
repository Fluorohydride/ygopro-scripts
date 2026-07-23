--Distrust Paranoia
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_LIMIT_ZONE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	e1:SetValue(s.zones)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.efcon)
	e4:SetValue(s.efilter)
	c:RegisterEffect(e4)
end
function s.cfilter2(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControlerCanBeChanged() and c:IsControler(1-tp)
end
function s.cfilter(c,tp)
	return c:IsControlerCanBeChanged() and c:GetColumnGroup():FilterCount(s.cfilter2,nil,tp)<Duel.GetMZoneCount(tp,nil,tp,LOCATION_REASON_CONTROL)
end
function s.zones(e,tp,eg,ep,ev,re,r,rp)
	local zone=0
	if e:GetHandler():IsLocation(LOCATION_ONFIELD) then return 0xff end
	local lg=Duel.GetMatchingGroup(s.cfilter,tp,0,LOCATION_MZONE,nil,tp)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_ONFIELD,tp))
	end
	return zone
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then
		if not c:IsLocation(LOCATION_HAND+LOCATION_SZONE) then return false end
		if c:IsLocation(LOCATION_SZONE) then
			local ct=c:GetColumnGroup():FilterCount(s.cfilter2,nil,tp)
			return ct>0 and ct<=Duel.GetMZoneCount(tp,nil,tp,LOCATION_REASON_CONTROL)
		end
		return Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil)
	end
	local g=Duel.GetMatchingGroup(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,g:GetCount(),0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and c:IsLocation(LOCATION_ONFIELD) then
		local g=c:GetColumnGroup():Filter(s.cfilter2,nil,tp)
		if g:GetCount()>0 then
			Duel.GetControl(g,tp)
		end
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and rp==1-tp and c:IsPreviousControler(tp)
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked()
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPES_EFFECT_TRAP_MONSTER,4000,4000,10,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPES_EFFECT_TRAP_MONSTER,4000,4000,10,RACE_FIEND,ATTRIBUTE_DARK) then return end
	c:AddMonsterAttribute(TYPE_EFFECT)
	Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
end
function s.efcon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function s.efilter(e,te)
	local seq1=aux.MZoneSequence(e:GetHandler():GetSequence())
	local seq=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_SEQUENCE)
	if (te:GetActivateLocation()&LOCATION_ONFIELD)==0 then return false end
	local seq2=aux.MZoneSequence(seq)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActivated() and seq1==4-seq2
end
