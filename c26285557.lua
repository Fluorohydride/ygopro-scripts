--剛鬼フェイスターン
---@param c Card
function c26285557.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26285557+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c26285557.target)
	e1:SetOperation(c26285557.activate)
	c:RegisterEffect(e1)
end
function c26285557.desfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xfc) and Duel.GetMZoneCount(tp,c)>0
end
function c26285557.spfilter(c,e,tp)
	return c:IsSetCard(0xfc) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26285557.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c26285557.desfilter,tp,LOCATION_ONFIELD,0,1,c,tp)
		and Duel.IsExistingTarget(c26285557.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c26285557.desfilter,tp,LOCATION_ONFIELD,0,1,1,c,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c26285557.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
	e:SetLabelObject(g1:GetFirst())
end
function c26285557.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc1,tc2=Duel.GetFirstTarget()
	if tc1~=e:GetLabelObject() then tc1,tc2=tc2,tc1 end
	if tc1:IsControler(tp) and tc1:IsRelateToEffect(e) and Duel.Destroy(tc1,REASON_EFFECT)>0 and tc2:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
	end
end
