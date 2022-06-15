--惨禍の呪眼
function c43011492.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,43011492+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c43011492.condition)
	e1:SetTarget(c43011492.target)
	e1:SetOperation(c43011492.activate)
	c:RegisterEffect(e1)
end
function c43011492.filter(c)
	return c:IsSetCard(0x129) and c:IsFaceup()
end
function c43011492.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c43011492.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c43011492.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c43011492.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c43011492.desfilter(chkc) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c43011492.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c43011492.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c43011492.filter1(c)
	return c:IsCode(44133040) and c:IsFaceup()
end
function c43011492.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain(0) then
		if Duel.IsExistingMatchingCard(c43011492.filter1,tp,LOCATION_SZONE,0,1,nil) then
			Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)
		else
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
