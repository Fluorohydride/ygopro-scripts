--海造賊－キャプテン黒髭
function c67647362.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c67647362.lcheck)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67647362,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,67647362)
	e1:SetTarget(c67647362.sptg)
	e1:SetOperation(c67647362.spop)
	c:RegisterEffect(e1)
end
function c67647362.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x13f)
end
function c67647362.cfilter(c,e,tp)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
		and Duel.IsExistingMatchingCard(c67647362.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetAttribute())
end
function c67647362.spfilter(c,e,tp,attr)
	return c:IsSetCard(0x13f) and c:IsAttribute(attr) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c67647362.tgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c67647362.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c67647362.tgfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c67647362.tgfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c67647362.cfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil,e,tp)
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c67647362.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c67647362.cfilter2(c)
	return c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)
end
function c67647362.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tgc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c67647362.cfilter2,tp,0,LOCATION_MZONE+LOCATION_GRAVE,nil)
	local tc=g:GetFirst()
	local attr=0
	while tc do
		attr=attr|tc:GetAttribute()
		tc=g:GetNext()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c67647362.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,attr)
	local sc=sg:GetFirst()
	if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 and sc:IsFaceup()
		and tgc:IsRelateToEffect(e) and tgc:IsControler(tp) and tgc:IsFaceup() and tgc:IsType(TYPE_EFFECT) then
		if not Duel.Equip(tp,tgc,sc,false) then return end
		--equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(sc)
		e1:SetValue(c67647362.eqlimit)
		tgc:RegisterEffect(e1)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c67647362.eqlimit(e,c)
	return c==e:GetLabelObject()
end
