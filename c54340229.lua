--聖天樹の開花
function c54340229.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,54340229+EFFECT_COUNT_CODE_OATH)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c54340229.acttg)
	e1:SetOperation(c54340229.actop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(54340229,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,54340230)
	e2:SetCondition(c54340229.atkcon)
	e2:SetTarget(c54340229.atktg)
	e2:SetOperation(c54340229.atkop)
	c:RegisterEffect(e2)
end
function c54340229.lkfilter(c)
	return c:IsRace(RACE_PLANT) and c:IsType(TYPE_LINK) and c:IsLinkAbove(4)
end
function c54340229.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.IsExistingMatchingCard(c54340229.lkfilter,tp,LOCATION_MZONE,0,1,nil) then
		local g=Duel.GetMatchingGroup(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
	end
end
function c54340229.actop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c54340229.lkfilter,tp,LOCATION_MZONE,0,1,nil) then
		local g=Duel.GetMatchingGroup(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,nil)
		local tc=g:GetFirst()
		while tc do
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			tc=g:GetNext()
		end
	end
end
function c54340229.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetBattleMonster(tp)
	return tc and tc:IsRace(RACE_PLANT) and tc:IsType(TYPE_LINK)
end
function c54340229.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetBattleMonster(tp)
	local lg=tc:GetLinkedGroup():Filter(Card.IsFaceup,nil)
	if chk==0 then return #lg>0 and lg:GetSum(Card.GetAttack)>0 end
end
function c54340229.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetBattleMonster(tp)
	if not tc:IsRelateToBattle() then return end
	local lg=tc:GetLinkedGroup():Filter(Card.IsFaceup,nil)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(lg:GetSum(Card.GetAttack))
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
end
