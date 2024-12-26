--マシンナーズ・カーネル
---@param c Card
function c87074380.initial_effect(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(c87074380.splimit)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(87074380,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,87074380)
	e2:SetTarget(c87074380.destg)
	e2:SetOperation(c87074380.desop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(87074380,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,87074381)
	e3:SetCondition(c87074380.spcon)
	e3:SetTarget(c87074380.sptg)
	e3:SetOperation(c87074380.spop)
	c:RegisterEffect(e3)
end
function c87074380.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function c87074380.cfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
		and Duel.IsExistingMatchingCard(c87074380.desfilter,tp,0,LOCATION_MZONE,1,nil,c:GetAttack())
end
function c87074380.desfilter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk)
end
function c87074380.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c87074380.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c87074380.cfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,c87074380.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	local g=Duel.GetMatchingGroup(c87074380.desfilter,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
	g:AddCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c87074380.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRace(RACE_MACHINE) then
		local g=Duel.GetMatchingGroup(c87074380.desfilter,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
		if g:GetCount()>0 then
			g:AddCard(tc)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c87074380.sfilter(c,tp)
	return not c:IsCode(87074380) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
		and bit.band(c:GetPreviousAttributeOnField(),ATTRIBUTE_EARTH)~=0
		and bit.band(c:GetPreviousRaceOnField(),RACE_MACHINE)~=0
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c87074380.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c87074380.sfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c87074380.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c87074380.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
