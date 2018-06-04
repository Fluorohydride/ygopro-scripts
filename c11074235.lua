--魔晶龍ジルドラス
function c11074235.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11074235,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,11074235)
	e1:SetCondition(c11074235.spcon)
	e1:SetTarget(c11074235.sptg)
	e1:SetOperation(c11074235.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e2)
end
function c11074235.cfilter(c,tp)
	return bit.band(c:GetPreviousTypeOnField(),TYPE_SPELL+TYPE_TRAP)~=0 and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp
end
function c11074235.spcon(e,tp,eg,ep,ev,re,r,rp)
	 return eg:IsExists(c11074235.cfilter,1,nil,tp)
end
function c11074235.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11074235.setfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsType(TYPE_FIELD) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsSSetable()
end
function c11074235.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c11074235.setfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(11074235,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=g:Select(tp,1,1,nil)
			Duel.SSet(tp,sg)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
