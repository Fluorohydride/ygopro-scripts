--カツト・イン・シャーク
local s,id,o=GetID()
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_BECOME_TARGET)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon1)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetCondition(s.spcon2)
	c:RegisterEffect(e2)
	--recycle
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id+o)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
function s.cfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function s.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(s.cfilter,nil,tp)==1 and eg:GetCount()==1
end
function s.costfilter(c,eg,tp)
	return eg:IsContains(c) and Duel.GetMZoneCount(tp,c)>0
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,s.costfilter,1,nil,eg,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,s.costfilter,1,1,nil,eg,tp)
	Duel.Release(g,REASON_COST)
end
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(s.cfilter,nil,tp)==1 and eg:GetCount()==1 and Duel.GetAttacker():IsControler(1-tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(s.cthop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToHand() and not c:IsCode(id)
end
function s.cthop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end