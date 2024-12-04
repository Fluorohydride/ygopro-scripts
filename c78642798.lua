--黄金の邪教神
function c78642798.initial_effect(c)
	--Change the Name
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(78642798,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c78642798.rntg)
	e1:SetOperation(c78642798.rnop)
	c:RegisterEffect(e1)
	--Equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(78642798,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,78642798)
	e2:SetTarget(c78642798.eqtg)
	e2:SetOperation(c78642798.eqop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c78642798.eqcon)
	c:RegisterEffect(e3)
end
function c78642798.rntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(aux.NOT(Card.IsPublic),tp,0,LOCATION_HAND,nil)>0 end
end
function c78642798.rnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.NOT(Card.IsPublic),tp,0,LOCATION_HAND,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		Duel.ShuffleHand(1-tp)
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetValue(27125110)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
		end
	end
end
function c78642798.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c78642798.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsAbleToChangeControler()
end
function c78642798.eqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x110) and not c:IsSummonableCard()
end
function c78642798.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c78642798.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c78642798.filter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c78642798.eqfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c78642798.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c78642798.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc1=Duel.GetFirstTarget()
	if tc1:IsRelateToEffect(e) and tc1:IsAbleToChangeControler() then
		local atk=tc1:GetTextAttack()
		if atk<0 then atk=0 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local sg=Duel.SelectMatchingCard(tp,c78642798.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
		if sg:GetCount()>0 then
			local tc2=sg:GetFirst()
			if tc1:IsFaceup() and tc1:IsRelateToEffect(e) and tc2 then
				Duel.Equip(tp,tc1,tc2,false)
				--Gains ATK
				local e1=Effect.CreateEffect(tc1)
				e1:SetType(EFFECT_TYPE_EQUIP)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(atk)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc1:RegisterEffect(e1)
				--Equip Limit
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_EQUIP_LIMIT)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetValue(c78642798.eqlimit)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				e2:SetLabelObject(tc2)
				tc1:RegisterEffect(e2)
			end
		end
	end
end
function c78642798.eqlimit(e,c)
	return c==e:GetLabelObject()
end
