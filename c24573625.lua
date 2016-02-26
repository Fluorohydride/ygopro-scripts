--ブンボーグ008
function c24573625.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c24573625.splimcon)
	e2:SetTarget(c24573625.splimit)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c24573625.value)
	c:RegisterEffect(e3)
	--attack twice
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_EXTRA_ATTACK)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e5:SetCondition(c24573625.dircon)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_ATTACK)
	e6:SetCondition(c24573625.atkcon2)
	c:RegisterEffect(e6)
	--cannot be target
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_MZONE)
	e7:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e7:SetTargetRange(0,0xff)
	e7:SetCode(EFFECT_CANNOT_SELECT_EFFECT_TARGET)
	e7:SetValue(c24573625.tglimit)
	c:RegisterEffect(e7)
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
	return c:IsFaceup() and c:IsSetCard(0xab) and c~=e:GetHandler() and c:IsLocation(LOCATION_ONFIELD) 
end
