--星遺物の傀儡
function c89320376.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c89320376.target)
	c:RegisterEffect(e1)
	--pos (face-down)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetDescription(aux.Stringid(89320376,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c89320376.cost)
	e2:SetTarget(c89320376.postg1)
	e2:SetOperation(c89320376.posop1)
	c:RegisterEffect(e2)
	--pos (face-up)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(89320376,1))
	e3:SetCost(c89320376.poscost)
	e3:SetTarget(c89320376.postg2)
	e3:SetOperation(c89320376.posop2)
	c:RegisterEffect(e3)
end
function c89320376.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,89320376)==0 end
	Duel.RegisterFlagEffect(tp,89320376,RESET_PHASE+PHASE_END,0,1)
end
function c89320376.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()==0 then
			return c89320376.postg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		else
			return c89320376.postg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		end
	end
	if chk==0 then return true end
	local b1=c89320376.cost(e,tp,eg,ep,ev,re,r,rp,0) and c89320376.postg1(e,tp,eg,ep,ev,re,r,rp,0)
	local b2=c89320376.poscost(e,tp,eg,ep,ev,re,r,rp,0) and c89320376.postg2(e,tp,eg,ep,ev,re,r,rp,0)
	if (b1 or b2) and Duel.SelectYesNo(tp,94) then
		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(89320376,0),aux.Stringid(89320376,1))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(89320376,0))
		else
			op=Duel.SelectOption(tp,aux.Stringid(89320376,1))+1
		end
		e:SetLabel(op)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		if op==0 then
			c89320376.cost(e,tp,eg,ep,ev,re,r,rp,1)
			c89320376.postg1(e,tp,eg,ep,ev,re,r,rp,1)
			e:SetOperation(c89320376.posop1)
		else
			c89320376.poscost(e,tp,eg,ep,ev,re,r,rp,1)
			c89320376.postg2(e,tp,eg,ep,ev,re,r,rp,1)
			e:SetOperation(c89320376.posop2)
		end
	else
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c89320376.postg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFacedown() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFacedown,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c89320376.posop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFacedown() then
		local pos1=0
		if not tc:IsPosition(POS_FACEUP_ATTACK) then pos1=pos1+POS_FACEUP_ATTACK end
		if not tc:IsPosition(POS_FACEUP_DEFENSE) then pos1=pos1+POS_FACEUP_DEFENSE end
		local pos2=Duel.SelectPosition(tp,tc,pos1)
		Duel.ChangePosition(tc,pos2)
	end
end
function c89320376.cfilter(c)
	return c:IsSetCard(0x104) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c89320376.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c89320376.cost(e,tp,eg,ep,ev,re,r,rp,0)
		and Duel.IsExistingMatchingCard(c89320376.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c89320376.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	c89320376.cost(e,tp,eg,ep,ev,re,r,rp,1)
end
function c89320376.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c89320376.postg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c89320376.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c89320376.posfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c89320376.posfilter,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabel(1)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c89320376.posop2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
