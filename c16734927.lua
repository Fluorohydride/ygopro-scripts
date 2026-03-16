--Ectoplasmic Fortification
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,97077563,80749819)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_ATKCHANGE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.thfilter(c)
	return (c:IsCode(80749819) or (c:IsRace(RACE_ZOMBIE) and c:IsLevel(6))) and c:IsAbleToHand()
end
function s.adfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
		and (not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,nil) or not e:IsCostChecked())
	local b2=Duel.IsExistingMatchingCard(s.adfilter,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 or b2 then
		op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,1),1},
			{b2,aux.Stringid(id,2),2})
	end
	e:SetLabel(op)
	if op==1 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif op==2 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DRAW)
		end
	end
end
function s.drfilter(c)
	return c:IsFaceup() and c:IsCode(97077563)
end
function s.atkupfilter(c)
	return not c:IsHasEffect(EFFECT_REVERSE_UPDATE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif e:GetLabel()==2 then
		local g=Duel.GetMatchingGroup(s.adfilter,tp,LOCATION_MZONE,0,nil)
		if #g>0 then
			local tc=g:GetFirst()
			while tc do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(400)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				tc=g:GetNext()
			end
			if g:IsExists(s.atkupfilter,1,nil) then
				local dct=Duel.GetMatchingGroupCount(s.drfilter,tp,LOCATION_ONFIELD,0,nil)
				if dct>0 and Duel.IsPlayerCanDraw(tp,dct) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
					Duel.BreakEffect()
					Duel.Draw(tp,dct,REASON_EFFECT)
				end
			end
		end
	end
end
