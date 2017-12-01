--コンタクト・アウト
function c69270537.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c69270537.target)
	e1:SetOperation(c69270537.activate)
	c:RegisterEffect(e1)
end
function c69270537.tdfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9) and c:IsType(TYPE_FUSION) and c:IsAbleToExtra()
end
function c69270537.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c69270537.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c69270537.tdfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c69270537.tdfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c69270537.spfilter(c,e,tp,fc)
	return fc.material and c:IsCode(table.unpack(fc.material)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c69270537.fcheck(sp)
	return function(tp,g,c)
		local ct=g:GetCount()
		return Duel.GetMZoneCount(sp)>=ct and not (ct>1 and Duel.IsPlayerAffectedByEffect(tp,59822133))
	end
end
function c69270537.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0
		and tc:IsLocation(LOCATION_EXTRA) then
		aux.FCheckAdditional=c69270537.fcheck(tp)
		local sg=Duel.GetMatchingGroup(c69270537.spfilter,tp,LOCATION_DECK,0,nil,e,tp,tc)
		if tc:CheckFusionMaterial(sg) and Duel.SelectYesNo(tp,aux.Stringid(69270537,0)) then
			Duel.BreakEffect()
			local mats=Duel.SelectFusionMaterial(tp,tc,sg)
			Duel.SpecialSummon(mats,0,tp,tp,false,false,POS_FACEUP)
		end
		aux.FCheckAdditional=nil
	end
end
