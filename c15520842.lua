--フォトン・ハンド
function c15520842.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,15520842+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c15520842.condition)
	e1:SetCost(c15520842.cost)
	e1:SetTarget(c15520842.target)
	e1:SetOperation(c15520842.activate)
	c:RegisterEffect(e1)
end
function c15520842.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x55,0x7b)
end
function c15520842.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c15520842.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c15520842.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c15520842.geffilter(c)
	return c:IsFaceup() and c:IsCode(93717133)
end
function c15520842.filter(c,tp)
	return (Duel.IsExistingMatchingCard(c15520842.geffilter,tp,LOCATION_ONFIELD,0,1,nil)
		or (c:IsFaceup() and c:IsType(TYPE_XYZ))) and c:IsControlerCanBeChanged()
end
function c15520842.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c15520842.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c15520842.filter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c15520842.filter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c15520842.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp)
	end
end
