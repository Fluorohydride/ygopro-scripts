--世壊挽歌
---@param c Card
function c17462320.initial_effect(c)
	aux.AddCodeList(c,56099748)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17462320,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c17462320.target)
	e1:SetOperation(c17462320.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17462320,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,17462320)
	e2:SetCondition(c17462320.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c17462320.thtg)
	e2:SetOperation(c17462320.thop)
	c:RegisterEffect(e2)
end
function c17462320.thfilter(c)
	return c:IsSetCard(0x19a) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c17462320.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17462320.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c17462320.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c17462320.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c17462320.filter(c)
	return c:IsCode(56099748) and c:IsFaceup()
end
function c17462320.cfilter(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
		and bit.band(c:GetPreviousTypeOnField(),TYPE_TUNER)~=0 and not c:IsType(TYPE_TOKEN)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c17462320.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c17462320.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and eg:IsExists(c17462320.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c17462320.tgfilter(c,e)
	return c:IsCanBeEffectTarget(e) and c:IsAbleToHand()
end
function c17462320.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mg=eg:Filter(c17462320.cfilter,nil,tp):Filter(c17462320.tgfilter,nil,e)
	if chkc then return mg:IsContains(chkc) end
	if chk==0 then return mg:GetCount()>0 end
	local g=mg
	if mg:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		g=mg:Select(tp,1,1,nil)
	end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c17462320.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
