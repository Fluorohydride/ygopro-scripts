--GMX - VELOX
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion procedure
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,s.matfilter1,s.matfilter2,true)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.reccon)
	e1:SetOperation(s.recop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_END_PHASE)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.descon)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
end
function s.matfilter1(c)
	return c:IsFusionSetCard(0x1dd)
end
function s.matfilter2(c)
	return c:IsRace(RACE_DINOSAUR)
end
function s.cfilter(c,tp)
	return c:IsSummonPlayer(tp)
end
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,1-tp)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Recover(tp,200,REASON_EFFECT)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function s.thfilter(c,e,tp,chk)
	return (c:IsSetCard(0x1dd) and c:IsType(TYPE_MONSTER) or c:IsRace(RACE_DINOSAUR))
		and (not chk or c:IsAbleToHand() or Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp,true) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil,e,tp,false)
	local dct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local seq=-1
	local hc
	for dc in aux.Next(g) do
		local sq=dc:GetSequence()
		if sq>seq then
			seq=sq
			hc=dc
		end
	end
	if seq>-1 then
		Duel.ConfirmDecktop(tp,dct-seq)
		Duel.DisableShuffleCheck()
		Duel.SetLP(tp,Duel.GetLP(tp)-(dct-seq)*400)
		local spchk=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and hc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		if hc:IsAbleToHand() and (not spchk or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(hc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,hc)
		elseif spchk then
			Duel.SpecialSummon(hc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoGrave(hc,REASON_RULE)
		end
		Duel.ShuffleDeck(tp)
		if tc:IsRelateToChain() and tc:IsOnField() then
			Duel.BreakEffect()
			Duel.Destroy(tc,REASON_EFFECT)
		end
	else
		Duel.ConfirmDecktop(tp,dct)
	end
end
