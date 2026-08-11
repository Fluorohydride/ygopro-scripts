--攻撃誘導アーマー
function c3103067.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1,3103067+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c3103067.target)
	e1:SetOperation(c3103067.operation)
	c:RegisterEffect(e1)
end
function c3103067.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local a,d=Duel.GetBattleMonster(0)
	local ad=Group.FromCards(a,d)
	local s=0
	local b=Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,ad)
	if b then
		s=Duel.SelectOption(tp,aux.Stringid(3103067,0),aux.Stringid(3103067,1))
	end
	e:SetLabel(s)
	if s==0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,a,1,0,0)
	end
	if s==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,ad)
	end
end
function c3103067.operation(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if not a or not a:IsRelateToBattle() then return end
	if e:GetLabel()==0 then
		Duel.Destroy(a,REASON_EFFECT)
	end
	if e:GetLabel()==1 then
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) and a:IsAttackable() and not a:IsImmuneToEffect(e) then
			Duel.CalculateDamage(a,tc)
		end
	end
end
