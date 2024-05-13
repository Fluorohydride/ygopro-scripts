--アラメシアの儀
function c3285551.initial_effect(c)
	aux.AddCodeList(c,3285552)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,3285551+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c3285551.condition)
	e1:SetCost(c3285551.cost)
	e1:SetTarget(c3285551.target)
	e1:SetOperation(c3285551.operation)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(3285551,ACTIVITY_CHAIN,c3285551.chainfilter)
end
function c3285551.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)
	return not (re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE and not rc:IsSummonType(SUMMON_TYPE_SPECIAL))
end
function c3285551.cfilter0(c)
	return c:IsCode(3285552) and c:IsFaceup()
end
function c3285551.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c3285551.cfilter0,tp,LOCATION_ONFIELD,0,1,nil)
end
function c3285551.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(3285551,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetValue(c3285551.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c3285551.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not rc:IsSummonType(SUMMON_TYPE_SPECIAL) and rc:IsLocation(LOCATION_MZONE)
end
function c3285551.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		Duel.IsPlayerCanSpecialSummonMonster(tp,3285552,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FAIRY,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c3285551.cfilter(c)
	return c:IsCode(39568067) and c:IsFaceup()
end
function c3285551.setfilter(c)
	return c:IsCode(39568067) and c:IsCanBePlacedOnField()
end
function c3285551.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,3285552,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FAIRY,ATTRIBUTE_EARTH) then return end
	local token=Duel.CreateToken(tp,3285552)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	local g=Duel.GetMatchingGroup(c3285551.setfilter,tp,LOCATION_DECK,0,nil)
	if not Duel.IsExistingMatchingCard(c3285551.cfilter,tp,LOCATION_SZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and g:GetCount()>0
		and Duel.SelectYesNo(tp,aux.Stringid(3285551,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg=g:Select(tp,1,1,nil)
		Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
