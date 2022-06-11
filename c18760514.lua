--マッドマーダー
function c18760514.initial_effect(c)
	--change name
	aux.EnableChangeCode(c,33420078,LOCATION_MZONE+LOCATION_GRAVE)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,18760514)
	e1:SetTarget(c18760514.target)
	e1:SetOperation(c18760514.operation)
	c:RegisterEffect(e1)
end
function c18760514.filter(c)
	return c:IsFaceup() and c:IsLevelAbove(6)
end
function c18760514.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c18760514.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c18760514.filter,tp,LOCATION_MZONE,0,1,nil)
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(18760514,0))
	Duel.SelectTarget(tp,c18760514.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c18760514.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) or tc:GetLevel()<3 then return end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(-2)
	tc:RegisterEffect(e1)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
		if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetAbsoluteRange(tp,1,0)
			e2:SetTarget(c18760514.splimit)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e2,true)
		end
		Duel.SpecialSummonComplete()
	end
end
function c18760514.splimit(e,c)
	return not c:IsRace(RACE_ZOMBIE)
end
