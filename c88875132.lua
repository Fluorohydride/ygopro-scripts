--爆走軌道フライング・ペガサス
function c88875132.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88875132,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,88875132)
	e1:SetTarget(c88875132.sptg)
	e1:SetOperation(c88875132.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--lv change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(88875132,1))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,88875133)
	e3:SetCost(c88875132.lvcost)
	e3:SetTarget(c88875132.lvtg)
	e3:SetOperation(c88875132.lvop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(88875132,ACTIVITY_ATTACK,c88875132.counterfilter)
end
function c88875132.counterfilter(c)
	return c:IsType(TYPE_XYZ)
end
function c88875132.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_MACHINE) and not c:IsCode(88875132)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c88875132.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c88875132.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c88875132.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c88875132.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c88875132.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
end
function c88875132.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(88875132,tp,ACTIVITY_ATTACK)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OATH)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c88875132.atktg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c88875132.atktg(e,c)
	return not c:IsType(TYPE_XYZ)
end
function c88875132.lvfilter(c,lv)
	return c:IsFaceup() and c:IsLevelAbove(1) and not c:IsLevel(lv)
end
function c88875132.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local lv=c:GetLevel()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c88875132.lvfilter(chkc,lv) end
	if chk==0 then return lv>0 and Duel.IsExistingTarget(c88875132.lvfilter,tp,LOCATION_MZONE,0,1,c,lv) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c88875132.lvfilter,tp,LOCATION_MZONE,0,1,1,c,lv)
end
function c88875132.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e)
		and tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsLevel(c:GetLevel()) then
		local g=Group.FromCards(c,tc)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(88875132,2))
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		g:RemoveCard(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(tc:GetLevel())
		g:GetFirst():RegisterEffect(e1)
	end
end
