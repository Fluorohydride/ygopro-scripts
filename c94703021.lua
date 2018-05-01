--クラスター・コンジェスター
function c94703021.initial_effect(c)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,94703021)
	e1:SetCondition(c94703021.tkcon1)
	e1:SetTarget(c94703021.tktg1)
	e1:SetOperation(c94703021.tkop1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--tokens
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMING_BATTLE_PHASE)
	e3:SetCondition(c94703021.tkcon2)
	e3:SetCost(c94703021.tkcost2)
	e3:SetTarget(c94703021.tktg2)
	e3:SetOperation(c94703021.tkop2)
	c:RegisterEffect(e3)
end
function c94703021.tkcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_LINK)==0
end
function c94703021.tktg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,94703022,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
end
function c94703021.tkop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,94703022,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_DARK) then
		local tk=Duel.CreateToken(tp,94703022)
		Duel.SpecialSummon(tk,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c94703021.tkcon2(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_LINK)
	return at and g:IsContains(at)
end
function c94703021.tkcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0)
		and Duel.GetAttackTarget() and Duel.GetAttackTarget():IsAbleToRemoveAsCost() and Duel.GetMZoneCount(tp,Duel.GetAttackTarget())>0 end
	local g=Group.FromCards(e:GetHandler(),Duel.GetAttackTarget())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c94703021.tktg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_MZONE,1,nil,TYPE_LINK)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,94703022,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
end
function c94703021.tkop2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,94703022,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_DARK) then return end
	local ct=math.min(Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_MZONE,nil,TYPE_LINK),(Duel.GetLocationCount(tp,LOCATION_MZONE)))
	if ct<1 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	repeat
		local token=Duel.CreateToken(tp,94703022)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		ct=ct-1
	until ct<=0 or not Duel.SelectYesNo(tp,aux.Stringid(94703021,0))
	Duel.SpecialSummonComplete()
end
