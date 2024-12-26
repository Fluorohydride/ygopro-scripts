--D-HERO ダークエンジェル
---@param c Card
function c26964762.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26964762,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c26964762.spcon)
	e1:SetCost(c26964762.spcost)
	e1:SetTarget(c26964762.sptg)
	e1:SetOperation(c26964762.spop)
	c:RegisterEffect(e1)
	--disable and destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetOperation(c26964762.disop)
	c:RegisterEffect(e2)
	--deck top
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26964762,1))
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1)
	e3:SetCondition(c26964762.deckcon)
	e3:SetCost(c26964762.deckcost)
	e3:SetTarget(c26964762.decktg)
	e3:SetOperation(c26964762.deckop)
	c:RegisterEffect(e3)
end
function c26964762.spcfilter(c)
	return c:IsSetCard(0xc008) and c:IsType(TYPE_MONSTER)
end
function c26964762.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c26964762.spcfilter,tp,LOCATION_GRAVE,0,3,nil)
end
function c26964762.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c26964762.spfilter(c,e,tp)
	return c:IsSetCard(0xc008) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,1-tp)
end
function c26964762.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c26964762.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c26964762.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c26964762.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c26964762.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c26964762.disop(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp and re:IsActiveType(TYPE_SPELL) then
		local rc=re:GetHandler()
		if Duel.NegateEffect(ev,true) and rc:IsRelateToEffect(re) then
			Duel.Destroy(rc,REASON_EFFECT)
		end
	end
end
function c26964762.deckcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c26964762.cfilter(c)
	return c:IsSetCard(0xc008) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c26964762.deckcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c26964762.cfilter,tp,LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c26964762.cfilter,tp,LOCATION_GRAVE,0,1,1,c)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c26964762.filter(c)
	return c:GetType()==TYPE_SPELL
end
function c26964762.decktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0
		and Duel.IsExistingMatchingCard(c26964762.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c26964762.deckop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26964762,3))
	local g1=Duel.SelectMatchingCard(tp,c26964762.filter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(26964762,3))
	local g2=Duel.SelectMatchingCard(1-tp,c26964762.filter,1-tp,LOCATION_DECK,0,1,1,nil)
	local tc1=g1:GetFirst()
	local tc2=g2:GetFirst()
	if tc1 then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc1,SEQ_DECKTOP)
		Duel.ConfirmDecktop(tp,1)
	end
	if tc2 then
		Duel.ShuffleDeck(1-tp)
		Duel.MoveSequence(tc2,SEQ_DECKTOP)
		Duel.ConfirmDecktop(1-tp,1)
	end
end
