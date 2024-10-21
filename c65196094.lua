--バラエティ・アウト
function c65196094.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c65196094.cost)
	e1:SetTarget(c65196094.target)
	e1:SetOperation(c65196094.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(65196094,ACTIVITY_SPSUMMON,c65196094.counterfilter)
end
function c65196094.counterfilter(c)
	return not c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c65196094.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.GetCustomActivityCount(65196094,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65196094.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c65196094.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
function c65196094.cfilter(c,e,tp,g,maxc)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsAbleToExtraAsCost()
		and g:CheckWithSumEqual(Card.GetLevel,c:GetLevel(),1,maxc)
end
function c65196094.spfilter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65196094.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local maxc=ft+1
	if maxc>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then maxc=1 end
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		if maxc<=0 then return end
		local spg=Duel.GetMatchingGroup(c65196094.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
		return Duel.IsExistingMatchingCard(c65196094.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,spg,maxc)
	end
	e:SetLabel(0)
	local spg=Duel.GetMatchingGroup(c65196094.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local cg=Duel.SelectMatchingCard(tp,c65196094.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,spg,maxc)
	local lv=cg:GetFirst():GetLevel()
	Duel.SendtoDeck(cg,nil,SEQ_DECKTOP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=spg:SelectWithSumEqual(tp,Card.GetLevel,lv,1,maxc)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,sg:GetCount(),0,0)
end
function c65196094.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ct=g:GetCount()
	if ct==0 or (ct>1 and Duel.IsPlayerAffectedByEffect(tp,59822133))
		or ct>Duel.GetLocationCount(tp,LOCATION_MZONE) then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
