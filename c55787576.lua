--星遺物－『星盾』
function c55787576.initial_effect(c)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c55787576.immval)
	c:RegisterEffect(e1)
	--cannot be target/indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(c55787576.tgtg)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(55787576,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,55787576)
	e4:SetCost(c55787576.spcost)
	e4:SetTarget(c55787576.sptg)
	e4:SetOperation(c55787576.spop)
	c:RegisterEffect(e4)
end
function c55787576.immval(e,te)
	local tc=te:GetHandler()
	return te:GetOwner()~=e:GetHandler() and te:IsActiveType(TYPE_MONSTER)
		and te:IsActivated() and tc:IsSummonType(SUMMON_TYPE_SPECIAL) and tc:GetSummonLocation()==LOCATION_EXTRA
end
function c55787576.tgtg(e,c)
	return e:GetHandler()==c or (c:IsSetCard(0xfe) and e:GetHandler():GetColumnGroup():IsContains(c))
end
function c55787576.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c55787576.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c55787576.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c55787576.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c55787576.spfilter),1-tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
		if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
			and g:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(55787576,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.SpecialSummon(sg,0,1-tp,1-tp,false,false,POS_FACEUP)
		end
	end
end
