--クリシュナード・ウィッチ
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,885016)
	--effect indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.indcon)
	e1:SetValue(aux.indoval)
	c:RegisterEffect(e1)
	--self_spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+o*2)
	e3:SetCondition(s.tdcon)
	e3:SetTarget(s.tdtg)
	e3:SetOperation(s.tdop)
	c:RegisterEffect(e3)
end
function s.indfilter(c)
	return c:IsFaceup() and c:IsCode(885016)
end
function s.indcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(s.indfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function s.spfilter(c,tp)
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_FZONE)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.spfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return bit.band(re:GetActivateLocation(),LOCATION_SZONE)~=0 and bit.band(re:GetActiveType(),TYPE_FIELD)~=0 and not re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.tdfilter(c,e,tp)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsType(TYPE_MONSTER)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.tdfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local rc=re:GetHandler()
		local res=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and aux.IsCodeListed(tc,re:GetHandler():GetCode())
		if res and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.HintSelection(g)
			Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end
