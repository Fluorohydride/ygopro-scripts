--魔力到達
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.mentioned_counter={
	[0x1]=true,
}
function Auxiliary.HasMentionedCounter(c,counter)
	return c.mentioned_counter and c.mentioned_counter[counter] or false
end
function s.thfilter(c)
	return not c:IsCode(id) and Auxiliary.HasMentionedCounter(c,0x1) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.cfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x12a) and c:GetOriginalType()&TYPE_MONSTER>0
		and (c:IsType(TYPE_MONSTER) and c:IsLevelAbove(7)
		or not c:IsType(TYPE_MONSTER) and c:GetOriginalLevel()>=7)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
			and Duel.IsCanRemoveCounter(tp,1,0,0x1,1,REASON_EFFECT)
			and Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			local ct=Duel.GetMatchingGroupCount(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,nil)
			local ctt={}
			local pc=1
			for i=1,ct do
				if Duel.IsCanRemoveCounter(tp,1,0,0x1,i,REASON_EFFECT) then ctt[i]=nil ctt[pc]=i pc=pc+1 end
			end
			ctt[pc]=nil
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
			local rt=Duel.AnnounceNumber(tp,table.unpack(ctt))
			Duel.RemoveCounter(tp,1,0,0x1,rt,REASON_EFFECT)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
			local sg=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,rt,rt,nil)
			if sg:GetCount()>0 then
				Duel.HintSelection(sg)
				local ng=Group.CreateGroup()
				for tc in aux.Next(sg) do
					if tc:IsCanBeDisabledByEffect(e,false) then
						ng:AddCard(tc)
						Duel.NegateRelatedChain(tc,RESET_TURN_SET)
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
						e1:SetCode(EFFECT_DISABLE)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						tc:RegisterEffect(e1)
						local e2=Effect.CreateEffect(c)
						e2:SetType(EFFECT_TYPE_SINGLE)
						e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
						e2:SetCode(EFFECT_DISABLE_EFFECT)
						e2:SetValue(RESET_TURN_SET)
						e2:SetReset(RESET_EVENT+RESETS_STANDARD)
						tc:RegisterEffect(e2)
						if tc:IsType(TYPE_TRAPMONSTER) then
							local e3=Effect.CreateEffect(c)
							e3:SetType(EFFECT_TYPE_SINGLE)
							e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
							e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
							e3:SetReset(RESET_EVENT+RESETS_STANDARD)
							tc:RegisterEffect(e3)
						end
					end
				end
				Duel.AdjustInstantly()
				if ng:GetCount()>0 then
					Duel.Destroy(ng,REASON_EFFECT)
				end
			end
		end
	end
end
