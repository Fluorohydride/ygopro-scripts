--ダイヤモンドダストン
function c96857854.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c96857854.condition)
	e1:SetTarget(c96857854.target)
	e1:SetOperation(c96857854.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(96857854,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCost(c96857854.spcost)
	e2:SetTarget(c96857854.sptg)
	e2:SetOperation(c96857854.spop)
	c:RegisterEffect(e2)
end
function c96857854.cfilter(c)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c96857854.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c96857854.cfilter,1,nil)
end
function c96857854.filter(c,e,tp)
	return c:IsSetCard(0x80) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp))
end
function c96857854.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=eg:GetCount()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)+Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if chk==0 then return (not Duel.IsPlayerAffectedByEffect(tp,59822133) or ct==1) and ft>=ct
		and Duel.IsExistingMatchingCard(c96857854.filter,tp,LOCATION_DECK+LOCATION_HAND,0,ct,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,tp,LOCATION_DECK+LOCATION_HAND)
end
function c96857854.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:GetCount()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) and ct>1 then return end
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if ft1<=0 and ft2<=0 then return end
	if ft1+ft2<ct then return end
	local g=Duel.GetMatchingGroup(c96857854.filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	if ct>g:GetCount() then return end
	if ft2>ct then ft2=ct end
	local ct2=ct-ft1
	local tc=nil
	if ft2>0 and (ct2>0 or Duel.SelectYesNo(tp,aux.Stringid(96857854,0))) then
		if ct2<=0 then ct2=1 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg1=g:FilterSelect(tp,Card.IsCanBeSpecialSummoned,ct2,ft2,nil,e,0,tp,false,false,POS_FACEUP,1-tp)
		tc=sg1:GetFirst()
		g:Sub(sg1)
		ct=ct-sg1:GetCount()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,1-tp,false,false,POS_FACEUP)
			tc=sg1:GetNext()
		end
	end
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=g:Select(tp,ct,ct,nil)
		tc=sg2:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			tc=sg2:GetNext()
		end
	end
	Duel.SpecialSummonComplete()
end
function c96857854.spfilter(c)
	return c:IsSetCard(0x80) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c96857854.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c96857854.spfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c96857854.spfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c96857854.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,96857854,0,0x11,0,1000,1,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c96857854.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,96857854,0,0x11,0,1000,1,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE,1-tp) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummonStep(c,0,tp,1-tp,true,false,POS_FACEUP_DEFENSE)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		c:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e3,true)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		c:RegisterEffect(e4,true)
		local e5=e3:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		c:RegisterEffect(e5,true)
		Duel.SpecialSummonComplete()
	end
end
