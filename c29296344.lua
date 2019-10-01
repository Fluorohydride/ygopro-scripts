--ソーンヴァレル・ドラゴン
function c29296344.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),2,2,c29296344.lcheck)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCost(c29296344.cost)
	e1:SetTarget(c29296344.target)
	e1:SetOperation(c29296344.operation)
	c:RegisterEffect(e1)
end
function c29296344.lcheck(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0x102)
end
function c29296344.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c29296344.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c29296344.spfilter(c,e,tp)
	return c:IsSetCard(0x102) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29296344.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and tc:IsType(TYPE_LINK) then
		local ct=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),tc:GetLink())
		if ct>0 then
			if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
			local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c29296344.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
			if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(29296344,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c29296344.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c29296344.splimit(e,c,tp,sumtp,sumpos)
	return c:IsType(TYPE_LINK) and c:IsLinkBelow(2) and c:IsLocation(LOCATION_EXTRA)
end
