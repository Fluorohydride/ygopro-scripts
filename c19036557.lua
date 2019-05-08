--エレメントセイバー・マカニ
function c19036557.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19036557,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c19036557.thcost)
	e1:SetTarget(c19036557.thtg)
	e1:SetOperation(c19036557.thop)
	c:RegisterEffect(e1)
	--att change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19036557,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetTarget(c19036557.atttg)
	e2:SetOperation(c19036557.attop)
	c:RegisterEffect(e2)
end
function c19036557.costfilter(c,tp)
	return c:IsSetCard(0x400d) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c19036557.thfilter,tp,LOCATION_DECK,0,1,c)
end
function c19036557.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,61557074)}) do
		fg:AddCard(pe:GetHandler())
	end
	local loc=LOCATION_HAND
	if fg:GetCount()>0 then loc=LOCATION_HAND+LOCATION_DECK end
	if chk==0 then return Duel.IsExistingMatchingCard(c19036557.costfilter,tp,loc,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c19036557.costfilter,tp,loc,0,1,1,nil,tp):GetFirst()
	if tc:IsLocation(LOCATION_DECK) then
		local fc=nil
		if fg:GetCount()==1 then
			fc=fg:GetFirst()
		else
			fc=fg:Select(tp,1,1,nil)
		end
		Duel.Hint(HINT_CARD,0,fc:GetCode())
		fc:RegisterFlagEffect(61557074,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	end
	Duel.SendtoGrave(tc,REASON_COST)
end
function c19036557.thfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsCode(19036557) and c:IsSetCard(0x400d,0x113) and c:IsAbleToHand()
end
function c19036557.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19036557.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c19036557.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c19036557.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c19036557.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local att=Duel.AnnounceAttribute(tp,1,0xff-e:GetHandler():GetAttribute())
	e:SetLabel(att)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c19036557.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
