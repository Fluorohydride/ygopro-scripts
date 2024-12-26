--真炎竜アルビオン
---@param c Card
function c38811586.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,68468459,c38811586.matfilter,1,true,true)
	--cannot fusion material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--special summon grave 2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(38811586,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,38811586)
	e3:SetCondition(c38811586.spcon)
	e3:SetTarget(c38811586.sptg)
	e3:SetOperation(c38811586.spop)
	c:RegisterEffect(e3)
	--Special Summon itself
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,38811587)
	e4:SetTarget(c38811586.spittg)
	e4:SetOperation(c38811586.spitop)
	c:RegisterEffect(e4)
end
function c38811586.branded_fusion_check(tp,sg,fc)
	return aux.gffcheck(sg,Card.IsFusionCode,68468459,c38811586.matfilter)
end
function c38811586.matfilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_SPELLCASTER)
end
function c38811586.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c38811586.spfilter(c,e,tp)
	return c:IsCanBeEffectTarget(e) and c:IsType(TYPE_MONSTER)
end
function c38811586.spsumfilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp)
end
function c38811586.spsumfilter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function c38811586.gcheck(g,e,tp)
	if #g~=2 then return false end
	local ac=g:GetFirst()
	local bc=g:GetNext()
	return c38811586.spsumfilter1(ac,e,tp) and c38811586.spsumfilter2(bc,e,tp)
		or c38811586.spsumfilter1(bc,e,tp) and c38811586.spsumfilter2(ac,e,tp)
end
function c38811586.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c38811586.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
	if chk==0 then
		local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
		return not Duel.IsPlayerAffectedByEffect(tp,59822133) and ft1>0 and ft2>0
			and g:CheckSubGroup(c38811586.gcheck,2,2,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,c38811586.gcheck,false,2,2,e,tp)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,PLAYER_ALL,LOCATION_GRAVE)
end
function c38811586.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or ft1<=0 or ft2<=0 then return end
	local g=Duel.GetTargetsRelateToChain()
	if not g:CheckSubGroup(c38811586.gcheck,2,2,e,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(38811586,1))
	local sg=g:FilterSelect(tp,c38811586.spsumfilter1,1,1,nil,e,tp)
	Duel.SpecialSummonStep(sg:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummonStep((g-sg):GetFirst(),0,tp,1-tp,false,false,POS_FACEUP)
	Duel.SpecialSummonComplete()
end
function c38811586.rfilter(c)
	return c:IsReleasableByEffect() and (c:GetSequence()>4 or c:GetSequence()==2)
end
function c38811586.spittg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rg=Duel.GetMatchingGroup(c38811586.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e,tp)
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and #rg>=4 and Duel.GetMZoneCount(tp,rg)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,rg,4,0,0)
end
function c38811586.spitop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rg=Duel.GetMatchingGroup(c38811586.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #rg==4 and Duel.Release(rg,REASON_EFFECT)==4 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
