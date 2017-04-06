--痛恨の訴え
function c32065885.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c32065885.ctlcon)
	e1:SetTarget(c32065885.ctltg)
	e1:SetOperation(c32065885.ctlop)
	c:RegisterEffect(e1)
end
function c32065885.ctlcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.GetAttackTarget()==nil and Duel.GetAttacker():IsControler(1-tp)
end
function c32065885.filter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged() and c:IsDefenseAbove(0)
end
function c32065885.ctltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32065885.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,1-tp,LOCATION_MZONE)
end
function c32065885.filter1(c)
	return c:IsFaceup() and c:IsDefenseAbove(0)
end
function c32065885.ctlop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c32065885.filter1,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	local sg=g:GetMaxGroup(Card.GetDefense)
	if sg:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		sg=sg:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
	end
	local tc=sg:GetFirst()
	if Duel.GetControl(tc,tp,PHASE_END,2)~=0 then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_ATTACK)
		e3:SetReset(RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e3)
	end
end
