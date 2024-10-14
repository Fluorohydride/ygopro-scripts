--光来する奇跡
---@param c Card
function c365213.initial_effect(c)
	aux.AddCodeList(c,44508094)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c365213.target)
	e1:SetOperation(c365213.activate)
	c:RegisterEffect(e1)
	--cannot to deck
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TO_DECK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(c365213.tdlimit)
	c:RegisterEffect(e2)
	--apply
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(365213,0))
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c365213.opcon)
	e3:SetTarget(c365213.optg)
	e3:SetOperation(c365213.opop)
	c:RegisterEffect(e3)
end
function c365213.tdfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsLevel(1) and (c:IsAbleToDeck() or c:IsLocation(LOCATION_DECK))
end
function c365213.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c365213.tdfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
end
function c365213.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.GetMatchingGroup(c365213.tdfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc:IsLocation(LOCATION_DECK) then
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(tc,SEQ_DECKTOP)
			Duel.ConfirmDecktop(tp,1)
		else
			Duel.ConfirmCards(1-tp,tc)
			Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)
		end
	end
end
function c365213.tdlimit(e,c)
	return (c:IsCode(44508094) or c:IsType(TYPE_SYNCHRO) and aux.IsCodeListed(c,44508094)) and c:IsOnField()
end
function c365213.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c365213.opcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c365213.cfilter,1,nil)
end
function c365213.spfilter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c365213.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsPlayerCanDraw(tp,1)
		and Duel.GetFlagEffect(tp,365213)==0
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c365213.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		and Duel.GetFlagEffect(tp,365214)==0
	if chk==0 then return b1 or b2 end
end
function c365213.opop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsPlayerCanDraw(tp,1)
		and Duel.GetFlagEffect(tp,365213)==0
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c365213.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		and Duel.GetFlagEffect(tp,365214)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(365213,1),aux.Stringid(365213,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(365213,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(365213,2))+1
	else return end
	if op==0 then
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,365213,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c365213.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		Duel.RegisterFlagEffect(tp,365214,RESET_PHASE+PHASE_END,0,1)
	end
end
