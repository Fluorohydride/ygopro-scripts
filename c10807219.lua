--ニュービー！
local s,id,o=GetID()
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
	--to hand and to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.accon)
	e2:SetTarget(s.actg)
	e2:SetOperation(s.acop)
	c:RegisterEffect(e2)
end
function s.filter(c)
	return c:IsAttack(0) and c:IsDefense(0) and c:IsType(TYPE_MONSTER)
end
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,c:GetControler(),LOCATION_GRAVE,0,1,nil)
end
function s.accon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonLocation(LOCATION_HAND)
end
function s.thfilter(c)
	return not c:IsCode(id) and c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToHand()
end
function s.tdfilter(c)
	return c:IsFaceupEx() and c:IsType(TYPE_TRAP) and c:IsAbleToDeck()
end
function s.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) or Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.tdfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	local res=false
	if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(id,2))) then
		res=true
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	if b2 and (not res or Duel.SelectYesNo(tp,aux.Stringid(id,3))) then
		if res then
			Duel.BreakEffect()
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.tdfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then
				Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
			else
				local opt=Duel.SelectOption(tp,aux.Stringid(id,4),aux.Stringid(id,5))
				if opt==0 then
					Duel.SendtoDeck(g,nil,SEQ_DECKTOP,REASON_EFFECT)
				else
					Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
				end
			end
		end
	end
end
