--妖海のアウトロール
function c43464884.initial_effect(c)
	--change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(43464884,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,43464884)
	e1:SetCost(c43464884.cost)
	e1:SetTarget(c43464884.cgtg)
	e1:SetOperation(c43464884.cgop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(43464884,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,43464885)
	e3:SetCost(c43464884.cost)
	e3:SetTarget(c43464884.sptg)
	e3:SetOperation(c43464884.spop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(43464884,ACTIVITY_SPSUMMON,c43464884.counterfilter)
end
function c43464884.counterfilter(c)
	return c:IsRace(RACE_BEASTWARRIOR)
end
function c43464884.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(43464884,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c43464884.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c43464884.splimit(e,c)
	return not c:IsRace(RACE_BEASTWARRIOR)
end
function c43464884.cgfilter(c,mc)
	return c:IsRace(RACE_BEASTWARRIOR) and c:IsLevelAbove(1) and not (c:IsLevel(mc:GetLevel()) and c:IsAttribute(mc:GetAttribute()))
end
function c43464884.cgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c43464884.cgfilter(chkc,c) end
	if chk==0 then return Duel.IsExistingTarget(c43464884.cgfilter,tp,LOCATION_GRAVE,0,1,nil,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c43464884.cgfilter,tp,LOCATION_GRAVE,0,1,1,nil,c)
end
function c43464884.cgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and c:IsFaceup() and c:IsRelateToEffect(e) then
		local lv=tc:GetLevel()
		local att=tc:GetAttribute()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e2:SetValue(att)
		c:RegisterEffect(e2)
	end
end
function c43464884.spfilter(c,e,tp,mc)
	return c:IsLevel(mc:GetLevel()) and c:IsRace(RACE_BEASTWARRIOR) and c:IsAttribute(mc:GetAttribute()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c43464884.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c43464884.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c43464884.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c43464884.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
