--神秘の中華なべ
function c80161395.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c80161395.cost)
	e1:SetTarget(c80161395.target)
	e1:SetOperation(c80161395.activate)
	c:RegisterEffect(e1)
end
function c80161395.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,nil) end
	local sg=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
	local tc=sg:GetFirst()
	local atk=tc:GetAttack()
	local def=tc:GetDefense()
	local isdef=tc:IsDefenseAbove(0)
	Duel.Release(tc,REASON_COST)
	local sel=0
	if isdef then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(80161395,0))
		sel=Duel.SelectOption(tp,aux.Stringid(80161395,1),aux.Stringid(80161395,2))
	end
	if sel==0 then e:SetLabel(atk)
	else e:SetLabel(def) end
end
function c80161395.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetLabel())
end
function c80161395.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
