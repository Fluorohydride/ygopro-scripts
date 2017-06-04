--ダブルツールD&C
function c63730624.initial_effect(c)
	aux.AddEquipProcedure(c,0,c63730624.filter,c63730624.eqlimit)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(c63730624.scon1)
	e3:SetValue(1000)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetCondition(c63730624.scon2)
	e4:SetOperation(c63730624.sop2)
	c:RegisterEffect(e4)
	--atk
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetCondition(c63730624.ocon1)
	e5:SetValue(c63730624.atlimit)
	c:RegisterEffect(e5)
	--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetDescription(aux.Stringid(63730624,0))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_DAMAGE_STEP_END)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c63730624.ocon2)
	e6:SetTarget(c63730624.otg2)
	e6:SetOperation(c63730624.oop2)
	c:RegisterEffect(e6)
end
function c63730624.eqlimit(e,c)
	return c:GetControler()==e:GetHandler():GetControler()
		and (c:IsCode(2403771) or (c:IsSetCard(0x26) and c:GetLevel()>=4 and c:IsRace(RACE_MACHINE)))
end
function c63730624.filter(c)
	return c:IsCode(2403771) or (c:IsSetCard(0x26) and c:GetLevel()>=4 and c:IsRace(RACE_MACHINE))
end
function c63730624.scon1(e)
	return e:GetHandler():GetEquipTarget() and Duel.GetTurnPlayer()==e:GetHandler():GetControler()
end
function c63730624.scon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetAttacker()==e:GetHandler():GetEquipTarget()
end
function c63730624.sop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.GetAttackTarget()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	d:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	d:RegisterEffect(e2)
end
function c63730624.ocon1(e)
	return Duel.GetTurnPlayer()~=e:GetHandler():GetControler()
end
function c63730624.atlimit(e,c)
	return c~=e:GetHandler():GetEquipTarget()
end
function c63730624.ocon2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return Duel.GetTurnPlayer()~=tp and d==e:GetHandler():GetEquipTarget() and a:IsRelateToBattle()
end
function c63730624.otg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,Duel.GetAttacker(),1,0,0)
end
function c63730624.oop2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if a:IsRelateToBattle() then
		Duel.Destroy(a,REASON_EFFECT)
	end
end
