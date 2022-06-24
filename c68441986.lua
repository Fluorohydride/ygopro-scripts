--蚊学忍法・軍蚊マーチ
function c68441986.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(68441986,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,68441986)
	e1:SetTarget(c68441986.sptg)
	e1:SetOperation(c68441986.spop)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(68441986,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,68441987)
	e2:SetCondition(c68441986.countercond)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c68441986.countertg)
	e2:SetOperation(c68441986.counterop)
	c:RegisterEffect(e2)
end
function c68441986.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsRace(RACE_INSECT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c68441986.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c68441986.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c68441986.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c68441986.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),#g,2)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,c68441986.spcheck,false,1,ft)
	if sg then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c68441986.spcheck(sg)
	return sg:GetClassCount(Card.GetLevel)==1
end
function c68441986.cfilter(c)
	return c:IsFaceup() and c:IsCode(32453837)
end
function c68441986.countercond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c68441986.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c68441986.ctfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT)
end
function c68441986.tgfilter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x1063,1)
end
function c68441986.countertg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	local ct=Duel.GetMatchingGroupCount(c68441986.ctfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return ct>0 and Duel.IsExistingTarget(c68441986.tgfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
	local g=Duel.SelectTarget(tp,c68441986.tgfilter,tp,0,LOCATION_MZONE,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,0,0,0)
end
function c68441986.ctcon(e)
	return e:GetHandler():GetCounter(0x1063)>0
end
function c68441986.counterop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g==0 then return end
	local c=e:GetHandler()
	for tc in aux.Next(g) do
		if tc:AddCounter(0x1063,1) then
			--Negate its effects
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetCondition(c68441986.ctcon)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
