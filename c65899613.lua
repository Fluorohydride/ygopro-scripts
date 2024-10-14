--B・F－必中のピン
---@param c Card
function c65899613.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65899613)
	e1:SetCondition(c65899613.spcon)
	e1:SetTarget(c65899613.sptg)
	e1:SetOperation(c65899613.spop)
	c:RegisterEffect(e1)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,65899614)
	e3:SetTarget(c65899613.damtg)
	e3:SetOperation(c65899613.damop)
	c:RegisterEffect(e3)
end
function c65899613.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT)
end
function c65899613.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c65899613.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c65899613.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c65899613.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c65899613.damfilter(c)
	return c:IsFaceup() and c:IsCode(65899613)
end
function c65899613.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65899613.damfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	local val=Duel.GetMatchingGroupCount(c65899613.damfilter,tp,LOCATION_ONFIELD,0,nil)*200
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(val)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,val)
end
function c65899613.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local val=Duel.GetMatchingGroupCount(c65899613.damfilter,tp,LOCATION_ONFIELD,0,nil)*200
	Duel.Damage(p,val,REASON_EFFECT)
end
