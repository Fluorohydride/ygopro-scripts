--魔轟神獣ノズチ
function c55277252.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(55277252,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c55277252.tg)
	e1:SetOperation(c55277252.op)
	c:RegisterEffect(e1)
	--spsummon2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(55277252,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(c55277252.con2)
	e2:SetTarget(c55277252.tg2)
	e2:SetOperation(c55277252.op2)
	c:RegisterEffect(e2)
end
function c55277252.filter(c)
	return c:IsSetCard(0x35) and c:IsType(TYPE_MONSTER)
end
function c55277252.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c55277252.filter,tp,LOCATION_HAND,0,1,e:GetHandler())
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c55277252.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=aux.ExceptThisCard(e)
	local g=Duel.GetMatchingGroup(c55277252.filter,tp,LOCATION_HAND,0,ec)
	if #g==0 and ec then
		g:AddCard(ec)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT+REASON_DISCARD)>0 and tc:IsLocation(LOCATION_GRAVE)
		and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,false,false,POS_FACEUP)
	end
end
function c55277252.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function c55277252.filter2(c,e,tp)
	return c:IsLevelBelow(2) and c:IsSetCard(0x35) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c55277252.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c55277252.filter2,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c55277252.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c55277252.filter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
