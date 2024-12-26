--ジェネレーション・ネクスト
---@param c Card
function c85787173.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,85787173+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c85787173.condition)
	e1:SetTarget(c85787173.target)
	e1:SetOperation(c85787173.activate)
	c:RegisterEffect(e1)
end
function c85787173.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c85787173.thfilter(c,e,tp,ft,atk)
	return c:IsSetCard(0x3008,0xa4,0x1f) and c:IsAttackBelow(atk) and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c85787173.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local atk=math.abs(Duel.GetLP(0)-Duel.GetLP(1))
	if chk==0 then return Duel.IsExistingMatchingCard(c85787173.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,ft,atk) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c85787173.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local atk=math.abs(Duel.GetLP(0)-Duel.GetLP(1))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c85787173.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,ft,atk)
	local tc=g:GetFirst()
	if tc then
		local res=nil
		if ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			res=Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			res=Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
		if res~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetValue(c85787173.aclimit)
			e1:SetLabel(tc:GetCode())
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c85787173.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
