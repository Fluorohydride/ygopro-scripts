--ティマイオスの眼
function c1784686.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1784686+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c1784686.target)
	e1:SetOperation(c1784686.activate)
	c:RegisterEffect(e1)
	--add code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetValue(10000050)
	c:RegisterEffect(e2)
end
function c1784686.tgfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x10a2) and c:IsCanBeFusionMaterial()
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_FMATERIAL)
		and Duel.IsExistingMatchingCard(c1784686.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetCode())
		and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c1784686.spfilter(c,e,tp,code)
	return aux.IsMaterialListCode(c,code) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function c1784686.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc==0 then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c1784686.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c1784686.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c1784686.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c1784686.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 or not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_FMATERIAL) then return end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsCanBeFusionMaterial() and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c1784686.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetCode())
		local sc=sg:GetFirst()
		if sc then
			sc:SetMaterial(Group.FromCards(tc))
			Duel.SendtoGrave(tc,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
		end
	end
end
