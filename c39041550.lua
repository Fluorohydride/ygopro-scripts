--coded by Lyris
--Beetrooper Scale Bomber
function c39041550.initial_effect(c)
	--You can only use each effect of "Beetrooper Scale Bomber" once per turn.
	--If an Insect monster(s) is Normal or Special Summoned to your field (except during the Damage Step): You can Special Summon this card from your hand.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1,39041550)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetCondition(function(e,tp,eg) return eg:IsExists(c39041550.filter,1,nil,tp) end)
	e0:SetTarget(c39041550.tg)
	e0:SetOperation(c39041550.op)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1)
	--When a monster your opponent controls activates its effect (Quick Effect): You can Tribute 1 Insect monster; destroy it.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,39041551)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetCondition(c39041550.condition)
	e2:SetCost(c39041550.cost)
	e2:SetTarget(c39041550.target)
	e2:SetOperation(c39041550.operation)
	c:RegisterEffect(e2)
end
function c39041550.filter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_INSECT) and c:IsControler(tp)
end
function c39041550.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c39041550.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
end
function c39041550.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsOnField() and re:GetHandler():IsRelateToEffect(re) and re:IsActiveType(TYPE_MONSTER)
end
function c39041550.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsRace,1,nil,RACE_INSECT) end
	Duel.Release(Duel.SelectReleaseGroup(tp,Card.IsRace,1,1,nil,RACE_INSECT),REASON_COST)
end
function c39041550.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function c39041550.operation(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

