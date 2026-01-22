--クロス・アタック
function c46961802.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(46961802,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(aux.bpcon)
	e1:SetTarget(c46961802.target)
	e1:SetOperation(c46961802.activate)
	c:RegisterEffect(e1)
end
function c46961802.filter1(c,tp)
	return c:IsAttackPos() and Duel.IsExistingTarget(c46961802.filter2,tp,LOCATION_MZONE,0,1,c,c:GetAttack())
end
function c46961802.filter2(c,atk)
	return c:IsAttackPos() and c:IsAttack(atk)
end
function c46961802.tgfilter(c,e)
	return c:IsAttackPos() and c:IsCanBeEffectTarget(e)
end
function c46961802.gcheck(g)
	return g:GetFirst():GetAttack()==g:GetNext():GetAttack()
end
function c46961802.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c46961802.filter1,tp,LOCATION_MZONE,0,1,nil,tp) end
	local g=Duel.GetMatchingGroup(c46961802.tgfilter,tp,LOCATION_MZONE,0,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:SelectSubGroup(tp,c46961802.gcheck,false,2,2)
	Duel.SetTargetCard(sg)
end
function c46961802.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(46961802,1))
	local tc1=g:Select(tp,1,1,nil):GetFirst()
	local tc2=(g-tc1):GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc1:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc2:RegisterEffect(e2)
end
