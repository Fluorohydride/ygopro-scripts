--魂のさまよう墓場
function c98596596.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c98596596.spcon1)
	e2:SetTarget(c98596596.sptg1)
	e2:SetOperation(c98596596.spop1)
	c:RegisterEffect(e2)
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,98596596)
	e3:SetCondition(c98596596.spcon2)
	e3:SetTarget(c98596596.sptg2)
	e3:SetOperation(c98596596.spop2)
	c:RegisterEffect(e3)
end
function c98596596.cfilter1(c,tp)
	return c:IsReason(REASON_BATTLE) and c:IsLocation(LOCATION_GRAVE) and c:GetPreviousControler()==tp
end
function c98596596.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98596596.cfilter1,1,nil,tp) and e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED)
end
function c98596596.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,98596597,0,0x4011,100,100,1,RACE_PYRO,ATTRIBUTE_FIRE) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c98596596.spop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,98596597,0,0x4011,100,100,1,RACE_PYRO,ATTRIBUTE_FIRE) then
		local token=Duel.CreateToken(tp,98596597)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c98596596.cfilter2(c,tp)
	return c:IsReason(REASON_EFFECT) and c:IsLocation(LOCATION_GRAVE)
		and (c:GetPreviousLocation()==LOCATION_HAND or c:GetPreviousLocation()&LOCATION_MZONE>0)
		and c:GetPreviousControler()==tp and c:GetReasonPlayer()==1-tp
end
function c98596596.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98596596.cfilter2,1,nil,tp) and e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED)
end
function c98596596.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,98596597,0,0x4011,100,100,1,RACE_PYRO,ATTRIBUTE_FIRE) end
	local ct=eg:FilterCount(c98596596.cfilter2,nil,tp)
	e:SetLabel(ct)
	ct=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),ct)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,0,0)
end
function c98596596.spop2(e,tp,eg,ep,ev,re,r,rp)
	local ct=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),e:GetLabel())
	if not e:GetHandler():IsRelateToEffect(e) or ct<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,98596597,0,0x4011,100,100,1,RACE_PYRO,ATTRIBUTE_FIRE) then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	for i=1,ct do
		local token=Duel.CreateToken(tp,98596597)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end
