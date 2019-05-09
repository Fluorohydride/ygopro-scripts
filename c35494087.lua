--SRビードロ・ドクロ
function c35494087.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(35494087,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetCondition(c35494087.spcon)
	e1:SetTarget(c35494087.sptg)
	e1:SetOperation(c35494087.spop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(c35494087.indval)
	c:RegisterEffect(e2)
	--battle damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e3:SetValue(c35494087.refval)
	c:RegisterEffect(e3)
	--self destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c35494087.sdcon)
	c:RegisterEffect(e4)
end
function c35494087.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FilterEqualFunction(Card.GetSummonLocation,LOCATION_EXTRA),tp,0,LOCATION_MZONE,1,nil)
end
function c35494087.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c35494087.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c35494087.indval(e,c)
	return c:IsSummonType(SUMMON_TYPE_NORMAL)
end
function c35494087.refval(e,c)
	if e:GetHandler():GetFlagEffect(35494087)~=0 then
		Duel.RegisterFlagEffect(e:GetHandlerPlayer(),35494087,RESET_PHASE+PHASE_END,0,1)
		e:GetHandler():ResetFlagEffect(35494087)
		return true
	elseif Duel.GetFlagEffect(e:GetHandlerPlayer(),35494087)==0 then
		e:GetHandler():RegisterFlagEffect(35494087,0,0,1)
		return true
	else return false end
end
function c35494087.sdfilter(c)
	return c:IsFaceup() and not c:IsSetCard(0x2016)
end
function c35494087.sdcon(e)
	return Duel.IsExistingMatchingCard(c35494087.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
