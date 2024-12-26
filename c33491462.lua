--六花精スノードロップ
---@param c Card
function c33491462.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33491462,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33491462)
	e1:SetCost(c33491462.spcost)
	e1:SetTarget(c33491462.sptg)
	e1:SetOperation(c33491462.spop)
	c:RegisterEffect(e1)
	--level
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33491462,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,33491463)
	e2:SetTarget(c33491462.lvtg)
	e2:SetOperation(c33491462.lvop)
	c:RegisterEffect(e2)
end
function c33491462.rfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>1 and (c:IsControler(tp) or c:IsFaceup())
		and (c:IsRace(RACE_PLANT) or c:IsHasEffect(76869711,tp) and c:IsControler(1-tp))
end
function c33491462.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c33491462.rfilter,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c33491462.rfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c33491462.spfilter(c,e,tp)
	return c:IsRace(RACE_PLANT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33491462.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c33491462.spfilter,tp,LOCATION_HAND,0,1,c,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND)
end
function c33491462.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c33491462.spfilter,tp,LOCATION_HAND,0,1,1,c,e,tp)
		if g:GetCount()>0 then
			g:AddCard(c)
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c33491462.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c33491462.splimit(e,c)
	return not c:IsRace(RACE_PLANT)
end
function c33491462.lvfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_PLANT) and c:IsLevelAbove(1)
end
function c33491462.lvfilter1(c,tp)
	return c33491462.lvfilter(c) and Duel.IsExistingMatchingCard(c33491462.lvfilter2,tp,LOCATION_MZONE,0,1,c,c:GetLevel())
end
function c33491462.lvfilter2(c,lv)
	return c33491462.lvfilter(c) and not c:IsLevel(lv)
end
function c33491462.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c33491462.lvfilter1(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c33491462.lvfilter1,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c33491462.lvfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c33491462.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	local lv=tc:GetLevel()
	local g=Duel.GetMatchingGroup(c33491462.lvfilter,tp,LOCATION_MZONE,0,nil)
	local lc=g:GetFirst()
	while lc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		lc:RegisterEffect(e1)
		lc=g:GetNext()
	end
end
