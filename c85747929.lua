--銀河光子竜
---@param c Card
function c85747929.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c85747929.atktg)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	--to hand or grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(85747929,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,85747929)
	e2:SetCost(c85747929.thcost)
	e2:SetTarget(c85747929.thtg)
	e2:SetOperation(c85747929.thop)
	c:RegisterEffect(e2)
	--level
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(85747929,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,85747930)
	e3:SetCondition(c85747929.lvcon)
	e3:SetTarget(c85747929.lvtg)
	e3:SetOperation(c85747929.lvop)
	c:RegisterEffect(e3)
end
function c85747929.atktg(e,c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c~=e:GetHandler()
end
function c85747929.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c85747929.filter(c)
	return c:IsSetCard(0x55,0x7b) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c85747929.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c85747929.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c85747929.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c85747929.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function c85747929.cfilter(c,tp)
	return c:IsControler(tp) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevelAbove(1)
end
function c85747929.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c85747929.cfilter,1,nil,tp)
end
function c85747929.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=eg:Filter(c85747929.cfilter,nil,tp):Filter(Card.IsLocation,nil,LOCATION_MZONE)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and aux.IsInGroup(chkc,g) end
	if chk==0 then return Duel.IsExistingTarget(aux.IsInGroup,tp,LOCATION_MZONE,0,1,nil,g) end
	local sg
	if g:GetCount()==1 then
		sg=g:Clone()
		Duel.SetTargetCard(sg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		sg=Duel.SelectTarget(tp,aux.IsInGroup,tp,LOCATION_MZONE,0,1,1,nil,g)
	end
end
function c85747929.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local lv
		if tc:GetLevel()==4 then lv=8
		elseif tc:GetLevel()==8 then lv=4
		else lv=Duel.AnnounceNumber(tp,4,8) end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
