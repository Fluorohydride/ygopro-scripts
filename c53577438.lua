--斬機ナブラ
---@param c Card
function c53577438.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(53577438,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,53577438)
	e1:SetCost(c53577438.cost)
	e1:SetTarget(c53577438.target)
	e1:SetOperation(c53577438.operation)
	c:RegisterEffect(e1)
	--extra attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,53577439)
	e2:SetCondition(aux.bpcon)
	e2:SetTarget(c53577438.datg)
	e2:SetOperation(c53577438.daop)
	c:RegisterEffect(e2)
end
function c53577438.costfilter(c,tp)
	return c:IsRace(RACE_CYBERSE) and Duel.GetMZoneCount(tp,c,tp)>0
end
function c53577438.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c53577438.costfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c53577438.costfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c53577438.filter(c,e,tp)
	return c:IsSetCard(0x132) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c53577438.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c53577438.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c53577438.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c53577438.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c53577438.dafilter(c)
	return c:IsFaceup() and c:IsRace(RACE_CYBERSE) and not c:IsHasEffect(EFFECT_EXTRA_ATTACK) and c:GetSequence()>=5
end
function c53577438.datg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c53577438.dafilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c53577438.dafilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c53577438.dafilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c53577438.daop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
	end
end
