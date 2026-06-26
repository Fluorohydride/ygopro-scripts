--白き宿命のエルドリクシル
function c94224458.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(94224458,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,94224458)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c94224458.target)
	e1:SetOperation(c94224458.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(94224458,1))
	e2:SetCategory(CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,94224458)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c94224458.settg)
	e2:SetOperation(c94224458.setop)
	c:RegisterEffect(e2)
end
function c94224458.filter(c)
	return c:IsSetCard(0x1142) and c:IsFaceup()
end
function c94224458.spfilter(c,e,tp,check)
	return c:IsRace(RACE_ZOMBIE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (check or c:IsSetCard(0x1142))
end
function c94224458.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chk1=Duel.IsExistingMatchingCard(c94224458.filter,tp,LOCATION_MZONE,0,1,nil)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c94224458.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,chk1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c94224458.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local chk1=Duel.IsExistingMatchingCard(c94224458.filter,tp,LOCATION_MZONE,0,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c94224458.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,chk1)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c94224458.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c94224458.splimit(e,c)
	return not c:IsRace(RACE_ZOMBIE)
end
function c94224458.stfilter(c)
	return c:IsSetCard(0x143) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c94224458.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c94224458.stfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c94224458.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c94224458.stfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end
