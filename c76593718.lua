--強欲なポッド
local s,id,o=GetID()
---@param c Card
function s.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DECKDES+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.IsExistingMatchingCard(Card.IsSummonLocation,tp,0,LOCATION_MZONE,1,nil,LOCATION_EXTRA) then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local dc=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if Duel.IsPlayerCanDiscardDeck(tp,1) and dc>0 then
		local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
		if dc>ct then dc=ct end
		if dc>1 then
			local t={}
			for i=1,dc do table.insert(t,i) end
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
			dc=Duel.AnnounceNumber(tp,table.unpack(t))
		end
		Duel.ConfirmDecktop(tp,dc)
		local g=Duel.GetDecktopGroup(tp,dc)
		if #g>0 then
			Duel.DisableShuffleCheck()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
			if Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 then
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
				g:Sub(sg)
			end
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
		Duel.BreakEffect()
	end
	local xc=Duel.GetMatchingGroupCount(Card.IsSummonLocation,tp,0,LOCATION_MZONE,nil,LOCATION_EXTRA)
	if xc>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,1,xc,nil)
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end
