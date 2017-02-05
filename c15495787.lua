--超重武者ココロガマ－A
function c15495787.initial_effect(c)
	--summon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetCondition(c15495787.sumcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(15495787,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_HAND)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(c15495787.spcon)
	e3:SetTarget(c15495787.sptg)
	e3:SetOperation(c15495787.spop)
	c:RegisterEffect(e3)
end
function c15495787.sfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c15495787.sumcon(e)
	return Duel.IsExistingMatchingCard(c15495787.sfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end
function c15495787.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and not c15495787.sumcon(e)
end
function c15495787.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.IsExistingMatchingCard(c15495787.sfilter,tp,LOCATION_GRAVE,0,1,nil) then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c15495787.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		c:RegisterEffect(e2)
	end
end
