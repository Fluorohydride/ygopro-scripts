--海晶乙女クラウンテイル
function c54569495.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(54569495,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,54569495)
	e1:SetCondition(c54569495.spcon)
	e1:SetCost(c54569495.spcost)
	e1:SetTarget(c54569495.sptg)
	e1:SetOperation(c54569495.spop)
	c:RegisterEffect(e1)
	--battle damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(54569495,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,54569496)
	e2:SetCondition(c54569495.damcon1)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c54569495.damtg1)
	e2:SetOperation(c54569495.damop1)
	c:RegisterEffect(e2)
end
function c54569495.spcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return a and d and a:IsRelateToBattle() and d:IsRelateToBattle()
end
function c54569495.costfilter(c)
	return c:IsSetCard(0x12b) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c54569495.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c54569495.costfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.DiscardHand(tp,c54569495.costfilter,1,1,REASON_COST,c)
end
function c54569495.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c54569495.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(HALF_DAMAGE)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		Duel.RegisterEffect(e1,tp)
	end
end
function c54569495.damcon1(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	return a and a:IsControler(1-tp)
end
function c54569495.damfilter(c)
	return c:IsSetCard(0x12b) and c:IsType(TYPE_LINK)
end
function c54569495.damtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c54569495.damfilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function c54569495.damop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c54569495.damfilter,tp,LOCATION_GRAVE,0,nil)
	local ct=g:GetSum(Card.GetLink)*1000
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetLabel(ct)
	e1:SetCondition(c54569495.valcon)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c54569495.valcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetBattleDamage(tp)<=e:GetLabel()
end
