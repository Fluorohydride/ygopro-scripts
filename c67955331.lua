--幸運の前借り
function c67955331.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,67955331+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c67955331.target)
	e1:SetOperation(c67955331.activate)
	c:RegisterEffect(e1)
end
function c67955331.filter(c,e,tp)
	local lv=c:GetOriginalLevel()
	return lv>1 and c:IsFaceup() and c:IsSetCard(0x12e)
		and Duel.IsExistingMatchingCard(c67955331.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,lv)
end
function c67955331.spfilter(c,e,tp,clv)
	local lv=c:GetOriginalLevel()
	return lv>0 and lv==clv-1 and c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67955331.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c67955331.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c67955331.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c67955331.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c67955331.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup()
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c67955331.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,tc:GetOriginalLevel())
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c67955331.splimit)
	if Duel.GetTurnPlayer()==tp then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(c67955331.splimcon)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
	end
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c67955331.splimcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c67955331.splimit(e,c)
	return not c:IsRace(RACE_SPELLCASTER)
end
