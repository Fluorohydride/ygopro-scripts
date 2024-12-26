--ヴィサス＝サンサーラ
---@param c Card
function c14391625.initial_effect(c)
	--change name
	aux.EnableChangeCode(c,56099748,LOCATION_MZONE+LOCATION_GRAVE)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14391625,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,14391625)
	e1:SetTarget(c14391625.sptg)
	e1:SetOperation(c14391625.spop)
	c:RegisterEffect(e1)
	--non tuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_NONTUNER)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetValue(c14391625.tnval)
	c:RegisterEffect(e2)
end
function c14391625.retfilter(c,e)
	return c:IsSetCard(0x198) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx()
		and c:IsAbleToDeck() and c:IsCanBeEffectTarget(e)
end
function c14391625.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED) and c14391625.retfilter(chkc,e) end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c14391625.retfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and g:CheckSubGroup(aux.mzctcheck,1,#g,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=g:SelectSubGroup(tp,aux.mzctcheck,false,1,#g,tp)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,#tg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c14391625.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local atk=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA):GetClassCount(Card.GetCode)*400
	if atk>0 and c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function c14391625.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler())
end
