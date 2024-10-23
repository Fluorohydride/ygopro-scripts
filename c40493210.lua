--魔鍵錠－施－
function c40493210.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c40493210.cost)
	e1:SetTarget(c40493210.target)
	e1:SetOperation(c40493210.activate)
	c:RegisterEffect(e1)
end
function c40493210.cfilter(c,tp)
	return not c:IsType(TYPE_TOKEN) and (c:IsType(TYPE_NORMAL) or c:IsSetCard(0x165))
		and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.GetMZoneCount(tp,c)>0
end
function c40493210.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c40493210.cfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c40493210.cfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c40493210.spfilter(c,e,tp)
	return (c:IsType(TYPE_NORMAL) or c:IsSetCard(0x165)) and c:IsLevelBelow(8)
		and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c40493210.gcheck(g)
	return g:GetSum(Card.GetLevel)<=8
end
function c40493210.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c40493210.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(c40493210.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if ft>2 then ft=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,c40493210.gcheck,false,1,ft)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,#sg,0,0)
end
function c40493210.syncsumfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x165) and c:IsSynchroSummonable(nil)
end
function c40493210.xyzsumfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x165) and c:IsXyzSummonable(nil)
end
function c40493210.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if g:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=g:Select(tp,ft,ft,nil)
	end
	local res=Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	Duel.AdjustAll()
	local b1=Duel.IsExistingMatchingCard(c40493210.syncsumfilter,tp,LOCATION_EXTRA,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c40493210.xyzsumfilter,tp,LOCATION_EXTRA,0,1,nil)
	if res~=0 and (b1 or b2) then
		local off=1
		local ops,opval={},{}
		if b1 then
			ops[off]=aux.Stringid(40493210,0)
			opval[off]=0
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(40493210,1)
			opval[off]=1
			off=off+1
		end
		ops[off]=aux.Stringid(40493210,2)
		opval[off]=2
		local op=Duel.SelectOption(tp,table.unpack(ops))+1
		local sel=opval[op]
		if sel==0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg1=Duel.SelectMatchingCard(tp,c40493210.syncsumfilter,tp,LOCATION_EXTRA,0,1,1,nil)
			Duel.SynchroSummon(tp,sg1:GetFirst(),nil)
		elseif sel==1 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg2=Duel.SelectMatchingCard(tp,c40493210.xyzsumfilter,tp,LOCATION_EXTRA,0,1,1,nil)
			Duel.XyzSummon(tp,sg2:GetFirst(),nil)
		end
	end
end
