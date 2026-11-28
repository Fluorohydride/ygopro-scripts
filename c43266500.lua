--太陽神の支配
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,10000010)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_CONTROL+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,id+o)
	e2:SetCost(s.reccost)
	e2:SetTarget(s.rectg)
	e2:SetOperation(s.recop)
	c:RegisterEffect(e2)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1f0)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function s.cfilter2(c)
	return c:IsFaceup() and c:IsCode(10000010)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
	local mg=Duel.GetMatchingGroup(s.cnfilter,tp,0,LOCATION_MZONE,nil)
	local b1=not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2
		and sg:GetClassCount(Card.GetControler)>=2
	local b2=Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		 and mg:GetCount()>0
	if chk==0 then
		return b1 or b2
	end
	if b1 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,PLAYER_ALL,LOCATION_GRAVE)
	end
	if b2 then
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,mg,mg:GetCount(),0,0)
	end
end
function s.cgheck(c)
	return c:GetClassCount(Card.GetControler)==2
end
function s.cnfilter(c)
	return c:IsControlerCanBeChanged(true)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local res=false
	if not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
		if g:CheckSubGroup(s.cgheck,2,2) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:SelectSubGroup(tp,s.cgheck,false,2,2)
			if sg:GetCount()>1 and Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 then
				res=true
			end
		end
	end
	if Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		if res then
			Duel.BreakEffect()
		end
		local g=Duel.GetMatchingGroup(s.cnfilter,tp,0,LOCATION_MZONE,nil)
		Duel.GetControl(g,tp)
	end
end
function s.recfilter(c)
	return c:IsSetCard(0x1f0) and c:GetAttack()>0
end
function s.reccost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100,0)
	local c=e:GetHandler()
	if chk==0 then return aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,chk) and Duel.CheckReleaseGroup(tp,s.recfilter,1,nil) end
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,s.recfilter,1,1,nil)
	e:SetLabel(100,g:GetFirst():GetAttack())
	Duel.Release(g,REASON_COST)
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local label,rec=e:GetLabel()
	if chk==0 then
		e:SetLabel(0,0)
		if label~=100 then return false end
		return true
	end
	e:SetLabel(0,0)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
