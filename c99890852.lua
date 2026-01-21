--トリックスター・ブーケ
function c99890852.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,99890852)
	e1:SetTarget(c99890852.target)
	e1:SetOperation(c99890852.activate)
	c:RegisterEffect(e1)
end
function c99890852.filter(c,tp)
	return c99890852.thfilter(c,tp)
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
end
function c99890852.thfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xfb) and c:IsControler(tp)
		and c:IsAbleToHand() and not c:IsExtraDeckMonster()
end
function c99890852.gcheck(g,tp)
	return g:IsExists(c99890852.thfilter,1,nil,tp)
end
function c99890852.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c99890852.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	g=g:Filter(Card.IsCanBeEffectTarget,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:SelectSubGroup(tp,c99890852.gcheck,false,2,2,tp)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c99890852.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g==0 then return end
	local tg=g:Filter(c99890852.thfilter,nil,tp)
	local tc1=tg:GetFirst()
	if #tg>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		tc1=tg:Select(tp,1,1,nil):GetFirst()
	end
	if not tc1 then return end
	local tc2=(g-tc1):GetFirst()
	if Duel.SendtoHand(tc1,nil,REASON_EFFECT)~=0 and tc2 and tc2:IsFaceup() then
		local atk=tc1:GetBaseAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc2:RegisterEffect(e1)
	end
end
