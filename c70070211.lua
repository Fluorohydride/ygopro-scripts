--Jo－P.U.N.K.ナシワリ・サプライズ
---@param c Card
function c70070211.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,70070211+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c70070211.destg)
	e1:SetOperation(c70070211.desop)
	c:RegisterEffect(e1)
end
function c70070211.filter(c,check)
	return c:IsFacedown() or c:IsFaceup() and check
end
function c70070211.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x171)
end
function c70070211.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local check=Duel.IsExistingMatchingCard(c70070211.cfilter,tp,LOCATION_MZONE,0,1,nil)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c70070211.filter(chkc,check) end
	if chk==0 then return Duel.IsExistingTarget(c70070211.filter,tp,0,LOCATION_ONFIELD,1,nil,check) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c70070211.filter,tp,0,LOCATION_ONFIELD,1,1,nil,check)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c70070211.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
