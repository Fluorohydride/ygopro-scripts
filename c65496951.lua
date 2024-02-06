--ヴァルモニカ・ディサルモニア
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND+CATEGORY_DAMAGE+CATEGORY_COUNTER+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.pfilter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x6a,1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:IsHasType(EFFECT_TYPE_ACTIVATE) or Duel.IsExistingMatchingCard(s.pfilter,tp,LOCATION_PZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(s.pfilter,tp,LOCATION_PZONE,0,nil)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0,0)
	end
end
function s.filter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x1a3) and c:IsAbleToHand() and not c:IsCode(id)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp,op)
	if op==nil then
		if not Duel.IsExistingMatchingCard(s.pfilter,tp,LOCATION_PZONE,0,1,nil) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		local tc=Duel.SelectMatchingCard(tp,s.pfilter,tp,LOCATION_PZONE,0,1,1,nil):GetFirst()
		tc:AddCounter(0x6a,1)
		if tc:GetCounter(0x6a)==3 then
			Duel.RaiseEvent(tc,EVENT_CUSTOM+39210885,e,0,tp,tp,0)
		end
		op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))+1
	end
	if op==1 then
		if Duel.Recover(tp,500,REASON_EFFECT)<1 then return end
		local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_REMOVED,0,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.BreakEffect()
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	elseif Duel.Damage(tp,500,REASON_EFFECT)>0 then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.filter),tp,LOCATION_GRAVE,0,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.BreakEffect()
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end