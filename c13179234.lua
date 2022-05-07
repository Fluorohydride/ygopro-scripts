--VV～始まりの地～
function c13179234.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13179234,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,13179234)
	e1:SetTarget(c13179234.thtg)
	e1:SetOperation(c13179234.thop)
	c:RegisterEffect(e1)
	--pzone set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13179234,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,13179235)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c13179234.pstg)
	e2:SetOperation(c13179234.psop)
	c:RegisterEffect(e2)
end
function c13179234.thfilter(c)
	return c:IsSetCard(0x17d) and c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
function c13179234.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13179234.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c13179234.desfilter(c)
	return c:IsFaceup() and c:GetOriginalType()&TYPE_PENDULUM~=0
end
function c13179234.sfilter(c)
	return c:IsCode(63394872) and c:IsAbleToHand()
end
function c13179234.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c13179234.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
		local dg=Duel.GetMatchingGroup(c13179234.desfilter,tp,LOCATION_ONFIELD,0,nil)
		local sg=Duel.GetMatchingGroup(c13179234.sfilter,tp,LOCATION_DECK,0,nil)
		if dg:GetCount()>0 and sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(13179234,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dc=dg:Select(tp,1,1,nil)
			Duel.HintSelection(dc)
			if Duel.Destroy(dc,REASON_EFFECT)>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sc=sg:Select(tp,1,1,nil)
				Duel.SendtoHand(sc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sc)
			end
		end
	end
end
function c13179234.psfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x17d) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c13179234.pstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c13179234.psfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function c13179234.psop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c13179234.psfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
