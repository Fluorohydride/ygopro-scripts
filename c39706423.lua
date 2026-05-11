--GMX Suppression Squad
local s,id,o=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.hspcon)
	e1:SetTarget(s.hsptg)
	e1:SetOperation(s.hspop)
	c:RegisterEffect(e1)
	--change race
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DECKDES+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.exctg)
	e2:SetOperation(s.excop)
	c:RegisterEffect(e2)
end
function s.fieldfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x1dd) or c:IsRace(RACE_DINOSAUR))
end
function s.hspcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.fieldfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.tgfilter(c)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and not c:IsRace(RACE_DINOSAUR)
end
function s.exctgfilter(c)
	return c:IsRace(RACE_DINOSAUR) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function s.exctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsLocation(LOCATION_MZONE) and s.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(s.exctgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_DECK)
end
function s.deckdino(c)
	return c:IsRace(RACE_DINOSAUR) and c:IsType(TYPE_MONSTER)
end
function s.confirm_decktop_s(tp,count)
	local max_decktop=5
	if count>max_decktop then
		local g=Duel.GetDecktopGroup(tp,count)
		Duel.ConfirmCards(1-tp,g)
	else
		Duel.ConfirmDecktop(tp,count)
	end
end
function s.excop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(s.deckdino,tp,LOCATION_DECK,0,nil)
	if mg:GetCount()==0 then return end
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local seq=-1
	local qc=nil
	for sc in aux.Next(mg) do
		if sc:GetSequence()>seq then
			seq=sc:GetSequence()
			qc=sc
		end
	end
	if not qc then return end
	s.confirm_decktop_s(tp,dcount-seq)
	if e:GetHandler():IsSetCard(0x1dd) then
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+1595137,e,0,tp,tp,0)
	end
	if qc:IsAbleToGrave() then
		Duel.SendtoGrave(qc,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		local tc=Duel.GetFirstTarget()
		if not tc or not tc:IsRelateToChain() or not tc:IsFaceup() or not tc:IsOnField() then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(RACE_DINOSAUR)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
