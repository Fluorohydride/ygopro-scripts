--RR－アーセナル・ファルコン
function c96157835.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,2)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(96157835,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c96157835.spcost1)
	e1:SetTarget(c96157835.sptg1)
	e1:SetOperation(c96157835.spop1)
	c:RegisterEffect(e1)
	--extra attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetCondition(c96157835.ctcon)
	e2:SetValue(c96157835.ctval)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(96157835,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c96157835.spcon2)
	e3:SetTarget(c96157835.sptg2)
	e3:SetOperation(c96157835.spop2)
	c:RegisterEffect(e3)
end
function c96157835.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c96157835.spfilter1(c,e,tp)
	return c:IsRace(RACE_WINDBEAST) and c:IsLevel(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c96157835.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c96157835.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c96157835.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c96157835.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c96157835.ctcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0xba)
end
function c96157835.ctval(e,c)
	return e:GetHandler():GetOverlayGroup():FilterCount(Card.IsSetCard,nil,0xba)-1
end
function c96157835.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0xba) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c96157835.spfilter2(c,e,tp)
	return c:IsSetCard(0xba) and c:IsType(TYPE_XYZ) and not c:IsCode(96157835) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c96157835.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c96157835.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and e:GetHandler():IsCanOverlay() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c96157835.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c96157835.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) then
			Duel.Overlay(tc,Group.FromCards(c))
		end
	end
end
