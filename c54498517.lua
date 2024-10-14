--ギガンティック・スプライト
---@param c Card
function c54498517.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c54498517.mfilter,nil,2,2)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetCondition(c54498517.adcon)
	e1:SetValue(c54498517.atkval)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,54498517)
	e2:SetTarget(c54498517.sptg)
	e2:SetOperation(c54498517.spop)
	c:RegisterEffect(e2)
end
function c54498517.mfilter(c,xyzc)
	return c:IsXyzLevel(xyzc,2) or c:IsLink(2)
end
function c54498517.adcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
end
function c54498517.atkval(e,c)
	return c:GetBaseAttack()*2
end
function c54498517.spfilter(c,e,tp)
	return c:IsLevel(2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c54498517.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_EFFECT)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c54498517.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c54498517.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c54498517.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_EFFECT)~=0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,1)
	e1:SetTarget(c54498517.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c54498517.splimit(e,c)
	return not c:IsLevel(2) and not c:IsRank(2) and not c:IsLink(2)
end
