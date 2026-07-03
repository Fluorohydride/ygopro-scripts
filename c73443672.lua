--黄泉天輪
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)>=5 and Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_GRAVE,nil,TYPE_MONSTER)>=5
end
function s.rmfilter(c,tp)
	return c:IsAbleToRemove(tp,POS_FACEDOWN) and c:IsType(TYPE_MONSTER)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local rm1=Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_DECK,0,1,nil,tp)
	local rm2=Duel.IsPlayerCanRemove(1-tp) and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and (rm1 or rm2) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,PLAYER_ALL,LOCATION_DECK)
end
function s.spfilter1(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p1=Duel.GetTurnPlayer()
	local p2=1-Duel.GetTurnPlayer()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if Duel.Destroy(g,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		local g1=Duel.GetMatchingGroup(Card.IsType,p1,LOCATION_DECK,0,nil,TYPE_MONSTER)
		local g2=Duel.GetMatchingGroup(Card.IsType,p2,LOCATION_DECK,0,nil,TYPE_MONSTER)
		local b1=#g1>0 and Duel.Remove(g1,POS_FACEDOWN,REASON_EFFECT,p1)>0
		local b2=#g2>0 and Duel.Remove(g2,POS_FACEDOWN,REASON_EFFECT,p2)>0
		if (b1 or b2) and Duel.GetLocationCount(p1,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.spfilter1),p1,LOCATION_GRAVE,0,1,nil,e,p1)
			and Duel.SelectYesNo(p1,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,p1,HINTMSG_SPSUMMON)
			local sg1=Duel.SelectMatchingCard(p1,aux.NecroValleyFilter(s.spfilter1),p1,LOCATION_GRAVE,0,1,1,nil,e,p1)
			Duel.HintSelection(sg1)
			local sc=sg1:GetFirst()
			Duel.BreakEffect()
			Duel.SpecialSummon(sc,0,p1,p1,false,false,POS_FACEUP)
		end
	end
end
function s.spfilter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsType(TYPE_MONSTER)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,PLAYER_ALL,LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p1=Duel.GetTurnPlayer()
	local p2=1-Duel.GetTurnPlayer()
	local tc1=nil
	local tc2=nil
	if Duel.GetLocationCount(p1,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.spfilter2),p1,LOCATION_GRAVE,0,1,nil,e,p1)
		and Duel.SelectYesNo(p1,aux.Stringid(id,3)) then
		Duel.Hint(HINT_SELECTMSG,p1,HINTMSG_SPSUMMON)
		local sg1=Duel.SelectMatchingCard(p1,aux.NecroValleyFilter(s.spfilter2),p1,LOCATION_GRAVE,0,1,1,nil,e,p1)
		Duel.HintSelection(sg1)
		tc1=sg1:GetFirst()
	end
	if Duel.GetLocationCount(p2,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.spfilter2),p2,LOCATION_GRAVE,0,1,nil,e,p2)
		and Duel.SelectYesNo(p2,aux.Stringid(id,3)) then
		Duel.Hint(HINT_SELECTMSG,p2,HINTMSG_SPSUMMON)
		local sg2=Duel.SelectMatchingCard(p2,aux.NecroValleyFilter(s.spfilter2),p2,LOCATION_GRAVE,0,1,1,nil,e,p2)
		Duel.HintSelection(sg2)
		tc2=sg2:GetFirst()
	end
	if tc1 then
		if Duel.SpecialSummonStep(tc1,0,p1,p1,true,false,POS_FACEUP) then
			tc1:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,4))
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e1:SetValue(LOCATION_REMOVED)
			tc1:RegisterEffect(e1,true)
		end
	end
	if tc2 then
		if Duel.SpecialSummonStep(tc2,0,p2,p2,true,false,POS_FACEUP) then
			tc2:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,4))
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e1:SetValue(LOCATION_REMOVED)
			tc2:RegisterEffect(e1,true)
		end
	end
	Duel.SpecialSummonComplete()
end
