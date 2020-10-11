--報復の隠し歯
function c47128571.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1,47128571+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c47128571.target)
	e1:SetOperation(c47128571.activate)
	c:RegisterEffect(e1)
end
function c47128571.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_ONFIELD,0,2,e:GetHandler()) end
	local sg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,2,0,0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c47128571.desfilter(c,def)
	return c:IsFaceup() and c:GetAttack()<=def
end
function c47128571.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_LINK) and c:IsLocation(LOCATION_GRAVE)
		and Duel.IsExistingMatchingCard(c47128571.desfilter,tp,0,LOCATION_MZONE,1,nil,c:GetDefense())
end
function c47128571.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,LOCATION_ONFIELD,0,2,2,nil)
	if g:GetCount()==2 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
		local sg=Duel.GetOperatedGroup()
		if sg:GetCount()>0 and Duel.NegateAttack() and sg:IsExists(c47128571.cfilter,1,nil,tp) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(47128571,0))
			local cg=sg:FilterSelect(tp,c47128571.cfilter,1,1,nil,tp)
			Duel.HintSelection(cg)
			local dg=Duel.GetMatchingGroup(c47128571.desfilter,tp,0,LOCATION_MZONE,nil,cg:GetFirst():GetDefense())
			if Duel.Destroy(dg,REASON_EFFECT)~=0 then
				Duel.BreakEffect()
				local turnp=Duel.GetTurnPlayer()
				Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
				Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
				Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CANNOT_BP)
				e1:SetTargetRange(1,0)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,turnp)
			end
		end
	end
end
