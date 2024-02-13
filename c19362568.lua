--氷風のリフレイン
function c19362568.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,19362568+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c19362568.target)
	e1:SetOperation(c19362568.activate)
	c:RegisterEffect(e1)
end
function c19362568.spfilter(c,e,tp)
	return c:IsSetCard(0xf0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c19362568.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()~=0 then return false end
		return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c19362568.spfilter(chkc,e,tp)
	end
	local ct=Duel.GetReadyChain()
	local b1=Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(c19362568.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	if chk==0 then
		local te,p1,p2
		if ct>1 then
			te,p1=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
			p2=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_PLAYER)
		end
		return b1 or (te and te:GetHandler():IsSetCard(0xf0) and te:IsActiveType(TYPE_MONSTER)
			and p1 and p2 and p1==tp and p2==1-tp and Duel.IsChainDisablable(ct))
	end
	local te,p1,p2
	local b2=false
	if ct>1 then
		te,p1=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		p2=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_PLAYER)
		b2=te and te:GetHandler():IsSetCard(0xf0) and te:IsActiveType(TYPE_MONSTER)
			and p1 and p2 and p1==tp and p2==1-tp and Duel.IsChainDisablable(ct)
	end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(19362568,0),aux.Stringid(19362568,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(19362568,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(19362568,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,c19362568.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	else
		e:SetCategory(CATEGORY_DISABLE)
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,te:GetHandler(),1,0,0)
	end
end
function c19362568.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	else
		Duel.NegateEffect(Duel.GetCurrentChain()-1)
	end
end
