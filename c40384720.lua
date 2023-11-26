--ソニック・シューター
function c40384720.initial_effect(c)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(c40384720.dircon)
	c:RegisterEffect(e1)
	--damage reduce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e2:SetCondition(c40384720.rdcon)
	e2:SetValue(c40384720.rdval)
	c:RegisterEffect(e2)
end
function c40384720.dfilter(c)
	return c:GetSequence()<5
end
function c40384720.dircon(e)
	return not Duel.IsExistingMatchingCard(c40384720.dfilter,e:GetHandlerPlayer(),0,LOCATION_SZONE,1,nil)
end
function c40384720.rdcon(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return Duel.GetAttackTarget()==nil
		and c:GetEffectCount(EFFECT_DIRECT_ATTACK)<2 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c40384720.rdval(e,damp)
	if damp~=1-e:GetHandlerPlayer() then return -1 end
	local c=e:GetHandler()
	local ue,ec,ev=e,c,e:GetValue()
	local dv,dv1=c:GetBaseAttack(),c:GetBaseAttack()
	local efs,pefs={c:IsHasEffect(EFFECT_CHANGE_BATTLE_DAMAGE)},{Duel.IsPlayerAffectedByEffect(damp,EFFECT_CHANGE_BATTLE_DAMAGE)}
	for k, ce in pairs(efs) do
		ev,ec=ce:GetValue(),ce:GetHandler()
		if ec~=c then
			if ev>-1 then dv1=ev else dv1=ev(ce,damp) end
		end
		if dv1<dv then dv=dv1 ue=ce end
	end
	for k, pe in pairs(pefs) do
		ev,ec=pe:GetValue(),pe:GetHandler()
		if ec~=c then
			if ev>-1 then dv1=ev else dv1=ev(pe,damp) end
		end
		if dv1<dv then dv=dv1 ue=pe end
	end
end