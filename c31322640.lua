--魅惑の宮殿
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--update atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_SPELLCASTER))
	e2:SetValue(500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(s.spcost)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	--grant effect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(s.eftg)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	--search or spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,1))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(3,id)
	e6:SetCost(s.thcost)
	e6:SetTarget(s.thtg)
	e6:SetOperation(s.thop)
	c:RegisterEffect(e6)
end
function s.costfilter(c,code)
	return c:GetFlagEffect(code)~=0
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local qg=e:GetHandler():GetEquipGroup()
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and qg:IsExists(s.costfilter,1,nil,e:GetHandler():GetCode())  end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.spfilter(c,e,tp)
	return c:IsAttackBelow(1500) and c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp,e:GetHandler():GetCode()) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.eftg(e,c)
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x3)
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.thfilter(c,e,tp)
	if not (c:IsSetCard(0x3) and c:IsType(TYPE_MONSTER)) then return false end
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	return c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp))
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP)
		end
	end
end