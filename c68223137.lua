--ワンクリウェイ
function c68223137.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,68223137+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c68223137.target)
	e1:SetOperation(c68223137.operation)
	c:RegisterEffect(e1)
end
function c68223137.filter(c,e,tp)
	local p=c:GetControler()
	return c:IsLink(1) and (c:IsAbleToExtra() or Duel.GetLocationCount(p,LOCATION_MZONE,tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,p))
end
function c68223137.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c68223137.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c68223137.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(68223137,0))
	local g=Duel.SelectTarget(tp,c68223137.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
end
function c68223137.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if aux.NecroValleyNegateCheck(tc) then return end
	local p=tc:GetControler()
	local ft=Duel.GetLocationCount(p,LOCATION_MZONE,tp)
	if tc:IsAbleToExtra() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,p) or ft<=0 or Duel.SelectOption(tp,aux.Stringid(68223137,1),1152)==0) then
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	else
		Duel.SpecialSummon(tc,0,tp,p,false,false,POS_FACEUP)
	end
end
