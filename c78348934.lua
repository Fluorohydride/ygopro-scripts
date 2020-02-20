--破壊剣士の宿命
function c78348934.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,78348934)
	e1:SetCondition(aux.dscon)
	e1:SetTarget(c78348934.target)
	e1:SetOperation(c78348934.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,78348935)
	e2:SetCost(c78348934.thcost)
	e2:SetTarget(c78348934.thtg)
	e2:SetOperation(c78348934.thop)
	c:RegisterEffect(e2)
end
function c78348934.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c78348934.filter2(c,rc)
	return c:GetRace()==rc and c:IsAbleToRemove()
end
function c78348934.filter3(c)
	return c:IsFaceup() and c:IsSetCard(0xd6,0xd7)
end
function c78348934.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c78348934.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c78348934.filter1,tp,0,LOCATION_GRAVE,1,nil)
		and Duel.IsExistingMatchingCard(c78348934.filter3,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c78348934.filter1,tp,0,LOCATION_GRAVE,1,1,nil)
	local rc=g1:GetFirst():GetRace()
	if Duel.IsExistingTarget(c78348934.filter2,tp,0,LOCATION_GRAVE,1,g1:GetFirst(),rc)
		and Duel.SelectYesNo(tp,aux.Stringid(78348934,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		Duel.SelectTarget(tp,c78348934.filter2,tp,0,LOCATION_GRAVE,1,2,g1:GetFirst(),rc)
	end
end
function c78348934.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local sg=Duel.SelectMatchingCard(tp,c78348934.filter3,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=sg:GetFirst()
	if tc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(ct*500)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end
function c78348934.cfilter(c)
	return c:IsSetCard(0xd6) and c:IsDiscardable()
end
function c78348934.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c78348934.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c78348934.cfilter,1,1,REASON_DISCARD+REASON_COST)
end
function c78348934.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c78348934.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
