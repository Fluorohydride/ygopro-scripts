--リトル・オポジション
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c,e,tp,z)
	return c:IsLevelBelow(2)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE,tp,z)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local z=0
	for i=0,4 do
		if Duel.CheckLocation(tp,LOCATION_MZONE,i) and Duel.CheckLocation(1-tp,LOCATION_MZONE,4-i) then z=z|2^i end
	end
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp,z) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,~z)
	local ts=math.log(s,2)
	e:SetLabel(s)
	Duel.Hint(HINT_ZONE,tp,s|2^(4-ts)<<16)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local z=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,z)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp,z):GetFirst()
	if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE,z)>0 then
		if sc:IsFacedown() then Duel.ConfirmCards(1-tp,sc) end
		local sq=4-sc:GetSequence()
		local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_DECK+LOCATION_HAND,nil,e,1-tp,2^sq)
		if Duel.CheckLocation(1-tp,LOCATION_MZONE,sq) and #g>0
			and Duel.SelectYesNo(1-tp,aux.Stringid(id,1)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
			local sc2=g:Select(1-tp,1,1,nil):GetFirst()
			Duel.BreakEffect()
			Duel.SpecialSummon(sc2,0,1-tp,1-tp,false,false,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE,2^sq)
			if sc2:IsFacedown() then Duel.ConfirmCards(tp,sc2) end
		end
	end
end
