--融合死円舞曲
function c34449261.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c34449261.target)
	e1:SetOperation(c34449261.activate)
	c:RegisterEffect(e1)
end
function c34449261.filter1(c,tp,chk)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsSetCard(0xad) and ((not chk)
		or Duel.IsExistingTarget(c34449261.filter2,tp,0,LOCATION_MZONE,1,nil))
end
function c34449261.filter2(c,tp,ex2)
	return c:IsFaceup() and c:IsType(TYPE_FUSION)
		and Duel.IsExistingMatchingCard(c34449261.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,ex2)
end
function c34449261.filter3(c,ex2)
	return c~=ex2 and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and c:IsDestructable()
end
function c34449261.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c34449261.filter1,tp,LOCATION_MZONE,0,1,nil,tp,true) end
	local g1=Duel.SelectTarget(tp,c34449261.filter1,tp,LOCATION_MZONE,0,1,1,nil,tp,false)
	local g2=Duel.SelectTarget(tp,c34449261.filter2,tp,0,LOCATION_MZONE,1,1,nil,tp,g1:GetFirst())
	local g3=Duel.GetMatchingGroup(c34449261.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,g1:GetFirst(),g2:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g3,g3:GetCount(),0,0)
	local dam=g3:GetSum(Card.GetAttack)
	if g3:FilterCount(Card.IsControler,nil,tp)>0 then Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,dam) end
	if g3:FilterCount(Card.IsControler,nil,1-tp)>0 then Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam) end
end
function c34449261.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc1,tc2=Duel.GetFirstTarget()
	local dam=tc1:GetAttack()+tc2:GetAttack()
	local g=Duel.GetMatchingGroup(c34449261.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,tc1,tc2)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		local dg=Duel.GetOperatedGroup()
		if dg:IsExists(aux.FilterEqualFunction(Card.GetPreviousControler,tp),1,nil) then Duel.Damage(tp,dam,REASON_EFFECT) end
		if dg:IsExists(aux.FilterEqualFunction(Card.GetPreviousControler,1-tp),1,nil) then Duel.Damage(1-tp,dam,REASON_EFFECT) end
	end
end
