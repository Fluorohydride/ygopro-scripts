--ジャンク・シグナル
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,60800381,44508094)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_CHAIN_END)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.resfilter(c,e,tp)
	return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,c,e,tp)
		and Duel.GetMZoneCount(tp,c)>0
end
function s.filter(c,e,tp,fid)
	return (aux.IsCodeOrListed(c,60800381) or aux.IsCodeOrListed(c,44508094))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (fid==nil or c:GetFieldID()~=fid)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.CheckReleaseGroup(tp,s.resfilter,1,nil,e,tp)
	local ch=Duel.GetCurrentChain()
	local b2=false
	if e:GetHandler():IsStatus(STATUS_CHAINING) then ch=ch-1 end
	local tse=nil
	if ch>1 then
		local se,p=Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		tse=Duel.GetChainInfo(ch,CHAININFO_TRIGGERING_EFFECT)
		local tep=Duel.GetChainInfo(ch,CHAININFO_TRIGGERING_PLAYER)
		b2=se and se:GetHandler():IsType(TYPE_SYNCHRO) and se:IsActiveType(TYPE_MONSTER) and p==tp and tep==1-tp and Duel.IsChainDisablable(ev)
	end
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,1),1},
		{b2,aux.Stringid(id,2),2})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		local cost_card=Duel.SelectReleaseGroup(tp,s.resfilter,1,1,nil,e,tp):GetFirst()
		Duel.Release(cost_card,REASON_COST)
		local fid=cost_card:GetFieldID()
		e:SetLabel(1,fid)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
	elseif op==2 then
		e:SetCategory(CATEGORY_DISABLE)
		if tse then
			local og=Group.FromCards(tse:GetHandler())
			Duel.SetOperationInfo(0,CATEGORY_DISABLE,og,1,0,0)
		end
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetTargetRange(1,0)
	e0:SetTarget(s.splimit)
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
	local op,fid=e:GetLabel()
	if op==1 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,fid)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif op==2 then
		local ch=Duel.GetCurrentChain()
		Duel.NegateEffect(ch-1)
	end
end
function s.splimit(e,c)
	return not c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_EXTRA)
end
