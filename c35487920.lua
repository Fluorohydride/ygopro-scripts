--Live☆Twin チャンネル
function c35487920.initial_effect(c)
	--Activate(no effect)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--negate attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(35487920,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,35487920)
	e2:SetCost(c35487920.cost1)
	e2:SetOperation(c35487920.operation1)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(35487920,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,35487921)
	e3:SetCondition(c35487920.condition2)
	e3:SetTarget(c35487920.target2)
	e3:SetOperation(c35487920.operation2)
	c:RegisterEffect(e3)
end
function c35487920.cfilter1(c,tp)
	return c:IsSetCard(0x152,0x153) and (c:IsControler(tp) or c:IsFaceup())
end
function c35487920.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c35487920.cfilter1,1,nil,tp) end
	local sg=Duel.SelectReleaseGroup(tp,c35487920.cfilter1,1,1,nil,tp)
	Duel.Release(sg,REASON_COST)
end
function c35487920.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
function c35487920.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END
end
function c35487920.tgfilter2(c,check)
	return c:IsSetCard(0x152,0x153) and c:IsType(TYPE_MONSTER)
		and (c:IsAbleToDeck() or (check and c:IsAbleToHand()))
end
function c35487920.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local check=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c35487920.tgfilter2(chkc,check) end
	if chk==0 then return Duel.IsExistingTarget(c35487920.tgfilter2,tp,LOCATION_GRAVE,0,1,nil,check) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c35487920.tgfilter2,tp,LOCATION_GRAVE,0,1,1,nil,check)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c35487920.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if Duel.GetMatchingGroupCount(nil,tp,LOCATION_MZONE,0,nil)==0 and tc:IsAbleToHand()
		and (not tc:IsAbleToDeck() or Duel.SelectOption(tp,1190,aux.Stringid(35487920,2))==0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	else
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
