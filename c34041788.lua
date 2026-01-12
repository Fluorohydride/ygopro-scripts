--エンディミオン皇国
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,96228804)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.desreptg)
	e2:SetValue(s.desrepval)
	e2:SetOperation(s.desrepop)
	c:RegisterEffect(e2)
end
function s.thfilter(c)
	return (c:IsCode(96228804) or aux.IsCodeListed(c,96228804) and c:IsType(TYPE_MONSTER)) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.spfilter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
			and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
			and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			Duel.ShuffleHand(tp)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.repfilter(c,tp)
	return c:IsControler(tp) and c:IsOnField()
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function s.desfilter(c,e,tp)
	return c:IsFaceupEx() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE+LOCATION_HAND) and c:IsCode(96228804)
		and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,e,tp) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,e,tp)
		e:SetLabelObject(g:GetFirst())
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	end
	return false
end
function s.desrepval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end
