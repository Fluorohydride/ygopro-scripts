--クリバー
---@param c Card
function c44632120.initial_effect(c)
	aux.AddCodeList(c,71036835,7021574,34419588,40640057)
	--Destroyed
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(44632120,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCountLimit(1,44632120)
	e1:SetTarget(c44632120.sptg)
	e1:SetOperation(c44632120.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c44632120.spcon)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(44632120,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c44632120.spcost2)
	e3:SetTarget(c44632120.sptg2)
	e3:SetOperation(c44632120.spop2)
	c:RegisterEffect(e3)
end
c44632120.spchecks=aux.CreateChecks(Card.IsCode,{71036835,7021574,34419588,40640057})
function c44632120.spfilter(c,e,tp)
	return c:IsDefense(200) and c:IsAttack(300) and not c:IsCode(44632120) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c44632120.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c44632120.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c44632120.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c44632120.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c44632120.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousControler(tp) and c:IsPreviousSetCard(0xa4)
end
function c44632120.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c44632120.cfilter,1,nil,tp)
end
function c44632120.rlfilter(c,tp)
	return c:IsCode(71036835,7021574,34419588,40640057) and (c:IsControler(tp) or c:IsFaceup())
end
function c44632120.rlcheck(sg,c,tp)
	local g=sg:Clone()
	g:AddCard(c)
	return Duel.GetMZoneCount(tp,g)>0 and Duel.CheckReleaseGroupEx(tp,aux.IsInGroup,#g,REASON_COST,true,nil,g)
end
function c44632120.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetReleaseGroup(tp,true):Filter(c44632120.rlfilter,c,tp)
	if chk==0 then return c:IsReleasable() and g:CheckSubGroupEach(c44632120.spchecks,c44632120.rlcheck,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g:SelectSubGroupEach(tp,c44632120.spchecks,false,c44632120.rlcheck,c,tp)
	aux.UseExtraReleaseCount(rg,tp)
	rg:AddCard(c)
	Duel.Release(rg,REASON_COST)
end
function c44632120.spfilter2(c,e,tp)
	return c:IsCode(70914287) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c44632120.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c44632120.spfilter2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
end
function c44632120.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c44632120.spfilter2),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
