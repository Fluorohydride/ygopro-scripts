--D3
function c99357565.initial_effect(c)
	--setcode
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99357565,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c99357565.scop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99357565,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,99357565)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c99357565.spcost)
	e2:SetTarget(c99357565.sptg)
	e2:SetOperation(c99357565.spop)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99357565,2))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,99357566)
	e3:SetCondition(c99357565.tgcon)
	e3:SetTarget(c99357565.tgtg)
	e3:SetOperation(c99357565.tgop)
	c:RegisterEffect(e3)
end
function c99357565.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_SETCODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(0xc008)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
function c99357565.spfilter(c,e,tp)
	return c:IsCode(99357565) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99357565.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	local ct=2
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	ct=math.min(ct,Duel.GetLocationCount(tp,LOCATION_MZONE),
		Duel.GetMatchingGroupCount(c99357565.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,nil,e,tp))
	local cg=Duel.DiscardHand(tp,Card.IsDiscardable,1,ct,REASON_COST+REASON_DISCARD,nil)
	e:SetLabel(cg)
end
function c99357565.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c99357565.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,e:GetLabel(),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
end
function c99357565.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>=ct then
		if ft>1 and ct>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99357565.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,ct,ct,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c99357565.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c99357565.splimit(e,c)
	return not c:IsSetCard(0xc008)
end
function c99357565.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c99357565.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xc008) and c:IsAbleToGrave()
end
function c99357565.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99357565.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c99357565.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c99357565.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
