--宝玉の氾濫
function c72881007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c72881007.cost)
	e1:SetTarget(c72881007.target)
	e1:SetOperation(c72881007.activate)
	c:RegisterEffect(e1)
end
function c72881007.costfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1034) and c:IsAbleToGraveAsCost() and c:GetSequence()<5
end
function c72881007.gcheck(g,tg)
	return tg:FilterCount(aux.TRUE,g)>0
end
function c72881007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c72881007.costfilter,tp,LOCATION_SZONE,0,nil)
	local tg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if chk==0 then return g:CheckSubGroup(c72881007.gcheck,4,4,tg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,c72881007.gcheck,false,4,4,tg)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c72881007.filter(c,e,tp)
	return c:IsSetCard(0x1034) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c72881007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if chk==0 then return e:IsCostChecked() or #tg>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tg,#tg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c72881007.ctfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsLocation(LOCATION_GRAVE)
end
function c72881007.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.SendtoGrave(g,REASON_EFFECT)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(c72881007.ctfilter,nil,1-tp)
	if ft>ct then ft=ct end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	g=Duel.SelectMatchingCard(tp,c72881007.filter,tp,LOCATION_GRAVE,0,ft,ft,nil,e,tp)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
