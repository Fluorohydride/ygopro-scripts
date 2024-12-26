--千年の血族
---@param c Card
function c5130393.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(5130393,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetCountLimit(1,5130393)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(c5130393.spcon)
	e1:SetTarget(c5130393.sptg)
	e1:SetOperation(c5130393.spop)
	c:RegisterEffect(e1)
	--special summon or todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(5130393,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,5130394)
	e2:SetTarget(c5130393.tdtg)
	e2:SetOperation(c5130393.tdop)
	c:RegisterEffect(e2)
end
function c5130393.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and ev>=1000 and bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function c5130393.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c5130393.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c5130393.filter(c,e,tp)
	return c:GetTextAttack()>=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c5130393.thfilter(c)
	return c:GetTextAttack()>=0 and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c5130393.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c5130393.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c5130393.filter,tp,0,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c5130393.filter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c5130393.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local vc=tc:GetTextAttack()
	local sel=1
	local g=Duel.GetMatchingGroup(c5130393.thfilter,tp,0,LOCATION_DECK,nil)
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(5130393,2))
	if g:GetCount()>0 then
		sel=Duel.SelectOption(1-tp,1213,1214)
	else
		sel=Duel.SelectOption(1-tp,1214)+1
	end
	if sel==0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
		local sg=Duel.SelectMatchingCard(1-tp,c5130393.thfilter,tp,0,LOCATION_DECK,1,1,nil)
		Duel.ConfirmCards(tp,sg)
		if sg:GetFirst():GetTextAttack()<vc then
			Duel.ShuffleDeck(1-tp)
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	else
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
