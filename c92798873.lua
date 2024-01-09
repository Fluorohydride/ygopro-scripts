--ダイノルフィア・レクスターム
local s,id,o=GetID()
function c92798873.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c92798873.matfilter,aux.FilterBoolFunction(Card.IsFusionSetCard,0x173),true)
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(c92798873.actfilter)
	c:RegisterEffect(e1)
	--atk change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(92798873,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_CHAIN_END+TIMINGS_CHECK_MONSTER+TIMING_DAMAGE_STEP+TIMING_END_PHASE)
	e2:SetCountLimit(1,92798873)
	e2:SetCondition(aux.dscon)
	e2:SetCost(c92798873.atkcost)
	e2:SetTarget(c92798873.atktg)
	e2:SetOperation(c92798873.atkop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(92798873,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,92798873+o)
	e3:SetCondition(c92798873.spcon)
	e3:SetTarget(c92798873.sptg)
	e3:SetOperation(c92798873.spop)
	c:RegisterEffect(e3)
end
function c92798873.matfilter(c)
	return c:IsFusionType(TYPE_FUSION) and c:IsFusionSetCard(0x173)
end
function c92798873.actfilter(e,c)
	return c:IsAttackAbove(Duel.GetLP(e:GetHandlerPlayer()))
end
function c92798873.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c92798873.atkfilter(c,lp)
	return c:IsFaceup() and c:GetAttack()~=lp
end
function c92798873.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local cost=math.floor(Duel.GetLP(tp)/2)
		local ce={Duel.IsPlayerAffectedByEffect(tp,EFFECT_LPCOST_CHANGE)}
		for _,te in ipairs(ce) do
			local con=te:GetCondition()
			local val=te:GetValue()
			if (not con or con(te)) then
				cost=val(te,e,tp,cost)
			end
		end
		return Duel.IsExistingMatchingCard(c92798873.atkfilter,tp,0,LOCATION_MZONE,1,nil,Duel.GetLP(tp)-cost)
	end
end
function c92798873.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lp=Duel.GetLP(tp)
	local g=Duel.GetMatchingGroup(c92798873.atkfilter,tp,0,LOCATION_MZONE,nil,nil)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(lp)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c92798873.spcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c92798873.spfilter(c,e,tp)
	return c:IsSetCard(0x173) and c:IsLevelBelow(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c92798873.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c92798873.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c92798873.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c92798873.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
