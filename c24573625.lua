--ブンボーグ008
function c24573625.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c24573625.splimcon)
	e1:SetTarget(c24573625.splimit)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c24573625.value)
	c:RegisterEffect(e2)
	--attack twice
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e4:SetCondition(c24573625.dircon)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_ATTACK)
	e5:SetCondition(c24573625.atkcon2)
	c:RegisterEffect(e5)
	--cannot be target
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e6:SetTargetRange(0,0xff)
	e6:SetCode(EFFECT_CANNOT_SELECT_EFFECT_TARGET)
	e6:SetValue(c24573625.tglimit)
	c:RegisterEffect(e6)
end
function c24573625.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c24573625.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xab) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c24573625.value(e,c)
	return Duel.GetMatchingGroupCount(Card.IsSetCard,c:GetControler(),LOCATION_GRAVE,0,nil,0xab)*500
end
function c24573625.dircon(e)
	return e:GetHandler():GetAttackAnnouncedCount()>0
end
function c24573625.atkcon2(e)
	return e:GetHandler():IsDirectAttacked()
end
function c24573625.tglimit(e,re,c)
	return c:IsFaceup() and c:IsSetCard(0xab) and c~=e:GetHandler()
end
