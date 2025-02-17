--天斗輝巧極
function c89771220.initial_effect(c)
	aux.AddCodeList(c,89264428,58793369,97148796,27693363)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c89771220.target)
	e1:SetOperation(c89771220.activate)
	c:RegisterEffect(e1)
	--replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(89771220)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,89771220)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(16471775)
	c:RegisterEffect(e3)
end
function c89771220.deckconfilter(c)
	return c:IsCode(97148796,27693363) and c:IsFaceup()
end
function c89771220.deckcon(tp)
	return Duel.IsExistingMatchingCard(c89771220.deckconfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c89771220.cfilter(c)
	return c:IsCode(89264428,58793369) and c:IsAbleToRemove()
end
function c89771220.fselect(g,e,tp)
	return g:GetClassCount(Card.GetCode)==2 and g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
		and Duel.IsExistingMatchingCard(c89771220.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,g)
end
function c89771220.spfilter(c,e,tp,g)
	return c:IsCode(33250142) and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
		and Duel.GetLocationCountFromEx(tp,tp,g,c)>0
end
function c89771220.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND+LOCATION_ONFIELD
	if c89771220.deckcon(tp) then loc=loc|LOCATION_DECK end
	local g=Duel.GetMatchingGroup(c89771220.cfilter,tp,loc,0,nil)
	if chk==0 then return g:CheckSubGroup(c89771220.fselect,2,2,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c89771220.activate(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_HAND+LOCATION_ONFIELD
	if c89771220.deckcon(tp) then loc=loc|LOCATION_DECK end
	local g=Duel.GetMatchingGroup(c89771220.cfilter,tp,loc,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:SelectSubGroup(tp,c89771220.fselect,false,2,2,e,tp)
	if rg and Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c89771220.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil)
		if #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,true,POS_FACEUP)
			sg:GetFirst():CompleteProcedure()
		end
	end
end
