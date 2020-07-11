--プランキッズ・ウェザー
function c44509529.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x120),2,true)
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetCondition(c44509529.actcon)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(44509529,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,44509529)
	e2:SetHintTiming(0,TIMING_BATTLE_START+TIMING_END_PHASE)
	e2:SetCondition(c44509529.spcon)
	e2:SetTarget(c44509529.sptg)
	e2:SetOperation(c44509529.spop)
	c:RegisterEffect(e2)
	c44509529.prankrep_effect=e2
end
function c44509529.actcon(e)
	local a=Duel.GetAttacker()
	return a and a:IsControler(e:GetHandlerPlayer()) and a:IsSetCard(0x120)
end
function c44509529.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c44509529.spfilter(c,e,tp)
	return c:IsSetCard(0x120) and not c:IsType(TYPE_FUSION)
		and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c44509529.costfilter(c)
	return c:IsHasEffect(101102049) and c:IsAbleToRemoveAsCost()
end
function c44509529.repfilter1(c,tp)
	return Duel.GetMZoneCount(tp,c)>1
end
function c44509529.repfilter2(c,g)
	local cg=g:Clone()
	cg:RemoveCard(c)
	return cg:GetClassCount(Card.GetCode)>=2
end
function c44509529.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c44509529.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local g1=Duel.GetMatchingGroup(c44509529.costfilter,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(c44509529.costfilter,tp,LOCATION_GRAVE,0,nil)
	local b=c:IsReleasable() and Duel.GetMZoneCount(tp,c)>1
	local b1=c:IsSetCard(0x120) and g1:IsExists(c44509529.repfilter1,1,nil,tp) and g:GetClassCount(Card.GetCode)>=2
	local b2=c:IsSetCard(0x120) and g2:IsExists(c44509529.repfilter2,1,nil,g) and Duel.GetMZoneCount(tp)>1
	if chk==0 then return (b or b1 or b2) and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	local off=0
	local ops={}
	local opval={}
	off=1
	if b then
		ops[off]=aux.Stringid(44509529,1)
		opval[off-1]=1
		off=off+1
	end
	if b1 then
		ops[off]=aux.Stringid(44509529,2)
		opval[off-1]=2
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(44509529,3)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.Release(c,REASON_COST)
	elseif opval[op]==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=g1:FilterSelect(tp,c44509529.repfilter1,1,1,nil,tp)
		Duel.Remove(rg,POS_FACEUP,REASON_COST+REASON_REPLACE)
		Duel.RegisterFlagEffect(tp,101102049,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=g2:FilterSelect(tp,c44509529.repfilter2,1,1,nil,g)
		Duel.Remove(rg,POS_FACEUP,REASON_COST+REASON_REPLACE)
		Duel.RegisterFlagEffect(tp,101102049,RESET_PHASE+PHASE_END,0,1)
	end
	g=Duel.GetMatchingGroup(c44509529.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,2,0,0)
end
function c44509529.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=tg:Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 or ft<=0 or (g:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then return end
	if ft<g:GetCount() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=g:Select(tp,ft,ft,nil)
	end
	local tc=g:GetFirst()
	while tc do
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
end
