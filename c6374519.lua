--アメイズメント・スペシャルショー
function c6374519.initial_effect(c)
	--tohand and spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6374519,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c6374519.spcon)
	e1:SetTarget(c6374519.sptg)
	e1:SetOperation(c6374519.spop)
	c:RegisterEffect(e1)
end
function c6374519.thfilter(c,tp,e)
	return c:IsFaceup() and c:IsSetCard(0x15b) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsCanBeEffectTarget(e) and c:IsAbleToHand()
end
function c6374519.spcon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c6374519.thfilter,1,nil,tp,e)
end
function c6374519.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if chkc then return eg:IsContains(chkc) and c6374519.thfilter(chkc,tp,e) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=g:FilterSelect(tp,c6374519.thfilter,1,1,nil,tp,e)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
end
function c6374519.spfilter(c,e,tp)
	return c:IsSetCard(0x15b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c6374519.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(c6374519.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
		if #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(6374519,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
