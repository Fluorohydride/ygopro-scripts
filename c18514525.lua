--プランキッズ・ロケット
function c18514525.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x120),2,true)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(18514525,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,18514525)
	e1:SetCondition(c18514525.atkcon)
	e1:SetOperation(c18514525.atkop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(18514525,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,18514526)
	e2:SetCost(c18514525.spcost)
	e2:SetTarget(c18514525.sptg)
	e2:SetOperation(c18514525.spop)
	c:RegisterEffect(e2)
end
function c18514525.atkcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c18514525.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=c:GetAttack()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or atk<1000 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	if not c:IsHasEffect(EFFECT_REVERSE_UPDATE) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DIRECT_ATTACK)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end
function c18514525.excostfilter(c,tp)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsAbleToRemoveAsCost() and c:IsHasEffect(25725326,tp)
end
function c18514525.costfilter(c,tp,g)
	local tg=g:Clone()
	tg:RemoveCard(c)
	return Duel.GetMZoneCount(tp,c)>1 and tg:GetClassCount(Card.GetCode)>=2
end
function c18514525.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(0)
	local g=Duel.GetMatchingGroup(c18514525.excostfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,tp)
	local tg=Duel.GetMatchingGroup(c18514525.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if e:GetHandler():IsReleasable() then g:AddCard(e:GetHandler()) end
	if chk==0 then
		e:SetLabel(100)
		return not Duel.IsPlayerAffectedByEffect(tp,59822133) and g:IsExists(c18514525.costfilter,1,nil,tp,tg)
	end
	local cg=g:Filter(c18514525.costfilter,nil,tp,tg)
	local tc
	if #cg>1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(25725326,0))
		tc=cg:Select(tp,1,1,nil):GetFirst()
	else
		tc=cg:GetFirst()
	end
	local te=tc:IsHasEffect(25725326,tp)
	if te then
		te:UseCountLimit(tp)
		Duel.Remove(tc,POS_FACEUP,REASON_COST+REASON_REPLACE)
	else
		Duel.Release(tc,REASON_COST)
	end
end
function c18514525.spfilter(c,e,tp)
	return c:IsSetCard(0x120) and not c:IsType(TYPE_FUSION)
		and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c18514525.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return e:GetLabel()==100 end
	e:SetLabel(0)
	local g=Duel.GetMatchingGroup(c18514525.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,2,0,0)
end
function c18514525.spop(e,tp,eg,ep,ev,re,r,rp)
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
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
end
