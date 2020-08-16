--銀河暴竜
function c24658418.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24658418,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c24658418.condition)
	e1:SetTarget(c24658418.target)
	e1:SetOperation(c24658418.operation)
	c:RegisterEffect(e1)
	--xyz
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24658418,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c24658418.spcon)
	e2:SetTarget(c24658418.sptg)
	e2:SetOperation(c24658418.spop)
	c:RegisterEffect(e2)
end
function c24658418.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return at:IsFaceup() and at:IsControler(tp) and at:IsSetCard(0x7b)
end
function c24658418.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c24658418.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
function c24658418.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function c24658418.mfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7b) and not c:IsType(TYPE_TOKEN)
end
function c24658418.xyzfilter(c,mg)
	return c:IsSetCard(0x7b) and c:IsXyzSummonable(mg)
end
function c24658418.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c24658418.mfilter,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(c24658418.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c24658418.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c24658418.mfilter,tp,LOCATION_MZONE,0,nil)
	local xyzg=Duel.GetMatchingGroup(c24658418.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g,1,5)
	end
end
