--チューナーズ・ハイ
function c85821180.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCost(c85821180.cost)
	e1:SetTarget(c85821180.target)
	e1:SetOperation(c85821180.activate)
	c:RegisterEffect(e1)
end

function c85821180.fil1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable() and Duel.IsExistingMatchingCard(c85821180.fil2,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c85821180.fil2(c,e,tp,dc)
	return c:IsType(TYPE_TUNER) and c:IsRace(dc:GetRace()) and c:IsAttribute(dc:GetAttribute()) and c:GetLevel()==(dc:GetLevel()+1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c85821180.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c85821180.fil1,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c85821180.fil1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	e:SetLabelObject(g:GetFirst())
end
function c85821180.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c85821180.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.SelectMatchingCard(tp,c85821180.fil2,tp,LOCATION_DECK,0,1,1,nil,e,tp,e:GetLabelObject())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end