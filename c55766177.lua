--弑逆の魔轟神
function c55766177.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,55766177+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c55766177.target)
	e1:SetOperation(c55766177.activate)
	c:RegisterEffect(e1)
end
function c55766177.spfilter(c,e,tp)
	return c:IsSetCard(0x35) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c55766177.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
		and Duel.IsExistingTarget(c55766177.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c55766177.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c55766177.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local lc=tg:GetFirst()
	if lc==tc then lc=tg:GetNext() end
	if Duel.DiscardHand(tp,nil,1,1,REASON_DISCARD+REASON_EFFECT,nil)>0 and tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and lc:IsRelateToEffect(e) then
			Duel.Destroy(lc,REASON_EFFECT)
		end
	end
end
