--素早きは三文の徳
function c43994202.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,43994202)
	e1:SetCondition(c43994202.condition)
	e1:SetTarget(c43994202.target)
	e1:SetOperation(c43994202.activate)
	c:RegisterEffect(e1)
end
function c43994202.cfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_TOKEN)
end
function c43994202.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return #g==3 and g:FilterCount(c43994202.cfilter,nil)==3
		and g:GetClassCount(Card.GetCode)==1
end
function c43994202.filter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c43994202.filter2,tp,LOCATION_DECK,0,2,c,c:GetCode())
end
function c43994202.filter2(c,code)
	return c:IsType(TYPE_MONSTER) and c:IsCode(code) and c:IsAbleToHand()
end
function c43994202.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43994202.filter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,3,tp,LOCATION_DECK)
end
function c43994202.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c43994202.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g1:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,c43994202.filter2,tp,LOCATION_DECK,0,2,2,g1,g1:GetFirst():GetCode())
	g1:Merge(g2)
	if Duel.SendtoHand(g1,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g1)
		if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
		local code=g1:GetFirst():GetCode()
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_FIELD)
		e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e0:SetCode(EFFECT_CANNOT_ACTIVATE)
		e0:SetTargetRange(1,0)
		e0:SetValue(c43994202.aclimit)
		e0:SetLabel(code)
		e0:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e0,tp)
		local e1=e0:Clone()
		e1:SetCode(EFFECT_CANNOT_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetTarget(c43994202.splimit)
		e1:SetValue(1)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_MSET)
		Duel.RegisterEffect(e2,tp)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		Duel.RegisterEffect(e3,tp)
	end
end
function c43994202.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) and re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end
function c43994202.splimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsCode(e:GetLabel())
end
