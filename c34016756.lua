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
function c34016756.fselect(g)
	return g:IsExists(Card.IsAttackAbove,1,nil,1)
end
function c34016756.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	g=g:Filter(Card.IsCanBeEffectTarget,nil,e)
	if chk==0 then return g:CheckSubGroup(c34016756.fselect,2,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	Duel.SetTargetCard(g:SelectSubGroup(tp,c34016756.fselect,false,2,2))
end
function c34016756.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(34016756,0))
	local hc=g:Filter(Card.IsAttackAbove,nil,1):Select(tp,1,1,nil):GetFirst()
	local tc=g:GetFirst()
	if tc==hc then tc=g:GetNext() end
	if hc:IsFaceup() and hc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local atk=hc:GetAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(math.ceil(atk/2))
		if hc:RegisterEffect(e1) then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e2:SetValue(math.ceil(atk/2))
			tc:RegisterEffect(e2)
		end
	end
end
