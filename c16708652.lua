--カラクリ粉
function c16708652.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(c16708652.condition)
	e1:SetTarget(c16708652.target)
	e1:SetOperation(c16708652.activate)
	c:RegisterEffect(e1)
end
function c16708652.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and aux.dscon(e,tp,eg,ep,ev,re,r,rp)
end
function c16708652.atkfilter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanChangePosition() and c:IsAttackAbove(1)
end
function c16708652.filter1(c,tp)
	return c16708652.atkfilter(c) and c:IsSetCard(0x11)
		and Duel.IsExistingTarget(c16708652.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
end
function c16708652.filter2(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsSetCard(0x11)
end
function c16708652.tgfilter(c,e)
	return c16708652.filter2(c) and c:IsCanBeEffectTarget(e)
end
function c16708652.gcheck(g)
	return g:IsExists(c16708652.atkfilter,1,nil)
end
function c16708652.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c16708652.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	local g=Duel.GetMatchingGroup(c16708652.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:SelectSubGroup(tp,c16708652.gcheck,false,2,2)
	Duel.SetTargetCard(sg)
end
function c16708652.atkfilter2(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanChangePosition()
end
function c16708652.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(16708652,0))
	local tc1=g:FilterSelect(tp,c16708652.atkfilter,1,1,nil):GetFirst()
	if not tc1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(16708652,0))
		tc1=g:FilterSelect(tp,c16708652.atkfilter2,1,1,nil):GetFirst()
	end
	if not tc1 then return end
	local tc2=(g-tc1):GetFirst()
	if Duel.ChangePosition(tc1,POS_FACEUP_DEFENSE)>0 and tc2 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(tc1:GetAttack())
		tc2:RegisterEffect(e1)
	end
end
