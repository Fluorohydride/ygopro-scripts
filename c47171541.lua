--オルフェゴール・リリース
function c47171541.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,47171541+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c47171541.cost)
	e1:SetTarget(c47171541.target)
	e1:SetOperation(c47171541.activate)
	c:RegisterEffect(e1)
end
function c47171541.rfilter(c,tp)
	return c:IsRace(RACE_MACHINE) and (c:IsControler(tp) or c:IsFaceup())
end
function c47171541.fselect(c,tp,rg,sg)
	sg:AddCard(c)
	if sg:GetCount()<2 then
		res=rg:IsExists(c47171541.fselect,1,sg,tp,rg,sg)
	else
		res=c47171541.fgoal(tp,sg)
	end
	sg:RemoveCard(c)
	return res
end
function c47171541.fgoal(tp,sg)
	if sg:GetCount()>0 and Duel.GetMZoneCount(tp,sg)>0 then
		Duel.SetSelectedCard(sg)
		return Duel.CheckReleaseGroup(tp,nil,0,nil)
	else return false end
end
function c47171541.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local rg=Duel.GetReleaseGroup(tp):Filter(c47171541.rfilter,nil,tp)
	local g=Group.CreateGroup()
	if chk==0 then return rg:IsExists(c47171541.fselect,1,nil,tp,rg,g) end
	while g:GetCount()<2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=rg:FilterSelect(tp,c47171541.fselect,1,1,g,tp,rg,g)
		g:Merge(sg)
	end
	Duel.Release(g,REASON_COST)
end
function c47171541.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47171541.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c47171541.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=e:GetLabel()==1 or Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then 
		e:SetLabel(0)
		return res and Duel.IsExistingTarget(c47171541.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	local ct=math.min(2,(Duel.GetLocationCount(tp,LOCATION_MZONE)))
	if Duel.IsPlayerAffectedByEffect(tp,59822133)
		or not Duel.IsExistingMatchingCard(c47171541.cfilter,tp,0,LOCATION_MZONE,1,nil) then
		ct=1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c47171541.spfilter,tp,LOCATION_GRAVE,0,1,ct,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c47171541.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if g:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=g:Select(tp,ft,ft,nil)
	end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
