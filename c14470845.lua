--おジャマデュオ
function c14470845.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c14470845.target)
	e1:SetOperation(c14470845.activate)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(14470845,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c14470845.sptg)
	e2:SetOperation(c14470845.spop)
	c:RegisterEffect(e2)
end
function c14470845.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,29843092,0xf,TYPES_TOKEN_MONSTER,0,1000,2,RACE_BEAST,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENSE,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c14470845.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)<2 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,29843092,0xf,TYPES_TOKEN_MONSTER,0,1000,2,RACE_BEAST,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENSE,1-tp) then return end
	for i=1,2 do
		local token=Duel.CreateToken(tp,14470845+i)
		if Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UNRELEASABLE_SUM)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(1)
			token:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_LEAVE_FIELD)
			e2:SetOperation(c14470845.damop)
			token:RegisterEffect(e2,true)
		end
	end
	Duel.SpecialSummonComplete()
end
function c14470845.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_DESTROY) then
		Duel.Damage(c:GetPreviousControler(),300,REASON_EFFECT)
	end
	e:Reset()
end
function c14470845.spfilter(c,e,tp)
	return c:IsSetCard(0xf) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c14470845.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c14470845.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		return not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and g:GetClassCount(Card.GetCode)>=2 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c14470845.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c14470845.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if not Duel.IsPlayerAffectedByEffect(tp,59822133) and ft>1 and g:GetClassCount(Card.GetCode)>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	end
end
