--魔神儀の隠れ房
---@param c Card
function c13482262.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,13482262+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c13482262.activate)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13482262,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCondition(c13482262.descon)
	e2:SetTarget(c13482262.destg)
	e2:SetOperation(c13482262.desop)
	c:RegisterEffect(e2)
end
function c13482262.filter(c,e,tp)
	return c:IsSetCard(0x117) and c:IsType(TYPE_MONSTER) and not c:IsPublic() and c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(c13482262.spfilter,tp,LOCATION_DECK,0,2,nil,e,tp,c:GetCode())
end
function c13482262.spfilter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c13482262.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetMatchingGroup(c13482262.filter,tp,LOCATION_HAND,0,nil,e,tp)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(13482262,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		local tg=Duel.GetMatchingGroup(c13482262.spfilter,tp,LOCATION_DECK,0,nil,e,tp,tc:GetCode())
		local sg
		if #tg>2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			sg=tg:Select(tp,2,2,nil)
		else
			sg=tg:Clone()
		end
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		Duel.BreakEffect()
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function c13482262.cfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsControler(tp)
end
function c13482262.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c13482262.cfilter,1,nil,tp)
end
function c13482262.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c13482262.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
