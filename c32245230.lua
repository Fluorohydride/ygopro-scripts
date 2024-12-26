--運命の契約
---@param c Card
function c32245230.initial_effect(c)
	c:EnableCounterPermit(0x5e,LOCATION_SZONE)
	c:SetCounterLimit(0x5e,1)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(c32245230.ctop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(32245230,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,32245230)
	e2:SetCondition(c32245230.spcon)
	e2:SetCost(c32245230.spcost)
	e2:SetTarget(c32245230.sptg)
	e2:SetOperation(c32245230.spop)
	c:RegisterEffect(e2)
end
function c32245230.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c32245230.ctop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c32245230.cfilter,1,nil,tp) then
		e:GetHandler():AddCounter(0x5e,1)
	end
end
function c32245230.cfilter2(c,tp)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsSummonPlayer(1-tp)
end
function c32245230.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c32245230.cfilter2,1,nil,tp)
end
function c32245230.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x5e,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x5e,1,REASON_COST)
end
function c32245230.tgfilter(c)
	return (c:IsLocation(LOCATION_HAND+LOCATION_DECK) or c:IsFaceup())
		and c:IsCode(27062594) and c:IsAbleToGrave()
end
function c32245230.spfilter(c,e,tp)
	return c:IsSetCard(0x7f) and c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_LIGHT)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c32245230.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32245230.tgfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,nil)
		and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL) and e:GetHandler():IsCanOverlay()
		and Duel.IsExistingMatchingCard(c32245230.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c32245230.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c32245230.tgfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c32245230.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		local sc=sg:GetFirst()
		if sc then
			sc:SetMaterial(nil)
			if Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 then
				sc:CompleteProcedure()
				if c:IsRelateToEffect(e) and c:IsCanOverlay() then
					Duel.Overlay(sc,Group.FromCards(c))
				end
			end
		end
	end
end
