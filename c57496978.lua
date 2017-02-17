--ぶつかり合う魂
function c57496978.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(c57496978.condition)
	e1:SetOperation(c57496978.activate)
	c:RegisterEffect(e1)
end
function c57496978.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a:IsControler(1-tp) then a=Duel.GetAttackTarget() d=Duel.GetAttacker() end
	return a and d and a:IsAttackPos() and d:IsAttackPos() and a:GetAttack()<d:GetAttack()
end
function c57496978.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a:IsFaceup() and a:IsRelateToBattle() and d:IsFaceup() and d:IsRelateToBattle() then
		local g=Group.FromCards(a,d)
		local chk=true
		while chk do
			local tg=g:GetMinGroup(Card.GetAttack)
			local tc=tg:GetFirst()
			if tg:GetCount()==1 and Duel.CheckLPCost(tc:GetControler(),500)
				and Duel.SelectYesNo(tc:GetControler(),aux.Stringid(57496978,0)) then
				Duel.PayLPCost(tc:GetControler(),500)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(500)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
				tg:GetFirst():RegisterEffect(e1)
			else
				chk=false
			end
		end
		g:KeepAlive()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e2:SetOperation(c57496978.damop)
		e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_BATTLED)
		e3:SetLabelObject(g)
		e3:SetOperation(c57496978.tgop)
		e3:SetReset(RESET_PHASE+PHASE_DAMAGE)
		Duel.RegisterEffect(e3,tp)
	end
end
function c57496978.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,0)
	Duel.ChangeBattleDamage(1-tp,0)
end
function c57496978.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(Card.IsStatus,nil,STATUS_BATTLE_DESTROYED)
	local tg=Group.CreateGroup()
	if g:IsExists(Card.IsControler,1,nil,tp) then
		local g1=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
		tg:Merge(g1)
	end
	if g:IsExists(Card.IsControler,1,nil,1-tp) then
		local g2=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
		tg:Merge(g2)
	end
	if tg:GetCount()>0 then
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end
