--妖仙獣の居太刀風
---@param c Card
function c10612222.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10612222+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c10612222.condition)
	e1:SetTarget(c10612222.target)
	e1:SetOperation(c10612222.activate)
	c:RegisterEffect(e1)
end
function c10612222.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c10612222.cfilter(c)
	return c:IsSetCard(0xb3) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c10612222.tgfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c10612222.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsFaceup() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingMatchingCard(c10612222.cfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingTarget(c10612222.tgfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local ct=1
	if Duel.IsExistingTarget(c10612222.tgfilter,tp,0,LOCATION_ONFIELD,2,nil) then ct=2 end
	local g=Duel.GetMatchingGroup(c10612222.cfilter,tp,LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
	Duel.ConfirmCards(1-tp,sg)
	Duel.ShuffleHand(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tg=Duel.SelectTarget(tp,c10612222.tgfilter,tp,0,LOCATION_ONFIELD,#sg,#sg,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,#tg,0,0)
end
function c10612222.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
