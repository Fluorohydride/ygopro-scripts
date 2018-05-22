--不知火の隠者
function c94801854.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(94801854,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,94801854)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c94801854.cost)
	e1:SetTarget(c94801854.target)
	e1:SetOperation(c94801854.operation)
	c:RegisterEffect(e1)
	--special summon(remove)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(94801854,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,94801855)
	e2:SetTarget(c94801854.sptg)
	e2:SetOperation(c94801854.spop)
	c:RegisterEffect(e2)
end
function c94801854.spcfilter(c,ft,tp)
	return c:IsRace(RACE_ZOMBIE)
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
function c94801854.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,c94801854.spcfilter,1,nil,ft,tp) end
	local sg=Duel.SelectReleaseGroup(tp,c94801854.spcfilter,1,1,nil,ft,tp)
	Duel.Release(sg,REASON_COST)
end
function c94801854.spfilter1(c,e,tp)
	return c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_TUNER) and c:IsDefense(0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c94801854.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c94801854.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c94801854.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c94801854.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c94801854.spfilter2(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xd9) and not c:IsCode(94801854) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c94801854.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c94801854.spfilter2(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c94801854.spfilter2,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	local ct=math.min(2,(Duel.GetLocationCount(tp,LOCATION_MZONE)))
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or not Duel.IsEnvironment(40005099) then ct=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c94801854.spfilter2,tp,LOCATION_REMOVED,0,1,ct,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c94801854.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if g:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=g:Select(tp,ft,ft,nil)
	end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
