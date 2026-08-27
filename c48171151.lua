--星霜の魔術師－アストログラフ・マジシャン
local s,id,o=GetID()
function s.initial_effect(c)
	--pendulum
	aux.EnablePendulumAttribute(c)
	--place
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.ptg)
	e1:SetOperation(s.pop)
	c:RegisterEffect(e1)
	--special summon
	local custom_code=aux.RegisterMergedDelayedEvent_ToSingleCard(c,id,EVENT_DESTROYED)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(custom_code)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.spcon1)
	e2:SetTarget(s.sptg1)
	e2:SetOperation(s.spop1)
	c:RegisterEffect(e2)
	--fusion summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+o*2)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetCondition(s.fspcon)
	e3:SetTarget(s.fsptg)
	e3:SetOperation(s.fspop)
	c:RegisterEffect(e3)
end
function s.pfilter(c,tp)
	return c:IsType(TYPE_PENDULUM) and not c:IsCode(id) and c:GetLeftScale()==1
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function s.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDestructable()
		and Duel.IsExistingMatchingCard(s.pfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
end
function s.pop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	if Duel.Destroy(c,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,s.pfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc and Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1,true)
	end
end
function s.desfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function s.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.desfilter,1,nil,tp)
end
function s.spfilter1(c,e,tp)
	if not c:IsCanBeSpecialSummoned(e,0,tp,false,false) or not c:IsControler(tp) then return false end
	if c:IsLocation(LOCATION_EXTRA) then return c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 end
	if c:IsLocation(LOCATION_GRAVE) then return aux.NecroValleyFilter()(c) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	return false
end
function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	local desg=eg:Filter(s.desfilter,nil,tp)
	Duel.SetTargetCard(desg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local desg=Duel.GetTargetsRelateToChain():Filter(s.spfilter1,nil,e,tp)
	if #desg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=desg:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if tc then
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.fspcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end
function s.fsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable(REASON_EFFECT) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,e:GetHandler(),1,0,0)
end
function s.fusfilter(c)
	return c:IsRace(RACE_DRAGON)
end
function s.matfilter(c)
	return not c:IsLocation(LOCATION_EXTRA) or c:IsFaceupEx()
end
function s.fspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() or not c:IsReleasable(REASON_EFFECT) then return end
	Duel.Release(c,REASON_EFFECT)
	local fusion_effect=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		fusion_spell_matfilter=s.matfilter,
		pre_select_mat_location=LOCATION_MZONE|LOCATION_EXTRA,
		mat_operation_code_map={
			{[LOCATION_DECK]=FusionSpell.FUSION_OPERATION_GRAVE},
			{[0xff]=FusionSpell.FUSION_OPERATION_SHUFFLE}
		}
	})
	if fusion_effect:GetTarget()(e,tp,eg,ep,ev,re,r,rp,0)
		and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
		Duel.BreakEffect()
		fusion_effect:GetOperation()(e,tp,eg,ep,ev,re,r,rp)
	end
end
