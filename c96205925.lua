--異解△福音
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1ed))
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local dct=Duel.GetMatchingGroupCount(Card.IsAbleToRemoveAsCost,tp,LOCATION_DECK,0,nil,POS_FACEDOWN)
	if chk==0 then return dct>=5 or dct<5 and Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,5-dct,nil,POS_FACEDOWN) end
	if dct>5 then dct=5 end
	local gg=Group.CreateGroup()
	if dct>=5 and Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,1,nil,POS_FACEDOWN)
		and Duel.SelectYesNo(tp,aux.Stringid(id,0))
		or dct<5 then
		local st=dct
		if st==5 then st=4 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		gg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,5-st,5,nil,POS_FACEDOWN)
		Duel.HintSelection(gg)
	end
	if gg:GetCount()>0 then
		dct=5-gg:GetCount()
	end
	local dg=Duel.GetDecktopGroup(tp,dct)
	if dct<5 then
		dg:Merge(gg)
	end
	Duel.DisableShuffleCheck()
	if Duel.Remove(dg,POS_FACEDOWN,REASON_COST)~=0 then
		for tc in aux.Next(dg) do
			if tc:IsFacedown() and tc:IsLocation(LOCATION_REMOVED) then
				tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
			end
		end
	end
end
function s.rmfilter(c,tp,chk)
	return c:IsFaceupEx() and c:IsSetCard(0x1ed) and c:GetOriginalLevel()>0 and c:GetOriginalLevel()<=4
		and c:IsAbleToRemove(tp,POS_FACEDOWN) and (not chk or Duel.GetMZoneCount(tp,c)>0)
end
function s.spfilter(c,e,tp)
	return c:IsFacedown() and c:IsSetCard(0x1ed) and c:IsLevelAbove(5)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_MZONE,0,1,nil,tp,true)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_MZONE,0,nil,tp,true)
	if #g==0 then g=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_MZONE,0,nil,tp,false) end
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local dg=g:Select(tp,1,1,nil)
	Duel.HintSelection(dg)
	if Duel.Remove(dg,POS_FACEDOWN,REASON_EFFECT)~=0 then
		local tc=dg:GetFirst()
		if tc:IsFacedown() and tc:IsLocation(LOCATION_REMOVED) then
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,4))
		end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
			if sg:GetCount()>0 then
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
