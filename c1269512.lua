--FA－ホープ・レイ・ランサー
function c1269512.initial_effect(c)
	aux.AddXyzProcedure(c,nil,4,3,c1269512.ovfilter,aux.Stringid(1269512,0),3,c1269512.xyzop)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-500)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1269512,2))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c1269512.distg)
	e2:SetOperation(c1269512.disop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1269512,3))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCountLimit(1)
	e3:SetCondition(c1269512.atcon)
	e3:SetCost(c1269512.atcost)
	e3:SetOperation(c1269512.atop)
	c:RegisterEffect(e3)
end
function c1269512.cfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
end
function c1269512.ovfilter(c)
	return c:IsFaceup() and c:IsRankBelow(4)
end
function c1269512.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,1269512)==0 and Duel.IsExistingMatchingCard(c1269512.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c1269512.cfilter,1,1,REASON_COST+REASON_DISCARD)
	Duel.RegisterFlagEffect(tp,1269512,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c1269512.filter(c)
	return aux.NegateMonsterFilter(c) and c:IsAttackPos()
end
function c1269512.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1269512.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c1269512.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function c1269512.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c1269512.filter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
function c1269512.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and aux.bdocon(e,tp,eg,ep,ev,re,r,rp) and c:IsChainAttackable()
end
function c1269512.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c1269512.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end