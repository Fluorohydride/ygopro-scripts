--海晶乙女潮流
function c84430165.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCountLimit(1,84430165+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c84430165.target)
	e1:SetOperation(c84430165.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c84430165.handcon)
	c:RegisterEffect(e2)
end
function c84430165.afilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x12b) and c:IsType(TYPE_LINK)
end
function c84430165.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c84430165.afilter,1,nil,tp) end
end
function c84430165.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x12b) and c:IsLinkAbove(2)
end
function c84430165.activate(e,tp,eg,ep,ev,re,r,rp)
	local a=eg:Filter(c84430165.afilter,nil,tp):GetFirst()
	local bc=a:GetBattleTarget()
	local dam=a:GetLink()
	if dam<0 then dam=0 end
	Duel.Damage(1-tp,dam*400,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(c84430165.cfilter,tp,LOCATION_MZONE,0,1,nil) and bc:IsType(TYPE_LINK) then
		local dam1=bc:GetLink()
		Duel.BreakEffect()
		Duel.Damage(1-tp,dam1*500,REASON_EFFECT)
	end
end
function c84430165.hcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x12b) and c:IsLinkAbove(3)
end
function c84430165.handcon(e)
	return Duel.IsExistingMatchingCard(c84430165.hcfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
