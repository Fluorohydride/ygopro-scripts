--束ねられし力
---@param c Card
function c96239878.initial_effect(c)
	aux.AddCodeList(c,89631139,46986414)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(96239878,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,96239878)
	e2:SetCondition(c96239878.rmcon)
	e2:SetTarget(c96239878.rmtg)
	e2:SetOperation(c96239878.rmop)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c96239878.valcheck)
	c:RegisterEffect(e4)
	--Recover
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(96239878,1))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,96239879)
	e5:SetCost(c96239878.thcost)
	e5:SetTarget(c96239878.thtg)
	e5:SetOperation(c96239878.thop)
	c:RegisterEffect(e5)
end
function c96239878.mtfilter1(c)
	return c:IsCode(89631139,46986414)
end
function c96239878.mtfilter2(c)
	return c:IsFusionCode(89631139,46986414)
end
function c96239878.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(c96239878.mtfilter1,1,nil) then
		c:RegisterFlagEffect(96239878,RESET_EVENT+0x4fe0000+RESET_PHASE+PHASE_END,0,1)
	end
	if g:IsExists(c96239878.mtfilter2,1,nil) then
		c:RegisterFlagEffect(96239879,RESET_EVENT+0x4fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c96239878.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsSummonPlayer(tp)
		and (tc:IsSummonType(SUMMON_TYPE_RITUAL) and tc:GetFlagEffect(96239878)~=0
			or tc:IsSummonType(SUMMON_TYPE_FUSION) and tc:GetFlagEffect(96239879)~=0)
end
function c96239878.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsOnField() or chkc:IsLocation(LOCATION_GRAVE)) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=aux.SelectTargetFromFieldFirst(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c96239878.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c96239878.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c96239878.thfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsLevelAbove(7) and (c:IsAbleToHand() or c:IsAbleToDeck())
end
function c96239878.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c96239878.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c96239878.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c96239878.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c96239878.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:IsAbleToDeck() and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,aux.Stringid(96239878,2))==1) then
			Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
