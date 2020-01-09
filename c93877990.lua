--Brotherhood of the Fire Fist - Swan
function c93877990.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsRace,RACE_BEASTWARRIOR),2,true)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(93877990,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,93877990)
	e1:SetTarget(c93877990.damtg)
	e1:SetOperation(c93877990.damop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(93877990,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,93877991)
	e2:SetCondition(c93877990.descon)
	e2:SetCost(c93877990.descost)
	e2:SetTarget(c93877990.destg)
	e2:SetOperation(c93877990.desop)
	c:RegisterEffect(e2)
end
function c93877990.damfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7c) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c93877990.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c93877990.damfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetTargetPlayer(1-tp)
	local ct=Duel.GetMatchingGroupCount(c93877990.damfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*200)
end
function c93877990.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetMatchingGroupCount(c93877990.damfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Damage(p,ct*200,REASON_EFFECT)
end
function c93877990.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
function c93877990.costfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c93877990.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c93877990.costfilter,tp,LOCATION_ONFIELD,0,1,nil)
		or Duel.IsPlayerAffectedByEffect(tp,46241344) end
	if Duel.IsExistingMatchingCard(c93877990.costfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and (not Duel.IsPlayerAffectedByEffect(tp,46241344) or not Duel.SelectYesNo(tp,aux.Stringid(46241344,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c93877990.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function c93877990.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c93877990.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
