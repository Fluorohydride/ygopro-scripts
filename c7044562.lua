--魂のカード
function c7044562.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,7044562+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c7044562.target)
	e1:SetOperation(c7044562.activate)
	c:RegisterEffect(e1)
end
function c7044562.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
function c7044562.filter(c,lp)
	return c:GetAttack()>=0 and c:GetDefense()>=0 and c:GetAttack()+c:GetDefense()==lp and c:IsAbleToHand()
end
function c7044562.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if g:GetCount()<1 then return end
	Duel.ConfirmCards(tp,g)
	local lp=Duel.GetLP(tp)
	if g:IsExists(c7044562.filter,1,nil,lp) and Duel.SelectYesNo(tp,aux.Stringid(7044562,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,c7044562.filter,1,1,nil,lp)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
	end
	Duel.ShuffleDeck(tp)
end
