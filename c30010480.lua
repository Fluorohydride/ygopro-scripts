--剛鬼サンダー・オーガ
function c30010480.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xfc),2)
	c:EnableReviveLimit()
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e1:SetValue(c30010480.sumval)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetOperation(c30010480.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(30010480,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabelObject(e2)
	e3:SetCondition(c30010480.atkcon)
	e3:SetOperation(c30010480.atkop)
	c:RegisterEffect(e3)
end
function c30010480.sumval(e,c)
	return e:GetHandler():GetLinkedZone()*0x10000
end
function c30010480.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetLinkedGroup()
	if not g then return end
	local lg=g:Clone()
	lg:KeepAlive()
	e:SetLabelObject(lg)
end
function c30010480.cfilter(c,g)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and g:IsContains(c)
end
function c30010480.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetLabelObject():GetLabelObject()
	if not lg then return false end
	return eg:IsExists(c30010480.cfilter,1,nil,lg)
end
function c30010480.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetValue(400)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
