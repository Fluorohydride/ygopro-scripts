--亜空間バトル
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.dfilter(c)
	return c:GetTextAttack()>=0 and c:IsType(TYPE_MONSTER)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.dfilter,tp,LOCATION_DECK,0,1,nil)
			and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_DECK,1,nil) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.IsExistingMatchingCard(s.dfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(s.dfilter,tp,0,LOCATION_DECK,1,nil)) then
		return
	end
	local res=true
	local ct=3
	while res and ct>0 do
		if ct~=3 then Duel.BreakEffect() end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g1=Duel.SelectMatchingCard(tp,s.dfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
		local g2=Duel.SelectMatchingCard(1-tp,s.dfilter,1-tp,LOCATION_DECK,0,1,1,nil)
		Duel.ConfirmCards(1-tp,g1)
		Duel.ConfirmCards(tp,g2)
		local tc1=g1:GetFirst()
		local tc2=g2:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(s.aclimit)
		e1:SetLabel(tc1:GetCode())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetTargetRange(0,1)
		e2:SetLabel(tc2:GetCode())
		Duel.RegisterEffect(e2,tp)
		if tc1:GetAttack()>tc2:GetAttack() then
			if tc1:IsAbleToHand() then
				Duel.SendtoHand(tc1,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc1)
			else
				Duel.SendtoGrave(tc1,REASON_RULE)
			end
			Duel.Destroy(tc2,REASON_EFFECT)
			Duel.Damage(1-tp,500,REASON_EFFECT)
		elseif tc1:GetAttack()<tc2:GetAttack() then
			if tc2:IsAbleToHand() then
				Duel.SendtoHand(tc2,nil,REASON_EFFECT)
				Duel.ConfirmCards(tp,tc2)
			else
				Duel.SendtoGrave(tc2,REASON_RULE)
			end
			Duel.Destroy(tc1,REASON_EFFECT)
			Duel.Damage(tp,500,REASON_EFFECT)
		end
		res=(Duel.IsExistingMatchingCard(s.dfilter,tp,LOCATION_DECK,0,1,nil)
			and Duel.IsExistingMatchingCard(s.dfilter,tp,0,LOCATION_DECK,1,nil))
		ct=ct-1
	end
	if ct~=3 then
		Duel.ShuffleDeck(tp)
		Duel.ShuffleDeck(1-tp)
	end
end
function s.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) and re:IsActiveType(TYPE_MONSTER)
end
