--騎甲虫スケイル・ボム
---@param c Card
function c39041550.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(39041550,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,39041550)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c39041550.spcon)
	e1:SetTarget(c39041550.sptg)
	e1:SetOperation(c39041550.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--destroy chain
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,39041551)
	e3:SetCondition(c39041550.condition)
	e3:SetCost(c39041550.cost)
	e3:SetTarget(c39041550.target)
	e3:SetOperation(c39041550.operation)
	c:RegisterEffect(e3)
end
function c39041550.filter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_INSECT) and c:IsControler(tp)
end
function c39041550.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c39041550.filter,1,nil,tp)
end
function c39041550.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c39041550.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c39041550.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	return tc:IsControler(1-tp) and tc:IsOnField() and tc:IsRelateToEffect(re) and re:IsActiveType(TYPE_MONSTER)
end
function c39041550.cfilter(c,tp)
	return c:IsRace(RACE_INSECT) and (c:IsControler(tp) or c:IsFaceup())
end
function c39041550.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c39041550.cfilter,1,re:GetHandler(),tp) end
	local g=Duel.SelectReleaseGroup(tp,c39041550.cfilter,1,1,re:GetHandler(),tp)
	Duel.Release(g,REASON_COST)
end
function c39041550.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function c39041550.operation(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
