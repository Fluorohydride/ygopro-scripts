--超重神童ワカ－U4
---@param c Card
function c82112494.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--move pendulum
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82112494,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,82112494)
	e1:SetCondition(c82112494.spcon)
	e1:SetTarget(c82112494.pctg)
	e1:SetOperation(c82112494.pcop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82112494,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,82112495)
	e2:SetCondition(c82112494.spcon)
	e2:SetCost(c82112494.spcost)
	e2:SetTarget(c82112494.sptg)
	e2:SetOperation(c82112494.spop)
	c:RegisterEffect(e2)
	--move
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,82112496)
	e3:SetCondition(c82112494.pencon)
	e3:SetTarget(c82112494.pentg)
	e3:SetOperation(c82112494.penop)
	c:RegisterEffect(e3)
end
function c82112494.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_SPELL+TYPE_TRAP)
end
function c82112494.pcfilter(c,tp)
	return not c:IsCode(82112494) and c:IsSetCard(0x9a) and c:IsType(TYPE_PENDULUM)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp,LOCATION_SZONE)
end
function c82112494.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c82112494.pcfilter,tp,LOCATION_DECK,0,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c82112494.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c82112494.pcfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if #g==0 or not Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true) then return end
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.BreakEffect()
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c82112494.costfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable()
		and Duel.IsExistingMatchingCard(c82112494.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,c,e,tp)
end
function c82112494.spfilter(c,e,tp)
	return c:IsSetCard(0x9a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c82112494.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82112494.costfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.DiscardHand(tp,c82112494.costfilter,1,1,REASON_COST+REASON_DISCARD,nil,e,tp)
end
function c82112494.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c82112494.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c82112494.spop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c82112494.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c82112494.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	if ft<=0 or #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
function c82112494.splimit(e,c)
	return not c:IsSetCard(0x9a)
end
function c82112494.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() and r==REASON_SYNCHRO
end
function c82112494.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c82112494.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
