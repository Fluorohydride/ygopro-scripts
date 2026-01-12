--ソウルエナジーMAX！！
function c79339613.initial_effect(c)
	aux.AddCodeList(c,10000000)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79339613)
	e1:SetCondition(c79339613.condition)
	e1:SetCost(c79339613.cost)
	e1:SetTarget(c79339613.target)
	e1:SetOperation(c79339613.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e2:SetCountLimit(1,79339614)
	e2:SetCondition(c79339613.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c79339613.thtg)
	e2:SetOperation(c79339613.thop)
	c:RegisterEffect(e2)
end
function c79339613.filter(c)
	return c:IsCode(10000000) and c:GetOriginalAttribute()==ATTRIBUTE_DIVINE and c:IsFaceup()
end
function c79339613.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c79339613.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c79339613.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c79339613.filter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsFaceup,2,g) end
	local rg=Duel.SelectReleaseGroup(tp,Card.IsFaceup,2,2,g)
	Duel.Release(rg,REASON_COST)
end
function c79339613.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,4000)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(4000)
end
function c79339613.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Damage(p,d,REASON_EFFECT)
	end
end
function c79339613.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_MAIN1 and Duel.GetCurrentPhase()<=PHASE_MAIN2
end
function c79339613.thfilter(c)
	return c:IsCode(10000000) and c:IsAbleToHand()
end
function c79339613.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79339613.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c79339613.sumfilter(c)
	return c:IsSummonable(true,nil) and c:IsCode(10000000)
end
function c79339613.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c79339613.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(c79339613.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(79339613,0)) then
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local sg=Duel.SelectMatchingCard(tp,c79339613.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
			if sg:GetCount()>0 then
				Duel.Summon(tp,sg:GetFirst(),true,nil)
			end
		end
	end
end
