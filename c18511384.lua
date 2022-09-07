--融合回収
function c18511384.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c18511384.target)
	e1:SetOperation(c18511384.activate)
	c:RegisterEffect(e1)
	--global check
	if not c18511384.global_check then
		c18511384.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BE_MATERIAL)
		ge1:SetCondition(c18511384.checkcon)
		ge1:SetOperation(c18511384.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c18511384.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_FUSION
end
function c18511384.checkop(e,tp,eg,ep,ev,re,r,rp)
	for ec in aux.Next(eg) do
		if ec:IsLocation(LOCATION_GRAVE) then
			ec:RegisterFlagEffect(18511384,RESET_EVENT+RESETS_STANDARD,0,1)
		end
	end
end
function c18511384.filter1(c)
	return c:IsCode(24094653) and c:IsAbleToHand()
end
function c18511384.filter2(c)
	return c:GetFlagEffect(18511384)>0 and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c18511384.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c18511384.filter1,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingTarget(c18511384.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectTarget(tp,c18511384.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectTarget(tp,c18511384.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
end
function c18511384.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
