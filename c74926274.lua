--ペンデュラム・アライズ
function c74926274.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,74926274+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c74926274.cost)
	e1:SetTarget(c74926274.target)
	e1:SetOperation(c74926274.activate)
	c:RegisterEffect(e1)
end
function c74926274.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c74926274.filter(c,e,tp)
	local lv=c:GetOriginalLevel()
	return lv>0 and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c74926274.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,lv)
end
function c74926274.spfilter(c,e,tp,lv)
	return c:IsType(TYPE_PENDULUM) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c74926274.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.IsExistingMatchingCard(c74926274.filter,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c74926274.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	e:SetLabel(g:GetFirst():GetOriginalLevel())
	Duel.SendtoGrave(g,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c74926274.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c74926274.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		aux.epreg(tc,tp,e:GetHandler(),74926274,c74926274.desop)
	end
end
function c74926274.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
end
