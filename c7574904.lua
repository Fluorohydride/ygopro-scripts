--ミュートリアル・アームズ
function c7574904.initial_effect(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c7574904.splimit)
	c:RegisterEffect(e1)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c7574904.ctval)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,7574904)
	e3:SetCondition(c7574904.rmcon)
	e3:SetCost(c7574904.rmcost)
	e3:SetTarget(c7574904.rmtg)
	e3:SetOperation(c7574904.rmop)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,7574905)
	e4:SetCondition(c7574904.thcon)
	e4:SetTarget(c7574904.thtg)
	e4:SetOperation(c7574904.thop)
	c:RegisterEffect(e4)
end
function c7574904.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x157)
end
function c7574904.ctval(e,re,rp)
	return aux.tgoval(e,re,rp) and re:IsActiveType(TYPE_TRAP)
end
function c7574904.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep==1-tp
		and re:IsActiveType(TYPE_MONSTER)
end
function c7574904.rmtgfilter(c,e)
	return c:IsAbleToRemove() and c:IsCanBeEffectTarget(e)
end
function c7574904.rmcostfilter(c,e,tp)
	return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c7574904.rmtgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,e)
end
function c7574904.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7574904.rmcostfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c7574904.rmcostfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,e,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c7574904.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c7574904.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c7574904.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsPreviousControler(tp)
end
function c7574904.thtgfilter(c)
	return c:IsSetCard(0x157) and c:IsType(TYPE_SPELL) and c:IsAbleToHand() and c:IsFaceup()
end
function c7574904.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c7574904.thtgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c7574904.thtgfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c7574904.thtgfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c7574904.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
