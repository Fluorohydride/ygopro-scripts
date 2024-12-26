--サイバー・ヴァリー
---@param c Card
function c3657444.initial_effect(c)
	--be target
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3657444,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCost(c3657444.cost1)
	e1:SetTarget(c3657444.target1)
	e1:SetOperation(c3657444.operation1)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(3657444,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c3657444.target2)
	e2:SetOperation(c3657444.operation2)
	c:RegisterEffect(e2)
	--salvage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(3657444,2))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c3657444.target3)
	e3:SetOperation(c3657444.operation3)
	c:RegisterEffect(e3)
end
function c3657444.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c3657444.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c3657444.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
	end
end
function c3657444.filter2(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c3657444.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c3657444.filter2(chkc) end
	if chk==0 then return c:IsAbleToRemove() and Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingTarget(c3657444.filter2,tp,LOCATION_MZONE,0,1,c) and c:IsCanBeEffectTarget() end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c3657444.filter2,tp,LOCATION_MZONE,0,1,1,c)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c3657444.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsControler(tp) and tc:IsFaceup() and c:IsRelateToEffect(e) then
		local sg=Group.FromCards(c,tc)
		if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)~=2 then return end
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
function c3657444.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToDeck() end
	if chk==0 then return e:GetHandler():IsAbleToRemove()
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c3657444.operation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local hg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,1,nil)
	if hg:GetCount()>0 then
		hg:AddCard(c)
		if Duel.Remove(hg,POS_FACEUP,REASON_EFFECT)~=2 then return end
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.BreakEffect()
			Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)
		end
	end
end
