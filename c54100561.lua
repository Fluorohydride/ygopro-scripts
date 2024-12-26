--ファドレミコード・ファンシア
---@param c Card
function c54100561.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--cannot disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e1:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(c54100561.distg)
	c:RegisterEffect(e1)
	--to extra
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(54100561,0))
	e2:SetCategory(CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,54100561)
	e2:SetTarget(c54100561.tetg)
	e2:SetOperation(c54100561.teop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c54100561.repcon)
	e3:SetTarget(c54100561.reptg)
	e3:SetValue(c54100561.repval)
	c:RegisterEffect(e3)
end
function c54100561.distg(e,c)
	return c:IsControler(e:GetHandlerPlayer()) and c:IsSetCard(0x162) and c:IsType(TYPE_PENDULUM) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c54100561.tefilter(c)
	return not c:IsCode(54100561) and c:IsSetCard(0x162) and c:IsType(TYPE_PENDULUM)
end
function c54100561.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c54100561.tefilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function c54100561.teop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(54100561,1))
	local g=Duel.SelectMatchingCard(tp,c54100561.tefilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoExtraP(g,nil,REASON_EFFECT)
	end
end
function c54100561.pfilter(c)
	return c:GetCurrentScale()%2~=0
end
function c54100561.repcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c54100561.pfilter,tp,LOCATION_PZONE,0,1,nil)
end
function c54100561.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x162) and c:IsType(TYPE_PENDULUM)
		and c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c54100561.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED) and eg:IsExists(c54100561.repfilter,1,c,tp) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Destroy(c,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
function c54100561.repval(e,c)
	return c54100561.repfilter(c,e:GetHandlerPlayer())
end
