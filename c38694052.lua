--黒熔龍騎ヴォルニゲシュ
---@param c Card
function c38694052.initial_effect(c)
	--xyz procedure
	aux.AddXyzProcedure(c,nil,7,2)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(38694052,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCondition(c38694052.nomatcon)
	e1:SetCost(c38694052.descost)
	e1:SetTarget(c38694052.destg)
	e1:SetOperation(c38694052.desop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c38694052.matcon)
	c:RegisterEffect(e2)
end
function c38694052.nomatcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:GetOverlayGroup():IsExists(Card.IsRace,1,nil,RACE_DRAGON)
end
function c38694052.matcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOverlayGroup():IsExists(Card.IsRace,1,nil,RACE_DRAGON)
end
function c38694052.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,2,REASON_COST) and c:GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	c:RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c38694052.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c38694052.checkfilter(c)
	return c:GetPreviousTypeOnField()&TYPE_MONSTER~=0
end
function c38694052.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Destroy(tc,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		if og:IsExists(c38694052.checkfilter,1,nil) and #g>0
			and Duel.SelectYesNo(tp,aux.Stringid(38694052,1)) then
			local star=0
			if tc:IsType(TYPE_XYZ) then star=tc:GetOriginalRank() else star=tc:GetOriginalLevel() end
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(38694052,2))
			local sg=g:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			local tc=sg:GetFirst()
			if tc then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(star*300)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
				tc:RegisterEffect(e1)
			end
		end
	end
end
