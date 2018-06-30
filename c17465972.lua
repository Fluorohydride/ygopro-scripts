--BF－南風のアウステル
function c17465972.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17465972,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c17465972.sumtg)
	e2:SetOperation(c17465972.sumop)
	c:RegisterEffect(e2)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17465972,1))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c17465972.cttg1)
	e3:SetOperation(c17465972.ctop1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(17465972,2))
	e4:SetTarget(c17465972.cttg2)
	e4:SetOperation(c17465972.ctop2)
	c:RegisterEffect(e4)
end
function c17465972.filter(c,e,tp)
	return c:IsFaceup() and c:IsLevelBelow(4) and c:IsSetCard(0x33) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c17465972.sumtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c17465972.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c17465972.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c17465972.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c17465972.sumop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c17465972.ctfilter1(c,ct)
	return c:IsFaceup() and c:IsCode(9012916) and c:IsCanAddCounter(0x10,ct)
end
function c17465972.cttg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(c17465972.ctfilter1,tp,LOCATION_MZONE,0,1,nil,ct) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,ct,0,0x10)
end
function c17465972.ctop1(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	if ct>0 then
		local g=Duel.SelectMatchingCard(tp,c17465972.ctfilter1,tp,LOCATION_MZONE,0,1,1,nil,ct)
		local tc=g:GetFirst()
		if tc then
			tc:AddCounter(0x10,ct)
		end
	end
end
function c17465972.ctfilter2(c)
	return c:IsFaceup() and c:GetCounter(0x1002)==0 and c:IsCanAddCounter(0x1002,1)
end
function c17465972.cttg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17465972.ctfilter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x1002)
end
function c17465972.ctop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c17465972.ctfilter2,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1002,1)
		tc=g:GetNext()
	end
end
