--フォース
function c34016756.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c34016756.target)
	e1:SetOperation(c34016756.activate)
	c:RegisterEffect(e1)
end
function c34016756.tgfilter(c,e)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function c34016756.gcheck(g)
	return g:IsExists(Card.IsAttackAbove,1,nil,1)
end
function c34016756.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c34016756.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	if chk==0 then return g:CheckSubGroup(c34016756.gcheck,2,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=g:SelectSubGroup(tp,c34016756.gcheck,false,2,2)
	Duel.SetTargetCard(tg)
end
function c34016756.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if g:FilterCount(Card.IsFaceup,nil)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(34016756,0))
	local tc1=g:FilterSelect(tp,Card.IsAttackAbove,1,1,nil,1):GetFirst()
	local tc2=(g-tc1):GetFirst()
	local atk=tc1:GetAttack()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(math.ceil(atk/2))
	if tc1:RegisterEffect(e1) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetValue(math.ceil(atk/2))
		tc2:RegisterEffect(e2)
	end
end
